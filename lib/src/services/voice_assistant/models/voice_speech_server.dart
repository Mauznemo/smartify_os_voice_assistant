import 'package:freezed_annotation/freezed_annotation.dart';

part 'voice_speech_server.freezed.dart';

/// A server that speaks the answers instead of the car, for a voice the car
/// is too slow to run itself.
///
/// Anything that speaks the OpenAI speech API (`/v1/audio/speech`) works,
/// for example Kokoro-FastAPI or a Qwen3-TTS server on a computer at home.
///
/// ```dart
/// VoiceAssistantExtension(
///   speechServer: const VoiceSpeechServer(
///     url: 'http://192.168.1.20:8880/v1',
///     model: 'qwen3-tts',
///     voice: 'aiden',
///   ),
/// )
/// ```
///
/// Without a connection the car speaks with its own voice instead.
@freezed
abstract class VoiceSpeechServer with _$VoiceSpeechServer {
  const factory VoiceSpeechServer({
    /// Where the server is, up to and including `/v1`.
    required String url,

    /// Which model to use, as the server names it.
    required String model,

    /// Which voice, as the server names it.
    required String voice,

    /// The key the server wants, if it wants one.
    String? apiKey,

    /// How long to wait for a sentence before using the car's own voice.
    @Default(Duration(seconds: 8)) Duration timeout,
  }) = _VoiceSpeechServer;
}
