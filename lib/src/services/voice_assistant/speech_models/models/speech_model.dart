import 'package:freezed_annotation/freezed_annotation.dart';

part 'speech_model.freezed.dart';

/// What a speech model is for.
enum SpeechModelKind {
  /// Turns what you say into text.
  recognizer,

  /// Speaks the answers.
  voice,

  /// Listens for the wake word.
  wakeWord,

  /// Notices when you start and stop talking.
  voiceDetection,
}

/// Internal: which kind of network a model is, which decides how it is
/// loaded.
enum SpeechEngine {
  nemoTransducer,
  whisper,
  moonshine,
  kokoro,
  piper,
  keywordSpotter,
  sileroVad,
}

/// One piece of a model to download.
@freezed
sealed class SpeechModelPart with _$SpeechModelPart {
  /// A single file, saved as [path] in the model's folder.
  const factory SpeechModelPart.file({
    required String url,
    required String path,
  }) = SpeechModelFile;

  /// Every file in [folder] of a Hugging Face repository, kept at the same
  /// path in the model's folder.
  const factory SpeechModelPart.huggingFaceFolder({
    required String repo,
    required String folder,
  }) = SpeechModelHuggingFaceFolder;

  /// A `.tar.bz2` archive, of which only the files in [keep] are kept: the
  /// path in the archive, and where it goes in the model's folder.
  const factory SpeechModelPart.archive({
    required String url,
    required Map<String, String> keep,
  }) = SpeechModelArchive;
}

/// A speech model the car can download and run on its own: a way of
/// understanding what you say, or a voice to answer with.
///
/// The ones SmartifyOS knows about are in `SpeechModels`. They come from the
/// sherpa-onnx project, which turns them into a form a car's processor can
/// run.
@freezed
abstract class SpeechModel with _$SpeechModel {
  const SpeechModel._();

  const factory SpeechModel({
    /// A short name for it, unique among all models.
    required String id,
    required SpeechModelKind kind,

    /// Internal: how it is loaded.
    required SpeechEngine engine,

    /// The folder it is kept in. Voices that share their files (several
    /// voices of one model) share a folder too, and are downloaded once.
    required String folder,

    /// What to download into [folder].
    required List<SpeechModelPart> parts,

    /// Internal: which file in [folder] is which part of the network, by the
    /// name sherpa-onnx gives it (`encoder`, `tokens`, ...).
    required Map<String, String> files,

    /// The languages it understands or speaks, as two letter codes. Empty for
    /// almost all of them.
    @Default(<String>{}) Set<String> languages,

    /// Roughly how much space it takes, in megabytes.
    @Default(0) int sizeMb,

    /// Which of the voices in the files this is, for a voice model with
    /// several.
    @Default(0) int speaker,

    /// The name shown in Settings, for a model SmartifyOS does not know.
    String? title,

    /// What it is good at, for a model SmartifyOS does not know.
    String? about,
  }) = _SpeechModel;

  /// Whether it understands or speaks [languageCode].
  bool supports(String languageCode) =>
      languages.isEmpty || languages.contains(languageCode);
}
