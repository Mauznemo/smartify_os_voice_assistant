import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:smartify_os_core/core.dart';
import 'package:smartify_os_core/date_time.dart';
import 'package:smartify_os_core/language.dart';
import 'package:smartify_os_core/settings.dart';
import 'package:smartify_os_core/sound.dart';
import 'package:smartify_os_core/utils.dart';
import 'package:smartify_os_core/volume.dart';
import 'package:smartify_os_voice_assistant/src/i18n/strings.g.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/built_in_voice_commands.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/models/voice_command.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/models/voice_command_run.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/voice_command_matcher.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/voice_commands_registry.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/models/voice_assistant_phase.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/models/voice_assistant_state.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/models/wake_word_log_entry.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/models/wake_word_sensitivity.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/servers/ai_server_client.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/servers/speech_server_client.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech/microphone.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech/sentence_piece.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech/speech_worker.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech/wav.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/models/speech_model.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/speech_model_store.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/speech_models.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/voice_assistant_settings.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/voice_assistant_settings_pages.dart';
import 'package:smartify_os_voice_assistant/src/voice_assistant_extension.dart';

/// Internal: the voice assistant, from hearing the wake word to the end of
/// the answer.
///
/// End users go through `SmartifyOsVoiceAssistant`. A conversation goes
/// preparing (only while the recognizer loads), listening, understanding,
/// thinking, speaking, done, and back to idle. Each one has a number, and
/// every step that had to wait checks it is still the one going on, so
/// starting over or closing at any point simply leaves the old one to run
/// out without effect.
///
/// What runs follows what is needed: the microphone is only open while it
/// listens (or waits for the wake word), the recognizer and the voice are
/// loaded on the first question and unloaded a while after the last, and the
/// wake word model only while the wake word is on. With nothing loaded the
/// speech worker's isolate is not running either.
class VoiceAssistantService {
  static const _tag = 'VoiceAssistant';

  /// How long the answer stays on screen after it was said.
  static const _showAnswerFor = Duration(milliseconds: 1800);

  /// How long "done" stays on screen after a command with nothing to say.
  static const _showDoneFor = Duration(milliseconds: 1100);

  /// How often the sound level follows a spoken answer.
  static const _levelStep = Duration(milliseconds: 40);

  static final VoiceAssistantService instance = VoiceAssistantService._();
  VoiceAssistantService._();

  final _state = ValueStream(const VoiceAssistantState());
  final _worker = SpeechWorker();
  final _microphone = Microphone();
  final _store = SpeechModelStore.instance;

  /// How loud it is right now, from 0 to 1: the driver while it listens, its
  /// own voice while it answers. Drives the panel's waves.
  final ValueNotifier<double> level = ValueNotifier(0);

  VoiceAssistantExtension _setup = VoiceAssistantExtension();
  late VoiceAssistantSettings _settings;
  bool _started = false;

  int _conversation = 0;
  AudioDuck? _duck;
  Timer? _closeTimer;
  Timer? _unloadTimer;
  Timer? _levelTimer;
  SoundPlayback? _playing;
  Directory? _speechDir;
  int _speechFiles = 0;

  /// What it heard while waiting for the wake word, newest first, for the
  /// debug view.
  final ValueNotifier<List<WakeWordLogEntry>> wakeWordLog = ValueNotifier(
    const [],
  );

  /// How many debug views are open, each wanting everything said turned into
  /// text.
  int _debugging = 0;

  /// Whether the driver is teaching it the wake word, so hearing it starts
  /// nothing and every recording is handed out.
  bool _teaching = false;

  final _heardWhileWaiting = StreamController<HeardWhileWaiting>.broadcast();

  /// Internal: everything heard while waiting for the wake word, while
  /// something asked for it with [setHearingWhileWaiting] or [setTeaching].
  Stream<HeardWhileWaiting> get heardWhileWaiting => _heardWhileWaiting.stream;

  /// What is loaded in the worker right now, so a change of model or
  /// language loads the right one.
  String? _loadedRecognizer;
  String? _loadedVoice;
  Future<String?>? _recognizerLoading;
  Future<String?>? _voiceLoading;
  Future<void> _wakeWordUpdate = Future.value();

