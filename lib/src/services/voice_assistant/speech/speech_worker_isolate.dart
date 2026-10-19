import 'dart:convert';
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa;
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech/speech_worker.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/models/speech_model.dart';

/// Internal: a message to the speech worker's isolate.
sealed class WorkerRequest {
  const WorkerRequest();
}

class LoadWakeWord extends WorkerRequest {
  final Map<String, String> files;

  /// One keyword per line, in sherpa-onnx's `keywords.txt` format.
  final String keywords;

  const LoadWakeWord({required this.files, required this.keywords});
}

class LoadRecognizer extends WorkerRequest {
  final SpeechEngine engine;
  final Map<String, String> files;
  final String voiceDetection;
  final String languageCode;
  final int threads;

  const LoadRecognizer({
    required this.engine,
    required this.files,
    required this.voiceDetection,
    required this.languageCode,
    required this.threads,
  });
}

class LoadVoice extends WorkerRequest {
  final SpeechEngine engine;
  final Map<String, String> files;
  final int speaker;
  final int threads;

  const LoadVoice({
    required this.engine,
    required this.files,
    required this.speaker,
    required this.threads,
  });
}

class Unload extends WorkerRequest {
  /// `wakeWord`, `recognizer` or `voice`.
  final String what;

  const Unload(this.what);
}

class ListenForWakeWord extends WorkerRequest {
  final bool on;

  const ListenForWakeWord(this.on);
}

class HearWhileWaiting extends WorkerRequest {
  final bool on;

  /// Whether each stretch of speech comes with its audio too.
  final bool keepAudio;

  const HearWhileWaiting(this.on, {this.keepAudio = false});
}

class TestSpellings extends WorkerRequest {
  final Map<String, String> files;

  /// Each candidate's keyword lines, in sherpa-onnx's `keywords.txt` format.
  final List<String> candidates;
  final List<TransferableTypedData> clips;

  const TestSpellings({
    required this.files,
    required this.candidates,
    required this.clips,
  });
}

class StartUtterance extends WorkerRequest {
  const StartUtterance();
}

class FinishUtterance extends WorkerRequest {
  const FinishUtterance();
}

class CancelUtterance extends WorkerRequest {
  const CancelUtterance();
}

class AddAudio extends WorkerRequest {
  final TransferableTypedData samples;

  const AddAudio(this.samples);
}

class Synthesize extends WorkerRequest {
  final String text;

  const Synthesize(this.text);
}

/// Internal: a request that wants an answer.
class WorkerCall {
  final int id;
  final WorkerRequest request;

  const WorkerCall(this.id, this.request);
}

/// Internal: the answer to a [WorkerCall]. A [String] result is what went
/// wrong.
class WorkerReply {
  final int id;
  final Object? result;

  const WorkerReply(this.id, this.result);
}

class SynthesizeResult {
  final TransferableTypedData samples;
  final int sampleRate;

  const SynthesizeResult(this.samples, this.sampleRate);
}

/// Internal: a line for the log, which only the main isolate can write.
class WorkerLog {
  final String message;
  final bool error;

  const WorkerLog(this.message, {this.error = false});
}

/// Internal: where the speech worker's isolate starts.
void speechWorkerMain((SendPort, String?) start) {
  final (main, nativeLibrary) = start;
  final receive = ReceivePort();
  main.send(receive.sendPort);
  final worker = _Worker(main, nativeLibrary);
  receive.listen(worker.handle);
}

class _Worker {
  static const _sampleRate = SpeechWorker.sampleRate;

  /// How long a pause ends what you are saying, on top of the quarter second
  /// the voice detection itself waits.
  static const _endSilence = 0.55;

  /// How long to wait for someone to start talking at all.
  static const _waitForSpeech = 7.0;

  /// The longest anyone gets to talk in one go.
  static const _longestUtterance = 20.0;

  /// How much audio from before the voice detection noticed speech is kept,
  /// so the first sound of the first word is not cut off.
  static const _keepBeforeSpeech = 0.4;

  /// How often what was said so far is shown while you talk.
  static const _partialEvery = 0.8;

