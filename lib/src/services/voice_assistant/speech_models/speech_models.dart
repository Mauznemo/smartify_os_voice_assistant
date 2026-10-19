import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/models/speech_model.dart';

/// The speech models the voice assistant can download and run, all on the
/// car itself.
///
/// For understanding what you say, pick by what matters more to you. The
/// driver can switch between them in Settings too:
///
/// | | Speed | Accuracy | Languages | Size |
/// |---|---|---|---|---|
/// | [parakeet] | good on a mini PC, slow on a Pi | best | 25 European | 670 MB |
/// | [whisperBase] | good | good | nearly all | 160 MB |
/// | [whisperTiny] | fast | rough | nearly all | 105 MB |
/// | [moonshineBase] | fast | very good | English | 290 MB |
/// | [moonshineTiny] | fastest | good | English | 125 MB |
///
/// The voices answer in one language each. [voices] has them all.
abstract final class SpeechModels {
  static const _hf = 'https://huggingface.co/csukuangfj';
  static const _releases =
      'https://github.com/k2-fsa/sherpa-onnx/releases/download';

  static SpeechModelPart _file(String repo, String path) =>
      SpeechModelPart.file(url: '$_hf/$repo/resolve/main/$path', path: path);

  /// NVIDIA's Parakeet TDT 0.6B v3: the most accurate, and finds the
  /// language on its own.
  static final parakeet = SpeechModel(
    id: 'parakeet_v3',
    kind: SpeechModelKind.recognizer,
    engine: SpeechEngine.nemoTransducer,
    folder: 'parakeet-tdt-0.6b-v3-int8',
    parts: [
      for (final file in _parakeetFiles)
        _file('sherpa-onnx-nemo-parakeet-tdt-0.6b-v3-int8', file),
    ],
    files: const {
      'encoder': 'encoder.int8.onnx',
      'decoder': 'decoder.int8.onnx',
      'joiner': 'joiner.int8.onnx',
      'tokens': 'tokens.txt',
    },
    languages: const {
      'bg', 'hr', 'cs', 'da', 'nl', 'en', 'et', 'fi', 'fr', 'de', 'el', //
      'hu', 'it', 'lv', 'lt', 'mt', 'pl', 'pt', 'ro', 'sk', 'sl', 'es', //
      'sv', 'ru', 'uk',
    },
    sizeMb: 670,
  );

  static const _parakeetFiles = [
    'encoder.int8.onnx',
    'decoder.int8.onnx',
    'joiner.int8.onnx',
    'tokens.txt',
  ];

  /// OpenAI's Whisper base: a good balance, in nearly every language.
  static final whisperBase = _whisper('base', sizeMb: 160);

  /// OpenAI's Whisper tiny: quick, in nearly every language, but gets more
  /// wrong.
  static final whisperTiny = _whisper('tiny', sizeMb: 105);

  static SpeechModel _whisper(String size, {required int sizeMb}) =>
      SpeechModel(
        id: 'whisper_$size',
        kind: SpeechModelKind.recognizer,
        engine: SpeechEngine.whisper,
        folder: 'whisper-$size',
        parts: [
          for (final file in [
            '$size-encoder.int8.onnx',
            '$size-decoder.int8.onnx',
            '$size-tokens.txt',
          ])
            _file('sherpa-onnx-whisper-$size', file),
        ],
        files: {
          'encoder': '$size-encoder.int8.onnx',
          'decoder': '$size-decoder.int8.onnx',
          'tokens': '$size-tokens.txt',
        },
        sizeMb: sizeMb,
      );

  /// Useful Sensors' Moonshine base: fast and accurate, English only.
  static final moonshineBase = _moonshine('base', sizeMb: 290);

  /// Useful Sensors' Moonshine tiny: the fastest, English only.
  static final moonshineTiny = _moonshine('tiny', sizeMb: 125);

  static SpeechModel _moonshine(String size, {required int sizeMb}) =>
      SpeechModel(
        id: 'moonshine_${size}_en',
        kind: SpeechModelKind.recognizer,
        engine: SpeechEngine.moonshine,
        folder: 'moonshine-$size-en-int8',
        parts: [
          for (final file in _moonshineFiles)
            _file('sherpa-onnx-moonshine-$size-en-int8', file),
        ],
        files: const {
          'preprocessor': 'preprocess.onnx',
          'encoder': 'encode.int8.onnx',
          'uncachedDecoder': 'uncached_decode.int8.onnx',
          'cachedDecoder': 'cached_decode.int8.onnx',
          'tokens': 'tokens.txt',
        },
        languages: const {'en'},
        sizeMb: sizeMb,
      );

  static const _moonshineFiles = [
    'preprocess.onnx',
    'encode.int8.onnx',
    'uncached_decode.int8.onnx',
    'cached_decode.int8.onnx',
    'tokens.txt',
  ];