  final List<StreamSubscription<Object?>> _subscriptions = [];

  /// The built-in commands as they were added, which only run when none of
  /// the car's own matched. One the car replaced under the same id is no
  /// longer among them.
  List<VoiceCommand> _builtIns = const [];

  /// Everything the assistant shows.
  VoiceAssistantState get state => _state.value;

  /// Emits every time [state] changes.
  Stream<VoiceAssistantState> get changes => _state.stream;

  /// How the extension was set up.
  VoiceAssistantExtension get setup => _setup;

  /// What the driver picked in Settings.
  VoiceAssistantSettings get settings => _settings;

  /// Whether [start] ran.
  bool get isStarted => _started;

  /// Sets everything up. Called once from the extension's `init`. Never
  /// throws, and starts nothing slow without leaving it to run on its own.
  Future<void> start(VoiceAssistantExtension setup) async {
    _setup = setup;
    _settings = VoiceAssistantSettings(
      wakeWordByDefault: setup.wakeWordOnByDefault,
      recognizerByDefault: setup.recognizer.id,
    );
    _started = true;

    await LocaleSettings.setLocaleRaw(SmartifyOsLanguage.languageCode);
    final registry = VoiceCommandsRegistry.instance;
    _builtIns = builtInVoiceCommands();
    registry.addCommands(_builtIns);
    registry.addCommands(setup.commands);
    setup.hiddenCommands.forEach(registry.hideCommand);

    _subscriptions.addAll([
      _worker.events.listen(_onWorkerEvent),
      SmartifyOsLanguage.languageChanges.listen(_onLanguageChanged),
      _settings.wakeWord.changes.listen((_) => _updateWakeWord()),
      _settings.sensitivity.changes.listen(
        (_) => _updateWakeWord(reload: true),
      ),
      _settings.recognizer.changes.listen((_) => _unloadModelsSoon(now: true)),
      // A wake word model downloaded while the wake word is on starts it.
      _store.changes.listen((_) => _updateWakeWord()),
    ]);

    // Looking through the models folder is quick, but there is no need for
    // the car to wait for it.
    unawaited(
      _store.start(directory: setup.modelsDirectory).then((_) {
        _updateWakeWord();
      }),
    );
  }

  // The conversation ------------------------------------------------------

  /// Starts listening, opening the panel. What is said is collected from
  /// this moment on, even while the recognizer is still loading.
  Future<void> startListening() async {
    if (!_started) return;
    if (state.phase == VoiceAssistantPhase.listening ||
        state.phase == VoiceAssistantPhase.preparing) {
      return;
    }
    final conversation = _begin();
    _set(const VoiceAssistantState(phase: VoiceAssistantPhase.preparing));

    final recognizer = _recognizerModel();
    if (!_store.isDownloaded(recognizer) ||
        !_store.isDownloaded(SpeechModels.voiceDetection)) {
      // Straight to where they are downloaded, rather than only saying so.
      final context = SmartifyOsNavigator.navigatorKey.currentContext;
      final opened = context != null && context.mounted;
      if (opened) {
        SmartifyOsSettings.open(
          context,
          pageId: VoiceAssistantSettingsPages.setup,
        );
      }
      await _finish(
        conversation,
        opened ? t.replies.model_missing_opened : t.replies.model_missing,
        failed: true,
      );
      return;
    }
    _playSound(_setup.listeningSound);

    await _worker.start();
    if (conversation != _conversation) return;
    _worker.listenForWakeWord(false);
    _worker.startUtterance();
    if (!await _openMicrophone()) {
      if (conversation != _conversation) return;
      _worker.cancelUtterance();
      await _finish(conversation, t.replies.no_microphone, failed: true);
      return;
    }

    final error = await _loadRecognizer(recognizer);
    if (conversation != _conversation) return;
    if (error != null) {
      SmartifyOsLog.warning(_tag, 'Could not load ${recognizer.id}: $error');
      _worker.cancelUtterance();
      await _finish(conversation, t.replies.something_went_wrong, failed: true);
      return;
    }
    if (state.phase == VoiceAssistantPhase.preparing) {
      _set(state.copyWith(phase: VoiceAssistantPhase.listening));
    }
  }