  /// A recognizer that takes longer than this for the text so far is too
  /// slow to show it while you talk, and only answers at the end.
  static const _slowestPartial = 0.45;

  final SendPort _main;
  final String? _nativeLibrary;

  _Worker(this._main, this._nativeLibrary);

  bool _bound = false;

  sherpa.KeywordSpotter? _spotter;
  sherpa.OnlineStream? _spotterStream;
  bool _wakeWordOn = false;

  sherpa.OfflineRecognizer? _recognizer;
  sherpa.VoiceActivityDetector? _vad;
  int _vadWindow = 512;

  /// Whether everything said while waiting for the wake word is turned into
  /// text too, for the debug view.
  bool _hearWhileWaiting = false;
  bool _keepAudio = false;
  final _waiting = _SampleBuffer();
  int _waitingFed = 0;

  sherpa.OfflineTts? _tts;
  int _speaker = 0;

  // The utterance being collected, if any.
  bool _listening = false;
  final _utterance = _SampleBuffer();

  /// How much of [_utterance] the voice detection has seen. Audio that
  /// arrived while the recognizer was still loading is caught up on once it
  /// is there.
  int _vadFed = 0;
  int? _firstSpeech;
  int? _lastSpeech;
  int _lastPartial = 0;
  bool _partialsTooSlow = false;

  void handle(Object? message) {
    try {
      switch (message) {
        case WorkerCall(:final id, :final request):
          _main.send(WorkerReply(id, _call(request)));
        case WorkerRequest request:
          _post(request);
      }
    } on Object catch (error) {
      _log('$error', error: true);
    }
  }

  Object? _call(WorkerRequest request) {
    try {
      _bind();
      switch (request) {
        case LoadWakeWord():
          _loadWakeWord(request);
        case LoadRecognizer():
          _loadRecognizer(request);
        case LoadVoice():
          _loadVoice(request);
        case Unload(:final what):
          _unload(what);
        case Synthesize(:final text):
          return _synthesize(text);
        case TestSpellings():
          return _testSpellings(request);
        default:
          _post(request);
      }
      return null;
    } on Object catch (error) {
      return '$error';
    }
  }

  void _post(WorkerRequest request) {
    switch (request) {
      case HearWhileWaiting(:final on, :final keepAudio):
        _hearWhileWaiting = on;
        _keepAudio = keepAudio;
        _waiting.clear();
        _waitingFed = 0;
        _vad?.reset();
      case ListenForWakeWord(:final on):
        _wakeWordOn = on;
        final stream = _spotterStream;
        if (stream != null) _spotter?.reset(stream);
      case StartUtterance():
        _resetUtterance();
        _listening = true;
      case FinishUtterance():
        if (_listening) _finish();
      case CancelUtterance():
        _resetUtterance();
      case AddAudio(:final samples):
        _addAudio(samples.materialize().asFloat32List());
      default:
        _call(request);
    }
  }

  void _bind() {
    if (_bound) return;
    sherpa.initBindings(_nativeLibrary);
    _bound = true;
  }

  void _loadWakeWord(LoadWakeWord request) {
    _unload('wakeWord');
    final files = request.files;
    final keywords = request.keywords;
    final spotter = sherpa.KeywordSpotter(
      sherpa.KeywordSpotterConfig(
        model: sherpa.OnlineModelConfig(
          transducer: sherpa.OnlineTransducerModelConfig(
            encoder: files['encoder']!,
            decoder: files['decoder']!,
            joiner: files['joiner']!,
          ),
          tokens: files['tokens']!,
          numThreads: 1,
          debug: false,
        ),
        // Four, the default, let an unusual word like "Miata" drop out of
        // the search before it was finished: with 16 it was heard far more
        // often in testing.
        maxActivePaths: 16,
        keywordsBuf: keywords,
        keywordsBufSize: utf8.encode(keywords).length,
      ),
    );
    _spotter = spotter;
    _spotterStream = spotter.createStream();
    _log('Wake word loaded, ${keywords.split('\n').length} ways of hearing it');
  }