  /// Kokoro's "Fable": British English, natural sounding. Needs a mini PC:
  /// on a Raspberry Pi it takes longer to speak than the answer lasts, so
  /// pick [piperAlan] there.
  ///
  /// The full precision model, not the smaller int8 one, which took more
  /// than twice as long to speak on an ARM processor (an M-series Mac).
  static final kokoroFable = SpeechModel(
    id: 'kokoro_fable',
    kind: SpeechModelKind.voice,
    engine: SpeechEngine.kokoro,
    folder: 'kokoro-multi-lang-v1_0',
    parts: [
      for (final file in [
        'model.onnx',
        'voices.bin',
        'tokens.txt',
        'lexicon-gb-en.txt',
      ])
        _file('kokoro-multi-lang-v1_0', file),
      const SpeechModelPart.huggingFaceFolder(
        repo: 'csukuangfj/kokoro-multi-lang-v1_0',
        folder: 'espeak-ng-data',
      ),
      const SpeechModelPart.huggingFaceFolder(
        repo: 'csukuangfj/kokoro-multi-lang-v1_0',
        folder: 'dict',
      ),
    ],
    files: const {
      'model': 'model.onnx',
      'voices': 'voices.bin',
      'tokens': 'tokens.txt',
      'lexicon': 'lexicon-gb-en.txt',
      'dataDir': 'espeak-ng-data',
      'dictDir': 'dict',
    },
    languages: const {'en'},
    // bm_fable, see the speaker list of kokoro-multi-lang-v1_0 in the
    // sherpa-onnx documentation.
    speaker: 25,
    sizeMb: 390,
  );

  /// Piper's "Alan": British English, light enough for a Raspberry Pi.
  static final piperAlan = _piper('en_GB-alan-medium', 'piper_alan', {'en'});

  /// Piper's "Thorsten": German.
  static final piperThorsten = _piper(
    'de_DE-thorsten-medium',
    'piper_thorsten',
    {'de'},
  );

  static SpeechModel _piper(String name, String id, Set<String> languages) {
    final repo = 'vits-piper-$name';
    return SpeechModel(
      id: id,
      kind: SpeechModelKind.voice,
      engine: SpeechEngine.piper,
      folder: repo,
      parts: [
        _file(repo, '$name.onnx'),
        _file(repo, 'tokens.txt'),
        SpeechModelPart.huggingFaceFolder(
          repo: 'csukuangfj/$repo',
          folder: 'espeak-ng-data',
        ),
      ],
      files: {
        'model': '$name.onnx',
        'tokens': 'tokens.txt',
        'dataDir': 'espeak-ng-data',
      },
      languages: languages,
      sizeMb: 81,
    );
  }

  /// Listens for the wake word. Any phrase works without training, but it is
  /// heard the way an English speaker would say it.
  static final wakeWord = SpeechModel(
    id: 'wake_word',
    kind: SpeechModelKind.wakeWord,
    engine: SpeechEngine.keywordSpotter,
    folder: 'kws-zipformer-gigaspeech-3.3M',
    parts: [
      SpeechModelPart.archive(
        url:
            '$_releases/kws-models/'
            'sherpa-onnx-kws-zipformer-gigaspeech-3.3M-2024-01-01.tar.bz2',
        keep: {
          for (final MapEntry(:key, :value) in _wakeWordFiles.entries)
            'sherpa-onnx-kws-zipformer-gigaspeech-3.3M-2024-01-01/$key': value,
        },
      ),
    ],
    files: const {
      'encoder': 'encoder.int8.onnx',
      'decoder': 'decoder.int8.onnx',
      'joiner': 'joiner.int8.onnx',
      'tokens': 'tokens.txt',
      'bpe': 'bpe.model',
    },
    sizeMb: 6,
  );

  static const _wakeWordFiles = {
    'encoder-epoch-12-avg-2-chunk-16-left-64.int8.onnx': 'encoder.int8.onnx',
    'decoder-epoch-12-avg-2-chunk-16-left-64.int8.onnx': 'decoder.int8.onnx',
    'joiner-epoch-12-avg-2-chunk-16-left-64.int8.onnx': 'joiner.int8.onnx',
    'tokens.txt': 'tokens.txt',
    'bpe.model': 'bpe.model',
  };

  /// Notices when you start and stop talking (Silero VAD).
  static const voiceDetection = SpeechModel(
    id: 'voice_detection',
    kind: SpeechModelKind.voiceDetection,
    engine: SpeechEngine.sileroVad,
    folder: 'silero-vad',
    parts: [
      SpeechModelPart.file(
        url: '$_releases/asr-models/silero_vad.onnx',
        path: 'silero_vad.onnx',
      ),
    ],
    files: {'model': 'silero_vad.onnx'},
    sizeMb: 1,
  );

  /// Every model for understanding what you say.
  static final recognizers = [
    parakeet,
    whisperBase,
    whisperTiny,
    moonshineBase,
    moonshineTiny,
  ];

  /// Every voice to answer with.
  static final voices = [kokoroFable, piperAlan, piperThorsten];

  /// Everything above.
  static final all = [...recognizers, ...voices, wakeWord, voiceDetection];
}