  /// Stops listening and acts on what was said so far, for a button that is
  /// let go.
  void stopListening() {
    if (state.phase != VoiceAssistantPhase.listening &&
        state.phase != VoiceAssistantPhase.preparing) {
      return;
    }
    _set(state.copyWith(phase: VoiceAssistantPhase.understanding));
    _worker.finishUtterance();
  }

  /// Starts listening when it is idle, acts on what was said while it
  /// listens, and stops when it is answering: what one button does.
  void toggleListening() {
    switch (state.phase) {
      case VoiceAssistantPhase.idle || VoiceAssistantPhase.done:
        unawaited(startListening());
      case VoiceAssistantPhase.preparing || VoiceAssistantPhase.listening:
        stopListening();
      case VoiceAssistantPhase.understanding ||
          VoiceAssistantPhase.thinking ||
          VoiceAssistantPhase.speaking:
        closeAssistant();
    }
  }

  /// Stops whatever it is doing, and takes the panel away.
  void closeAssistant() {
    if (!state.isActive) return;
    _conversation++;
    _endConversation();
    _set(VoiceAssistantState(wakeWordListening: _worker.hasWakeWord));
  }

  /// Acts on [text] as if it had been said, opening the panel.
  Future<void> respondToText(String text) async {
    if (!_started || text.trim().isEmpty) return;
    final conversation = _begin();
    _set(
      VoiceAssistantState(
        phase: VoiceAssistantPhase.thinking,
        heard: text.trim(),
      ),
    );
    await _respond(conversation, text.trim());
  }

  /// Says [text] out loud, opening the panel while it does.
  Future<void> speakText(String text) async {
    if (!_started || text.trim().isEmpty) return;
    final conversation = _begin();
    await _finish(conversation, text.trim());
  }

  /// Starts a new conversation, leaving any other to run out.
  int _begin() {
    final conversation = ++_conversation;
    _closeTimer?.cancel();
    _unloadTimer?.cancel();
    _stopSpeaking();
    _worker.cancelUtterance();
    _duck ??= SmartifyOsVolume.duckAudio(level: _setup.duckLevel);
    return conversation;
  }

  void _onWorkerEvent(SpeechWorkerEvent event) {
    final conversation = _conversation;
    switch (event) {
      case WakeWordHeard(:final keyword):
        final spelling = keyword.replaceAll('_', ' ').toLowerCase();
        _log(
          WakeWordLogEntry(
            time: SmartifyOsTime.now,
            wakeWord: true,
            text: spelling,
          ),
        );
        if (state.isActive || _teaching) return;
        SmartifyOsLog.info(_tag, 'Heard the wake word, as "$spelling"');
        unawaited(startListening());
      case HeardWhileWaiting(:final text):
        SmartifyOsLog.debug(_tag, 'Heard while waiting: "$text"');
        _heardWhileWaiting.add(event);
        _log(
          WakeWordLogEntry(
            time: SmartifyOsTime.now,
            wakeWord: false,
            text: text,
          ),
        );
      case SpeechStarted():
        break;
      case PartialText(:final text):
        if (state.phase == VoiceAssistantPhase.listening) {
          _set(state.copyWith(heard: text));
        }
      case FinalText(:final text):
        if (!_listeningOrUnderstanding) return;
        if (text.isEmpty) {
          _nothingHeard(conversation);
          return;
        }
        _playSound(_setup.heardSound);
        SmartifyOsLog.info(_tag, 'Heard "$text"');
        _set(state.copyWith(phase: VoiceAssistantPhase.thinking, heard: text));
        _closeMicrophoneIfIdle();
        unawaited(_respond(conversation, text));
      case NothingHeard():
        if (!_listeningOrUnderstanding) return;
        _nothingHeard(conversation);
    }
  }

