import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:smartify_os_core/utils.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech/speech_worker_isolate.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/models/speech_model.dart';

/// Internal: something the speech worker noticed in the audio.
sealed class SpeechWorkerEvent {
  const SpeechWorkerEvent();
}

/// The wake word was said.
class WakeWordHeard extends SpeechWorkerEvent {
  /// Which way of saying it was heard, as the keyword's tag.
  final String keyword;

  const WakeWordHeard(this.keyword);
}

/// Something said while waiting for the wake word, while
/// [SpeechWorker.hearWhileWaiting] is on.
class HeardWhileWaiting extends SpeechWorkerEvent {
  final String text;

  /// The audio it was heard in, 16 kHz, when that was asked for.
  final TransferableTypedData? audio;

  const HeardWhileWaiting(this.text, {this.audio});
}

/// Someone started talking after [SpeechWorker.startUtterance].
class SpeechStarted extends SpeechWorkerEvent {
  const SpeechStarted();
}

/// What has been said so far, while it is still being said.
class PartialText extends SpeechWorkerEvent {
  final String text;

  const PartialText(this.text);
}

/// What was said, once they stopped talking or [SpeechWorker.finishUtterance]
/// was called.
class FinalText extends SpeechWorkerEvent {
  final String text;

  const FinalText(this.text);
}

/// Nobody said anything for a while after [SpeechWorker.startUtterance].
class NothingHeard extends SpeechWorkerEvent {
  const NothingHeard();
}

/// Internal: a spoken sentence, ready to play.
class SynthesizedSpeech {
  final Float32List samples;
  final int sampleRate;

  const SynthesizedSpeech(this.samples, this.sampleRate);
}

/// Internal: runs the speech models in an isolate of their own, so listening
/// and speaking never hold up the screen.
///
/// Every model call is a long, blocking call into native code, and a car's
/// screen has to keep drawing at full speed while one runs. The isolate is
/// only started while something is loaded, and killed again once nothing is,
/// so a car with the wake word off and nothing said in a while runs nothing
/// at all.
///
/// Audio arrives with [addAudio], 16 kHz mono, and goes to the wake word
/// while [listenForWakeWord] is on, and to the recognizer between
/// [startUtterance] and the [FinalText] that ends it.
class SpeechWorker {
  static const _tag = 'VoiceAssistant.Worker';

  /// The rate everything here works at.
  static const sampleRate = 16000;

  /// Where sherpa-onnx's native library is, for a test, which unlike an app
  /// does not have it linked in. `null` in an app.
  final String? _nativeLibrary;

  SpeechWorker({@visibleForTesting String? nativeLibrary})
    : _nativeLibrary = nativeLibrary;

  final _events = StreamController<SpeechWorkerEvent>.broadcast();
  final Map<int, Completer<Object?>> _pending = {};
  int _nextId = 0;

  Isolate? _isolate;
  SendPort? _send;
  ReceivePort? _receive;
  Future<void>? _starting;

  final Set<String> _loaded = {};

  /// Everything the worker noticed in the audio.
  Stream<SpeechWorkerEvent> get events => _events.stream;

  /// Whether a wake word model is loaded.
  bool get hasWakeWord => _loaded.contains('wakeWord');

  /// Whether a recognizer is loaded.
  bool get hasRecognizer => _loaded.contains('recognizer');

  /// Whether a voice is loaded.
  bool get hasVoice => _loaded.contains('voice');

  /// Whether the isolate is running.
  bool get isRunning => _isolate != null;

  /// Loads the wake word model, listening for [keywords]: one per line, split
  /// into the model's pieces, in sherpa-onnx's `keywords.txt` format. Returns
  /// why it failed, or `null`.
  Future<String?> loadWakeWord({
    required Map<String, String> files,
    required String keywords,
  }) => _load('wakeWord', LoadWakeWord(files: files, keywords: keywords));

  /// Loads a recognizer and the voice detection that tells it when you
  /// stopped talking.
  Future<String?> loadRecognizer({
    required SpeechEngine engine,
    required Map<String, String> files,
    required String voiceDetection,
    required String languageCode,
    required int threads,
  }) => _load(
    'recognizer',
    LoadRecognizer(
      engine: engine,
      files: files,
      voiceDetection: voiceDetection,
      languageCode: languageCode,
      threads: threads,
    ),
  );

  /// Loads a voice to answer with.
  Future<String?> loadVoice({
    required SpeechEngine engine,
    required Map<String, String> files,
    required int speaker,
    required int threads,
  }) => _load(
    'voice',
    LoadVoice(engine: engine, files: files, speaker: speaker, threads: threads),
  );