  void _loadRecognizer(LoadRecognizer request) {
    // Not through _unload: what is being said right now was already being
    // collected while this loads, and has to stay.
    _recognizer?.free();
    _recognizer = null;
    _vad?.free();
    _vad = null;
    final files = request.files;
    final threads = request.threads;

    final model = switch (request.engine) {
      SpeechEngine.nemoTransducer => sherpa.OfflineModelConfig(
        transducer: sherpa.OfflineTransducerModelConfig(
          encoder: files['encoder']!,
          decoder: files['decoder']!,
          joiner: files['joiner']!,
        ),
        tokens: files['tokens']!,
        modelType: 'nemo_transducer',
        numThreads: threads,
        debug: false,
      ),
      SpeechEngine.whisper => sherpa.OfflineModelConfig(
        whisper: sherpa.OfflineWhisperModelConfig(
          encoder: files['encoder']!,
          decoder: files['decoder']!,
          language: request.languageCode,
          task: 'transcribe',
        ),
        tokens: files['tokens']!,
        numThreads: threads,
        debug: false,
      ),
      SpeechEngine.moonshine => sherpa.OfflineModelConfig(
        moonshine: sherpa.OfflineMoonshineModelConfig(
          preprocessor: files['preprocessor']!,
          encoder: files['encoder']!,
          uncachedDecoder: files['uncachedDecoder']!,
          cachedDecoder: files['cachedDecoder']!,
        ),
        tokens: files['tokens']!,
        numThreads: threads,
        debug: false,
      ),
      final engine => throw ArgumentError('$engine cannot recognize speech'),
    };
    _recognizer = sherpa.OfflineRecognizer(
      sherpa.OfflineRecognizerConfig(model: model),
    );

    final vadConfig = sherpa.VadModelConfig(
      sileroVad: sherpa.SileroVadModelConfig(
        model: request.voiceDetection,
        minSilenceDuration: 0.25,
        minSpeechDuration: 0.1,
        maxSpeechDuration: _longestUtterance,
      ),
      numThreads: 1,
      debug: false,
    );
    _vadWindow = vadConfig.sileroVad.windowSize;
    _vad = sherpa.VoiceActivityDetector(
      config: vadConfig,
      bufferSizeInSeconds: _longestUtterance + 10,
    );
    _partialsTooSlow = false;
    _log('Recognizer loaded (${request.engine.name}, $threads threads)');
  }

  void _loadVoice(LoadVoice request) {
    _unload('voice');
    final files = request.files;
    final model = switch (request.engine) {
      SpeechEngine.kokoro => sherpa.OfflineTtsModelConfig(
        kokoro: sherpa.OfflineTtsKokoroModelConfig(
          model: files['model']!,
          voices: files['voices']!,
          tokens: files['tokens']!,
          dataDir: files['dataDir']!,
          dictDir: files['dictDir'] ?? '',
          lexicon: files['lexicon'] ?? '',
        ),
        numThreads: request.threads,
        debug: false,
      ),
      SpeechEngine.piper => sherpa.OfflineTtsModelConfig(
        vits: sherpa.OfflineTtsVitsModelConfig(
          model: files['model']!,
          tokens: files['tokens']!,
          dataDir: files['dataDir']!,
        ),
        numThreads: request.threads,
        debug: false,
      ),
      final engine => throw ArgumentError('$engine cannot speak'),
    };
    _tts = sherpa.OfflineTts(sherpa.OfflineTtsConfig(model: model));
    _speaker = request.speaker;
    _log('Voice loaded (${request.engine.name})');
  }

  void _unload(String what) {
    switch (what) {
      case 'wakeWord':
        _spotterStream?.free();
        _spotterStream = null;
        _spotter?.free();
        _spotter = null;
      case 'recognizer':
        _resetUtterance();
        _recognizer?.free();
        _recognizer = null;
        _vad?.free();
        _vad = null;
      case 'voice':
        _tts?.free();
        _tts = null;
    }
  }