  /// Ends with only the sound for it and a line on screen: saying "I didn't
  /// hear anything" out loud to someone who said nothing is more annoying
  /// than helpful.
  void _nothingHeard(int conversation) {
    _playSound(_setup.nothingHeardSound);
    unawaited(
      _finish(
        conversation,
        t.replies.nothing_heard,
        failed: true,
        speak: false,
      ),
    );
  }

  void _playSound(String? asset) => SmartifyOsSound.playSoundAsset(asset);

  void _log(WakeWordLogEntry entry) {
    wakeWordLog.value = [entry, ...wakeWordLog.value.take(29)];
  }

  /// Turns everything said while waiting for the wake word into text, for
  /// the debug view, until it is turned off as many times as it was turned
  /// on. Loads the recognizer and opens the microphone for it. Finishes with
  /// whether it is listening.
  Future<bool> setHearingWhileWaiting(bool on) async {
    if (!_started) return false;
    _debugging = math.max(0, _debugging + (on ? 1 : -1));
    if (_debugging == 0) {
      _worker.hearWhileWaiting(false);
      _closeMicrophoneIfIdle();
      _unloadModelsSoon();
      if (_worker.hasWakeWord && !state.isActive) {
        _worker.listenForWakeWord(true);
      }
      return false;
    }
    _unloadTimer?.cancel();
    final recognizer = _recognizerModel();
    if (!_store.isDownloaded(recognizer) ||
        !_store.isDownloaded(SpeechModels.voiceDetection)) {
      return false;
    }
    await _worker.start();
    final error = await _loadRecognizer(recognizer);
    if (error != null || _debugging == 0) return false;
    if (!await _openMicrophone()) return false;
    _worker.hearWhileWaiting(true, keepAudio: _teaching);
    return true;
  }

  /// Internal: records every stretch of speech for teaching the wake word,
  /// and keeps the wake word from starting anything meanwhile. Finishes with
  /// whether it is recording.
  Future<bool> setTeaching(bool on) async {
    if (on == _teaching) return on;
    _teaching = on;
    if (_worker.hasWakeWord) _worker.listenForWakeWord(!on && !state.isActive);
    return setHearingWhileWaiting(on);
  }

  /// The spellings of the wake word learned from the driver's voice.
  List<String> get learnedSpellings => [
    for (final line in _settings.learnedSpellings.value.split('\n'))
      if (line.trim().isNotEmpty) line.trim(),
  ];

  /// Remembers newly learned spellings in place of the old ones, and listens
  /// for them from now on.
  set learnedSpellings(List<String> spellings) {
    _settings.learnedSpellings.value = spellings.join('\n');
    _updateWakeWord(reload: true);
  }

  /// Internal: which of [clips] (16 kHz recordings of the driver) the wake
  /// word model hears when it listens for [spellings], as it would in the
  /// car. `null` when it could not be tried.
  Future<List<bool>?> testSpellings(
    List<String> spellings,
    List<Float32List> clips,
  ) async {
    final model = SpeechModels.wakeWord;
    final bpe = await File(_store.filePath(model, 'bpe')).readAsBytes();
    final keywords = wakeWordKeywords(
      SentencePiece.fromModel(bpe),
      spellings,
      _settings.wakeWordSensitivity,
    );
    if (keywords.isEmpty) return List.filled(clips.length, false);
    final result = await _worker.testSpellings(
      files: _store.filePaths(model),
      candidates: [keywords],
      clips: clips,
    );
    return result?.single;
  }

  bool get _listeningOrUnderstanding =>
      state.phase == VoiceAssistantPhase.preparing ||
      state.phase == VoiceAssistantPhase.listening ||
      state.phase == VoiceAssistantPhase.understanding;