  /// Lets go of the wake word model.
  Future<void> unloadWakeWord() => _unload('wakeWord');

  /// Lets go of the recognizer.
  Future<void> unloadRecognizer() => _unload('recognizer');

  /// Lets go of the voice.
  Future<void> unloadVoice() => _unload('voice');

  /// Starts the isolate, if it is not running yet, so audio and requests
  /// sent from now on are not lost.
  Future<void> start() => _ensureStarted();

  /// Whether audio goes to the wake word model.
  void listenForWakeWord(bool on) => _post(ListenForWakeWord(on));

  /// Whether everything said while waiting for the wake word is turned into
  /// text as well, for the debug view. Needs the recognizer loaded.
  void hearWhileWaiting(bool on, {bool keepAudio = false}) =>
      _post(HearWhileWaiting(on, keepAudio: keepAudio));

  /// Which of [clips] (16 kHz) each of [candidates] hears, one row per
  /// candidate. Each candidate is its keyword lines, in sherpa-onnx's
  /// `keywords.txt` format. `null` when it failed.
  Future<List<List<bool>>?> testSpellings({
    required Map<String, String> files,
    required List<String> candidates,
    required List<Float32List> clips,
  }) async {
    await _ensureStarted();
    final result = await _request(
      TestSpellings(
        files: files,
        candidates: candidates,
        clips: [
          for (final clip in clips) TransferableTypedData.fromList([clip]),
        ],
      ),
    );
    if (result is! List<List<bool>>) {
      SmartifyOsLog.warning(_tag, 'Could not test the spellings: $result');
      return null;
    }
    return result;
  }

  /// Starts collecting what is said for the recognizer.
  void startUtterance() => _post(const StartUtterance());

  /// Ends what is being said now, and turns it into text.
  void finishUtterance() => _post(const FinishUtterance());

  /// Throws away what is being said, without turning it into text.
  void cancelUtterance() => _post(const CancelUtterance());

  /// Hands over the next bit of audio from the microphone.
  void addAudio(Float32List samples) {
    final send = _send;
    if (send == null) return;
    send.send(AddAudio(TransferableTypedData.fromList([samples])));
  }

  /// Speaks [text] with the loaded voice. `null` without one, or when it
  /// failed.
  Future<SynthesizedSpeech?> synthesize(String text) async {
    if (!hasVoice) return null;
    final result = await _request(Synthesize(text));
    if (result is! SynthesizeResult) return null;
    return SynthesizedSpeech(
      result.samples.materialize().asFloat32List(),
      result.sampleRate,
    );
  }

  /// Kills the isolate, letting go of everything in it.
  Future<void> stop() async {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _send = null;
    _receive?.close();
    _receive = null;
    _starting = null;
    _loaded.clear();
    for (final pending in _pending.values) {
      if (!pending.isCompleted) pending.complete(null);
    }
    _pending.clear();
  }

  Future<String?> _load(String what, WorkerRequest request) async {
    await _ensureStarted();
    final result = await _request(request);
    if (result is String) return result;
    _loaded.add(what);
    return null;
  }

  Future<void> _unload(String what) async {
    if (!_loaded.remove(what)) return;
    await _request(Unload(what));
    if (_loaded.isEmpty) {
      SmartifyOsLog.debug(_tag, 'Nothing loaded any more, stopping');
      await stop();
    }
  }

  Future<void> _ensureStarted() {
    if (_send != null) return Future.value();
    return _starting ??= _start();
  }

  Future<void> _start() async {
    final receive = ReceivePort();
    _receive = receive;
    final ready = Completer<SendPort>();
    receive.listen((message) {
      switch (message) {
        case SendPort port:
          ready.complete(port);
        case WorkerReply(:final id, :final result):
          _pending.remove(id)?.complete(result);
        case SpeechWorkerEvent event:
          _events.add(event);
        case WorkerLog(:final message, :final error):
          if (error) {
            SmartifyOsLog.warning(_tag, message);
          } else {
            SmartifyOsLog.debug(_tag, message);
          }
      }
    });
    _isolate = await Isolate.spawn(speechWorkerMain, (
      receive.sendPort,
      _nativeLibrary,
    ), debugName: 'SpeechWorker');
    _send = await ready.future;
    SmartifyOsLog.debug(_tag, 'Started');
  }

  Future<Object?> _request(WorkerRequest request) {
    final send = _send;
    if (send == null) return Future.value('The speech worker is not running');
    final id = _nextId++;
    final completer = Completer<Object?>();
    _pending[id] = completer;
    send.send(WorkerCall(id, request));
    return completer.future;
  }

  void _post(WorkerRequest request) => _send?.send(request);
}