  SynthesizeResult _synthesize(String text) {
    final tts = _tts;
    if (tts == null) throw StateError('No voice is loaded');
    final audio = tts.generate(text: text, sid: _speaker);
    return SynthesizeResult(
      TransferableTypedData.fromList([audio.samples]),
      audio.sampleRate,
    );
  }

  void _addAudio(Float32List samples) {
    if (_listening) {
      _listenTo(samples);
      return;
    }
    if (_wakeWordOn) _spotWakeWord(samples);
    if (_hearWhileWaiting) _hear(samples);
  }

  /// Turns every stretch of speech into text while nobody is talking to the
  /// assistant, so the debug view can show what the microphone hears.
  void _hear(Float32List samples) {
    final vad = _vad;
    if (vad == null || _recognizer == null) return;
    _waiting.add(samples);
    while (_waiting.length - _waitingFed >= _vadWindow) {
      vad.acceptWaveform(_waiting.view(_waitingFed, _waitingFed + _vadWindow));
      _waitingFed += _vadWindow;
    }
    if (_waitingFed == _waiting.length) {
      _waiting.clear();
      _waitingFed = 0;
    }
    while (!vad.isEmpty()) {
      final samples = vad.front().samples;
      final text = _recognize(samples);
      vad.pop();
      if (text.isEmpty) continue;
      _main.send(
        HeardWhileWaiting(
          text,
          audio: _keepAudio ? TransferableTypedData.fromList([samples]) : null,
        ),
      );
    }
  }

  /// Which of [TestSpellings.clips] each candidate spelling hears, one row
  /// per candidate.
  ///
  /// The model is loaded once, for a keyword that can never be heard, and
  /// each candidate gets a stream of its own that listens for its keywords
  /// on top of that, which is far quicker than loading it per candidate.
  List<List<bool>> _testSpellings(TestSpellings request) {
    final files = request.files;
    const never = 'Z X Q Z X Q Z X Q :0.1 #0.99 @NEVER';
    final spotter = sherpa.KeywordSpotter(
      sherpa.KeywordSpotterConfig(
        model: sherpa.OnlineModelConfig(
          transducer: sherpa.OnlineTransducerModelConfig(
            encoder: files['encoder']!,
            decoder: files['decoder']!,
            joiner: files['joiner']!,
          ),
          tokens: files['tokens']!,
          numThreads: 1,
          debug: false,
        ),
        maxActivePaths: 16,
        keywordsBuf: never,
        keywordsBufSize: utf8.encode(never).length,
      ),
    );
    final clips = [
      for (final clip in request.clips) clip.materialize().asFloat32List(),
    ];
    // Quiet before and after, the way it is said in the car.
    final before = Float32List(_sampleRate ~/ 4);
    final after = Float32List(_sampleRate);
    try {
      return [
        for (final candidate in request.candidates)
          [
            for (final clip in clips)
              () {
                final stream = spotter.createStream(
                  keywords: candidate.replaceAll('\n', '/'),
                );
                try {
                  for (final part in [before, clip, after]) {
                    stream.acceptWaveform(
                      samples: part,
                      sampleRate: _sampleRate,
                    );
                    while (spotter.isReady(stream)) {
                      spotter.decode(stream);
                      final keyword = spotter.getResult(stream).keyword;
                      if (keyword.isNotEmpty && keyword != 'NEVER') {
                        return true;
                      }
                    }
                  }
                  return false;
                } finally {
                  stream.free();
                }
              }(),
          ],
      ];
    } finally {
      spotter.free();
    }
  }

  void _spotWakeWord(Float32List samples) {
    final spotter = _spotter;
    final stream = _spotterStream;
    if (spotter == null || stream == null) return;
    stream.acceptWaveform(samples: samples, sampleRate: _sampleRate);
    while (spotter.isReady(stream)) {
      spotter.decode(stream);
      final keyword = spotter.getResult(stream).keyword;
      if (keyword.isNotEmpty) {
        spotter.reset(stream);
        _main.send(WakeWordHeard(keyword));
        return;
      }
    }
  }