  /// Works out what to do about [text], does it, and answers.
  Future<void> _respond(int conversation, String text) async {
    final commands = VoiceCommandsRegistry.instance.snapshot.active;

    final server = _setup.aiServer;
    if (server != null && _settings.useAiServer.value) {
      _set(state.copyWith(askingServer: true));
      final answer = await AiServerClient.ask(
        server: server,
        text: text,
        commands: commands,
        languageCode: SmartifyOsLanguage.languageCode,
        runCommand: (command, values) => _run(
          command,
          VoiceCommandRun(text: text, values: values, fromAiServer: true),
        ),
      );
      if (conversation != _conversation) return;
      _set(state.copyWith(askingServer: false));
      if (answer != null) {
        if (answer.ran.contains(VoiceCommands.cancel)) {
          closeAssistant();
          return;
        }
        final reply = answer.text.isNotEmpty
            ? answer.text
            : answer.ran.isEmpty
            ? t.replies.not_understood
            : null;
        await _finish(conversation, reply);
        return;
      }
      // No connection: the car's own phrases still work.
    }

    final match = VoiceCommandMatcher.match(
      text,
      commands,
      fallbacks: _builtIns.toSet(),
    );
    if (match == null) {
      final reply = server != null && _settings.useAiServer.value
          ? t.replies.server_unreachable
          : t.replies.not_understood;
      await _finish(conversation, reply, failed: true);
      return;
    }
    if (match.command.id == VoiceCommands.cancel) {
      closeAssistant();
      return;
    }
    SmartifyOsLog.info(_tag, 'Running ${match.command.id}');
    final reply = await _run(
      match.command,
      VoiceCommandRun(text: text, values: match.values),
    );
    if (conversation != _conversation) return;
    await _finish(conversation, reply);
  }

  Future<String?> _run(VoiceCommand command, VoiceCommandRun run) async {
    try {
      return await command.onRun(run);
    } on Object catch (error, stackTrace) {
      SmartifyOsLog.error(
        _tag,
        'Command "${command.id}" failed',
        error,
        stackTrace,
      );
      return t.replies.something_went_wrong;
    }
  }

  /// Shows [reply], says it, and closes the panel a moment later.
  Future<void> _finish(
    int conversation,
    String? reply, {
    bool failed = false,
    bool speak = true,
  }) async {
    if (conversation != _conversation) return;
    speak =
        speak &&
        reply != null &&
        reply.isNotEmpty &&
        _settings.speakAnswers.value;
    _set(
      state.copyWith(
        phase: speak ? VoiceAssistantPhase.speaking : VoiceAssistantPhase.done,
        reply: reply,
        failed: failed,
        askingServer: false,
      ),
    );
    _worker.cancelUtterance();
    _closeMicrophoneIfIdle();
    if (speak) await _speak(conversation, reply);
    if (conversation != _conversation) return;

    _set(state.copyWith(phase: VoiceAssistantPhase.done));
    level.value = 0;
    _duck?.release();
    _duck = null;
    _closeTimer = Timer(reply == null ? _showDoneFor : _showAnswerFor, () {
      if (conversation != _conversation) return;
      closeAssistant();
    });
  }

  /// Puts everything back the way it is between conversations.
  void _endConversation() {
    _closeTimer?.cancel();
    _stopSpeaking();
    _worker.cancelUtterance();
    _duck?.release();
    _duck = null;
    level.value = 0;
    _closeMicrophoneIfIdle();
    if (_worker.hasWakeWord) _worker.listenForWakeWord(true);
    _unloadModelsSoon();
  }

  void _set(VoiceAssistantState next) {
    _state.value = next.copyWith(wakeWordListening: _worker.hasWakeWord);
  }

  // Speaking ----------------------------------------------------------------

  /// Says [text] a sentence at a time, getting the next one ready while the
  /// one before plays, so even a slow voice starts talking quickly.
  Future<void> _speak(int conversation, String text) async {
    final sentences = splitSentences(text);
    Future<_Speech?>? next = sentences.isEmpty ? null : _prepare(sentences[0]);
    for (var i = 0; i < sentences.length; i++) {
      final speech = await next;
      if (conversation != _conversation) return;
      next = i + 1 < sentences.length ? _prepare(sentences[i + 1]) : null;
      if (speech == null) continue;

      final playback = SmartifyOsSound.playSoundFile(speech.path);
      _playing = playback;
      _followLevel(speech.envelope);
      await playback.done;
      _levelTimer?.cancel();
      unawaited(_deleteQuietly(File(speech.path)));
      if (conversation != _conversation) return;
    }
  }

