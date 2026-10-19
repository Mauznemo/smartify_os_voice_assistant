import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:smartify_os_core/utils.dart';
import 'package:smartify_os_voice_assistant/src/i18n/strings.g.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/models/wake_word_teaching.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech/speech_worker.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/speech_model_store.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/speech_models.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/voice_assistant_service.dart';

/// Internal: teaches the car how the driver says the wake word.
///
/// The driver says it a few times. Each time is recorded and written down by
/// the recognizer ("Hey Miyata", "Hey Meata"), which gives candidate
/// spellings. Each candidate is then tried against every recording with the
/// wake word model itself, and the few that together hear the most of them
/// are kept. So the spellings are picked by how well they hear this driver,
/// not by how they look.
class WakeWordTeacher {
  static const _tag = 'VoiceAssistant.Teach';

  /// How many times the driver says it.
  static const wanted = 8;

  /// The most spellings it learns, so the wake word stays quick to load and
  /// does not start for everything that sounds a bit like it.
  static const maxLearned = 5;

  static final WakeWordTeacher instance = WakeWordTeacher._();
  WakeWordTeacher._();

  /// Where teaching has got to.
  final ValueNotifier<WakeWordTeaching> state = ValueNotifier(
    const WakeWordTeaching.idle(),
  );

  final List<Float32List> _clips = [];
  final List<String> _heard = [];
  StreamSubscription<HeardWhileWaiting>? _subscription;

  VoiceAssistantService get _service => VoiceAssistantService.instance;

  /// Whether it is recording or working it out.
  bool get isTeaching =>
      state.value is WakeWordTeachingRecording ||
      state.value is WakeWordTeachingWorking;

  /// Starts recording the driver saying the wake word.
  Future<void> startTeaching() async {
    if (isTeaching) return;
    final store = SpeechModelStore.instance;
    if (!store.isDownloaded(SpeechModels.wakeWord) ||
        !store.isDownloaded(SpeechModels.voiceDetection) ||
        !_service.recognizerModels.any(store.isDownloaded)) {
      state.value = WakeWordTeaching.failed(t.teach.needs_models);
      return;
    }
    _clips.clear();
    _heard.clear();
    state.value = const WakeWordTeaching.recording(recorded: 0, wanted: wanted);
    _subscription = _service.heardWhileWaiting.listen(_onHeard);
    if (!await _service.setTeaching(true)) {
      await _stopRecording();
      state.value = WakeWordTeaching.failed(t.teach.no_microphone);
    }
  }

  /// Stops without learning anything.
  Future<void> cancelTeaching() async {
    await _stopRecording();
    state.value = const WakeWordTeaching.idle();
  }

  Future<void> _stopRecording() async {
    await _subscription?.cancel();
    _subscription = null;
    await _service.setTeaching(false);
  }

  void _onHeard(HeardWhileWaiting heard) {
    final recording = state.value;
    final audio = heard.audio;
    if (recording is! WakeWordTeachingRecording || audio == null) return;

    final samples = audio.materialize().asFloat32List();
    final seconds = samples.length / SpeechWorker.sampleRate;
    final likeIt =
        wakeWordSimilarity(heard.text, _service.setup.wakeWord) >=
            soundsLikeWakeWord &&
        seconds >= 0.3 &&
        seconds <= 4;
    if (!likeIt) {
      state.value = recording.copyWith(
        lastHeard: heard.text,
        lastLeftOut: true,
      );
      return;
    }

    _clips.add(samples);
    _heard.add(heard.text);
    final recorded = _clips.length;
    state.value = recording.copyWith(
      recorded: recorded,
      lastHeard: heard.text,
      lastLeftOut: false,
    );
    if (recorded >= wanted) unawaited(_learn());
  }

  Future<void> _learn() async {
    await _stopRecording();
    final known = [
      _service.setup.wakeWord,
      ..._service.setup.wakeWordSpellings,
    ];
    final previous = _service.learnedSpellings;
    final candidates = candidateSpellings(_service.setup.wakeWord, [
      ..._heard,
      ...previous,
    ], known: known);
    SmartifyOsLog.info(
      _tag,
      'Heard ${_heard.join(' | ')}; trying ${candidates.join(' | ')}',
    );

    final tests = [
      known,
      [...known, ...previous],
      for (final candidate in candidates) [candidate],
    ];
    final hits = <List<bool>>[];
    for (final test in tests) {
      state.value = WakeWordTeaching.working(
        tried: hits.length,
        total: tests.length,
      );
      final row = await _service.testSpellings(test, _clips);
      if (row == null) {
        state.value = WakeWordTeaching.failed(t.teach.failed);
        return;
      }
      hits.add(row);
    }

    final picked = pickSpellings(hits[0], hits.sublist(2), max: maxLearned);
    final learned = [
      for (final index in picked)
        LearnedSpelling(
          spelling: candidates[index],
          heard: hits[index + 2].where((hit) => hit).length,
        ),
    ];
    final after = List.of(hits[0]);
    for (final index in picked) {
      for (var clip = 0; clip < after.length; clip++) {
        after[clip] = after[clip] || hits[index + 2][clip];
      }
    }
    _service.learnedSpellings = [
      for (final spelling in learned) spelling.spelling,
    ];
    state.value = WakeWordTeaching.done(
      recordings: _clips.length,
      before: hits[1].where((hit) => hit).length,
      after: after.where((hit) => hit).length,
      learned: learned,
    );
    SmartifyOsLog.info(
      _tag,
      'Learned ${learned.map((s) => '${s.spelling} (${s.heard})').join(', ')}',
    );
  }
}