  void _listenTo(Float32List samples) {
    _utterance.add(samples);
    final vad = _vad;

    // Until the recognizer is there, the audio is only collected, and looked
    // at once it arrives.
    if (vad == null || _recognizer == null) return;

    while (_utterance.length - _vadFed >= _vadWindow) {
      vad.acceptWaveform(_utterance.view(_vadFed, _vadFed + _vadWindow));
      _vadFed += _vadWindow;
      if (vad.isDetected()) {
        if (_firstSpeech == null) _main.send(const SpeechStarted());
        _firstSpeech ??= _vadFed;
        _lastSpeech = _vadFed;
      }
      // The detector keeps every stretch of speech it found, which nothing
      // here needs.
      while (!vad.isEmpty()) {
        vad.pop();
      }
    }

    final seconds = _vadFed / _sampleRate;
    final lastSpeech = _lastSpeech;
    if (lastSpeech == null) {
      if (seconds > _waitForSpeech) {
        _resetUtterance();
        _main.send(const NothingHeard());
      }
      return;
    }
    final quiet = (_vadFed - lastSpeech) / _sampleRate;
    if (quiet > _endSilence || seconds > _longestUtterance) {
      _finish();
      return;
    }

    if (!_partialsTooSlow &&
        (_utterance.length - _lastPartial) / _sampleRate > _partialEvery) {
      _lastPartial = _utterance.length;
      final started = DateTime.now();
      final text = _recognize(_spokenPart());
      final took = DateTime.now().difference(started).inMilliseconds / 1000;
      if (took > _slowestPartial) {
        _partialsTooSlow = true;
        _log('Too slow to show text while talking (${took}s)');
      }
      if (text.isNotEmpty) _main.send(PartialText(text));
    }
  }

  void _finish() {
    final recognizer = _recognizer;
    final samples = _spokenPart();
    _resetUtterance();
    if (recognizer == null) {
      _main.send(const FinalText(''));
      return;
    }
    // The recognizer was still loading when the talking ended: what was
    // collected meanwhile has never been looked at, so it is all of it.
    _main.send(FinalText(_recognize(samples)));
  }

  /// A copy of what was collected, from just before the first word.
  Float32List _spokenPart() {
    final first = _firstSpeech;
    final from = first == null
        ? 0
        : math.max(
            0,
            first - _vadWindow - (_keepBeforeSpeech * _sampleRate).round(),
          );
    return Float32List.fromList(
      _utterance.view(math.min(from, _utterance.length), _utterance.length),
    );
  }

  String _recognize(Float32List samples) {
    final recognizer = _recognizer;
    if (recognizer == null || samples.isEmpty) return '';
    final stream = recognizer.createStream();
    try {
      stream.acceptWaveform(samples: samples, sampleRate: _sampleRate);
      recognizer.decode(stream);
      return recognizer.getResult(stream).text.trim();
    } finally {
      stream.free();
    }
  }

  void _resetUtterance() {
    _listening = false;
    _utterance.clear();
    _vadFed = 0;
    _firstSpeech = null;
    _lastSpeech = null;
    _lastPartial = 0;
    _vad?.reset();
  }

  void _log(String message, {bool error = false}) =>
      _main.send(WorkerLog(message, error: error));
}

/// Collects audio, growing as it goes.
class _SampleBuffer {
  Float32List _data = Float32List(_SpeechSamples.initial);
  int _length = 0;

  int get length => _length;

  void add(Float32List samples) {
    if (_length + samples.length > _data.length) {
      final grown = Float32List(
        math.max(_data.length * 2, _length + samples.length),
      );
      grown.setAll(0, Float32List.sublistView(_data, 0, _length));
      _data = grown;
    }
    _data.setAll(_length, samples);
    _length += samples.length;
  }

  void clear() => _length = 0;

  /// The samples from [start] to [end], without copying them. Only valid
  /// until the next [add].
  Float32List view(int start, int end) =>
      Float32List.sublistView(_data, start, end);
}

abstract final class _SpeechSamples {
  /// Room for ten seconds before the buffer has to grow.
  static const initial = SpeechWorker.sampleRate * 10;
}