  /// One sentence, ready to play: from the speech server when the driver
  /// picked it and it answers, otherwise from the car's own voice.
  Future<_Speech?> _prepare(String sentence) async {
    try {
      final language = SmartifyOsLanguage.languageCode;
      final server = _setup.speechServer;
      if (server != null &&
          voiceSettingFor(language).value == VoiceAssistantSettings.server) {
        final wav = await SpeechServerClient.speak(server, sentence);
        if (wav != null) return _Speech(await _writeSpeech(wav), null);
      }

      final voice = voiceModelFor(language);
      if (voice == null || !_store.isDownloaded(voice)) return null;
      final error = await _loadVoice(voice);
      if (error != null) {
        SmartifyOsLog.warning(_tag, 'Could not load ${voice.id}: $error');
        return null;
      }
      final speech = await _worker.synthesize(sentence);
      if (speech == null) return null;
      return _Speech(
        await _writeSpeech(encodeWav(speech.samples, speech.sampleRate)),
        _envelope(speech.samples, speech.sampleRate),
      );
    } on Object catch (error) {
      SmartifyOsLog.warning(_tag, 'Could not speak "$sentence"', error);
      return null;
    }
  }

  Future<String> _writeSpeech(Uint8List wav) async {
    final dir = _speechDir ??= await Directory.systemTemp.createTemp(
      'smartify_os_voice_',
    );
    final file = File('${dir.path}/answer_${_speechFiles++}.wav');
    await file.writeAsBytes(wav, flush: true);
    return file.path;
  }

  /// How loud each step of the sentence is, so the waves move with the
  /// voice. `null` for audio from the speech server, where a gentle made up
  /// movement stands in.
  List<double> _envelope(Float32List samples, int sampleRate) {
    final step = (sampleRate * _levelStep.inMilliseconds / 1000).round();
    return [
      for (var at = 0; at < samples.length; at += step)
        Microphone.levelOf(
          Float32List.sublistView(
            samples,
            at,
            math.min(samples.length, at + step),
          ),
        ),
    ];
  }

  void _followLevel(List<double>? envelope) {
    _levelTimer?.cancel();
    var i = 0;
    final random = math.Random();
    _levelTimer = Timer.periodic(_levelStep, (timer) {
      if (envelope == null) {
        level.value = 0.35 + random.nextDouble() * 0.3;
      } else if (i < envelope.length) {
        level.value = envelope[i++];
      } else {
        level.value = 0;
        timer.cancel();
      }
    });
  }

  void _stopSpeaking() {
    _levelTimer?.cancel();
    final playing = _playing;
    _playing = null;
    if (playing != null) unawaited(playing.stop());
  }

  // Models ------------------------------------------------------------------

  /// The recognizer the driver picked, or one that understands the car's
  /// language when that one does not.
  SpeechModel _recognizerModel() {
    final language = SmartifyOsLanguage.languageCode;
    final picked = recognizerModels.firstWhere(
      (model) => model.id == _settings.recognizer.value,
      orElse: () => _setup.recognizer,
    );
    if (picked.supports(language)) return picked;
    return recognizerModels
            .where((m) => m.supports(language) && _store.isDownloaded(m))
            .firstOrNull ??
        picked;
  }

  /// Every model what the driver picked needs: the recognizer, the voice
  /// detection, the voice that answers (unless the speech server does), and
  /// the wake word while it is on.
  List<SpeechModel> get neededModels {
    final language = SmartifyOsLanguage.languageCode;
    final voice = voiceModelFor(language);
    final needed = {
      _recognizerModel(),
      SpeechModels.voiceDetection,
      if (_settings.wakeWord.value) SpeechModels.wakeWord,
      if (_settings.speakAnswers.value &&
          voiceSettingFor(language).value != VoiceAssistantSettings.server &&
          voice != null)
        voice,
    };
    // Two voices can share their files, and only need them once.
    final folders = <String>{};
    return [
      for (final model in needed)
        if (folders.add(model.folder)) model,
    ];
  }

  /// Every recognizer the driver can pick from.
  List<SpeechModel> get recognizerModels =>
      {_setup.recognizer, ...SpeechModels.recognizers}.toList();