/// Internal: how close [wakeWordSimilarity] has to be for something heard to
/// count as the wake word while teaching. Every real take in testing was
/// above 0.6, "the weather is nice" is 0.5 against "Hey Miata".
const soundsLikeWakeWord = 0.55;

/// Internal: how much [heard] sounds like [phrase] going by its letters, from
/// 0 to 1, comparing the start of what was heard with the phrase, allowing a
/// letter or two more or less.
double wakeWordSimilarity(String heard, String phrase) {
  final wanted = _letters(phrase);
  final got = _letters(heard);
  if (wanted.isEmpty || got.isEmpty) return 0;
  var best = 0.0;
  for (var start = 0; start <= math.min(3, got.length - 1); start++) {
    for (
      var length = wanted.length - 2;
      length <= wanted.length + 2;
      length++
    ) {
      if (length <= 0 || start + length > got.length) continue;
      final distance = _editDistance(
        got.substring(start, start + length),
        wanted,
      );
      best = math.max(best, 1 - distance / wanted.length);
    }
  }
  if (best == 0) {
    best = math.max(0, 1 - _editDistance(got, wanted) / wanted.length);
  }
  return best;
}

/// Internal: the spellings worth trying, from what the recognizer heard the
/// driver say: each one that sounds like [wakeWord], and each long word of it
/// split in two ("Miyata" as "Mi yata", "Miy ata", "Miya ta"), which the wake
/// word model often hears better. Ones already in [known] are left out, since
/// those are always listened for.
List<String> candidateSpellings(
  String wakeWord,
  List<String> heard, {
  List<String> known = const [],
  int max = 30,
}) {
  final skip = {for (final spelling in known) _normal(spelling)};
  final out = <String>{};

  void add(String spelling) {
    final normal = _normal(spelling);
    if (normal.isEmpty || skip.contains(normal)) return;
    out.add(normal);
  }

  for (final text in heard) {
    final normal = _normal(text);
    if (wakeWordSimilarity(normal, wakeWord) < soundsLikeWakeWord) continue;
    add(normal);
    final words = normal.split(' ');
    for (var w = 0; w < words.length; w++) {
      final word = words[w];
      if (word.length < 5) continue;
      for (var at = 2; at <= word.length - 2; at++) {
        add(
          [
            ...words.take(w),
            word.substring(0, at),
            word.substring(at),
            ...words.skip(w + 1),
          ].join(' '),
        );
      }
    }
  }
  return out.take(max).toList();
}

/// Internal: which candidates to keep: one at a time, the one that hears the
/// most recordings nothing kept so far hears, until none adds any or [max]
/// are kept. [already] is what the known spellings hear. Each row of
/// [candidates] is one candidate, one entry per recording.
///
/// A candidate has to hear at least [minHeard] of the recordings: one that
/// only fits a single mumbled take is more likely to start the assistant
/// for something else than to help.
List<int> pickSpellings(
  List<bool> already,
  List<List<bool>> candidates, {
  required int max,
  int minHeard = 2,
}) {
  final covered = List.of(already);
  final picked = <int>[];
  while (picked.length < max) {
    var best = -1;
    var bestGain = 0;
    var bestTotal = 0;
    for (var i = 0; i < candidates.length; i++) {
      if (picked.contains(i)) continue;
      if (candidates[i].where((hit) => hit).length < minHeard) continue;
      var gain = 0;
      var total = 0;
      for (var clip = 0; clip < covered.length; clip++) {
        if (!candidates[i][clip]) continue;
        total++;
        if (!covered[clip]) gain++;
      }
      if (gain > bestGain ||
          (gain == bestGain && gain > 0 && total > bestTotal)) {
        best = i;
        bestGain = gain;
        bestTotal = total;
      }
    }
    if (best < 0) break;
    picked.add(best);
    for (var clip = 0; clip < covered.length; clip++) {
      covered[clip] = covered[clip] || candidates[best][clip];
    }
  }
  return picked;
}

String _normal(String text) => text
    .toLowerCase()
    .replaceAll(RegExp(r'[^a-z\s]'), ' ')
    .trim()
    .split(RegExp(r'\s+'))
    .where((word) => word.isNotEmpty)
    .join(' ');

String _letters(String text) =>
    text.toLowerCase().replaceAll(RegExp('[^a-z]'), '');

int _editDistance(String a, String b) {
  var previous = List<int>.generate(b.length + 1, (i) => i);
  for (var i = 1; i <= a.length; i++) {
    final current = List<int>.filled(b.length + 1, 0)..[0] = i;
    for (var j = 1; j <= b.length; j++) {
      current[j] = [
        previous[j] + 1,
        current[j - 1] + 1,
        previous[j - 1] + (a[i - 1] == b[j - 1] ? 0 : 1),
      ].reduce(math.min);
    }
    previous = current;
  }
  return previous[b.length];
}