  /// Every voice the driver can pick from for [languageCode].
  List<SpeechModel> voiceModelsFor(String languageCode) => {
    if (_setup.voices[languageCode] case final SpeechModel voice) voice,
    ...SpeechModels.voicesInOrder.where(
      (voice) => voice.supports(languageCode),
    ),
  }.toList();

  /// The voice that answers in [languageCode]: the driver's pick, the car's,
  /// or the first one there is for it.
  SpeechModel? voiceModelFor(String languageCode) {
    final voices = voiceModelsFor(languageCode);
    final picked = voiceSettingFor(languageCode).value;
    return voices.where((voice) => voice.id == picked).firstOrNull ??
        voices.firstOrNull;
  }

  /// The driver's pick of voice for [languageCode], the first one there is
  /// until they pick another.
  SavedValue<String> voiceSettingFor(String languageCode) => _settings.voiceFor(
    languageCode,
    byDefault: voiceModelsFor(languageCode).firstOrNull?.id ?? '',
  );

  Future<String?> _loadRecognizer(SpeechModel model) {
    final language = SmartifyOsLanguage.languageCode;
    final key = '${model.id}:$language';
    if (_loadedRecognizer == key && _worker.hasRecognizer) {
      return Future.value();
    }
    return _recognizerLoading ??= () async {
      final started = DateTime.now();
      final error = await _worker.loadRecognizer(
        engine: model.engine,
        files: _store.filePaths(model),
        voiceDetection: _store.filePath(SpeechModels.voiceDetection, 'model'),
        languageCode: language,
        threads: _threads,
      );
      _loadedRecognizer = error == null ? key : null;
      SmartifyOsLog.info(
        _tag,
        'Loaded ${model.id} in ${DateTime.now().difference(started).inMilliseconds} ms',
      );
      return error;
    }().whenComplete(() => _recognizerLoading = null);
  }

  Future<String?> _loadVoice(SpeechModel model) {
    if (_loadedVoice == model.id && _worker.hasVoice) return Future.value();
    return _voiceLoading ??= () async {
      final error = await _worker.loadVoice(
        engine: model.engine,
        files: _store.filePaths(model),
        speaker: model.speaker,
        threads: _threads,
      );
      _loadedVoice = error == null ? model.id : null;
      return error;
    }().whenComplete(() => _voiceLoading = null);
  }

  /// Half the processor, so the screen keeps the other half, and never more
  /// than four, which is where these models stop getting faster.
  static int get _threads => (Platform.numberOfProcessors ~/ 2).clamp(1, 4);

  /// Lets go of the recognizer and the voice once nobody has asked anything
  /// for a while, or [now].
  void _unloadModelsSoon({bool now = false}) {
    _unloadTimer?.cancel();
    void unload() {
      if (state.isActive || _debugging > 0) return;
      _loadedRecognizer = null;
      _loadedVoice = null;
      unawaited(_worker.unloadRecognizer());
      unawaited(_worker.unloadVoice());
      SmartifyOsLog.debug(_tag, 'Unloaded the speech models');
    }

    if (now) {
      unload();
    } else {
      _unloadTimer = Timer(_setup.keepModelsLoadedFor, unload);
    }
  }

  void _onLanguageChanged(String language) {
    unawaited(LocaleSettings.setLocaleRaw(language));
    final registry = VoiceCommandsRegistry.instance;
    // Only the built-in ones still there as they were, so one removed stays
    // removed and one the car replaced stays the car's.
    final current = registry.snapshot.commandsById;
    final stillBuiltIn = {
      for (final command in _builtIns)
        if (identical(current[command.id], command)) command.id,
    };
    _builtIns = builtInVoiceCommands();
    registry.addCommands(_builtIns.where((c) => stillBuiltIn.contains(c.id)));
    _unloadModelsSoon(now: true);
  }

  // The wake word and the microphone --------------------------------------

  /// Loads or unloads the wake word to match the settings, one change at a
  /// time.
  void _updateWakeWord({bool reload = false}) {
    _wakeWordUpdate = _wakeWordUpdate.then((_) async {
      try {
        await _applyWakeWord(reload: reload);
      } on Object catch (error) {
        SmartifyOsLog.warning(_tag, 'Could not set up the wake word', error);
      }
    });
  }

  Future<void> _applyWakeWord({required bool reload}) async {
    final model = SpeechModels.wakeWord;
    final wanted =
        _started &&
        _settings.wakeWord.value &&
        _setup.wakeWord.trim().isNotEmpty &&
        _store.isDownloaded(model);

    if (!wanted) {
      if (!_worker.hasWakeWord) return;
      _worker.listenForWakeWord(false);
      await _worker.unloadWakeWord();
      _closeMicrophoneIfIdle();
      _set(state);
      SmartifyOsLog.info(_tag, 'The wake word is off');
      return;
    }
    if (_worker.hasWakeWord && !reload) return;

    final bpe = await File(_store.filePath(model, 'bpe')).readAsBytes();
    final keywords = wakeWordKeywords(SentencePiece.fromModel(bpe), [
      _setup.wakeWord,
      ..._setup.wakeWordSpellings,
      ...learnedSpellings,
    ], _settings.wakeWordSensitivity);
    if (keywords.isEmpty) {
      SmartifyOsLog.warning(
        _tag,
        'The wake word "${_setup.wakeWord}" cannot be listened for, use '
        'letters from A to Z',
      );
      return;
    }
    final error = await _worker.loadWakeWord(
      files: _store.filePaths(model),
      keywords: keywords,
    );
    if (error != null) {
      SmartifyOsLog.warning(_tag, 'Could not load the wake word: $error');
      return;
    }
    if (!await _openMicrophone()) return;
    _worker.listenForWakeWord(!state.isActive);
    _set(state);
    SmartifyOsLog.info(_tag, 'Listening for "${_setup.wakeWord}"');
  }

  Future<bool> _openMicrophone() => _microphone.open(
    onAudio: _worker.addAudio,
    onLevel: (value) {
      if (_listeningOrUnderstanding || _debugging > 0) level.value = value;
    },
  );

  /// Closes the microphone unless the wake word, a question or the debug
  /// view needs it.
  void _closeMicrophoneIfIdle() {
    if (_worker.hasWakeWord || _debugging > 0) return;
    if (state.phase == VoiceAssistantPhase.preparing ||
        state.phase == VoiceAssistantPhase.listening) {
      return;
    }
    unawaited(_microphone.close());
  }

  static Future<void> _deleteQuietly(File file) async {
    try {
      await file.delete();
    } on Object {
      // A leftover in the temp folder is no reason to complain.
    }
  }
}

/// Internal: a sentence turned into a file, and how loud it is along the way.
class _Speech {
  final String path;
  final List<double>? envelope;

  const _Speech(this.path, this.envelope);
}

/// Internal: [text] cut into sentences, so a long answer starts playing after
/// the first one is ready rather than the whole of it.
List<String> splitSentences(String text) => [
  for (final sentence in text.split(RegExp(r'(?<=[.!?。！？])\s+')))
    if (sentence.trim().isNotEmpty) sentence.trim(),
];

/// Internal: the lines the wake word model listens for, in sherpa-onnx's
/// `keywords.txt` format: every one of [spellings], each in its few most
/// likely splits into the model's pieces, tagged with the spelling.
///
/// One spelling in one split heard "Hey Miata" 16 times out of 100 in
/// testing, a few spellings in ten splits each 86, without starting by
/// mistake more often.
String wakeWordKeywords(
  SentencePiece pieces,
  List<String> spellings,
  WakeWordSensitivity sensitivity, {
  int splits = 10,
}) {
  final lines = <String>{};
  for (final spelling in spellings) {
    final words = spelling.trim().split(RegExp(r'\s+'));
    if (words.every((word) => word.isEmpty)) continue;
    final tag = words.join('_').toUpperCase();
    for (final split in pieces.encodeVariants(spelling, splits)) {
      lines.add(
        '${split.join(' ')} :${sensitivity.boost} #${sensitivity.threshold} '
        '@$tag',
      );
    }
  }
  return lines.join('\n');
}
