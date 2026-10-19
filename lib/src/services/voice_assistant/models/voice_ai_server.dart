import 'package:freezed_annotation/freezed_annotation.dart';

part 'voice_ai_server.freezed.dart';

/// An AI server that works out what you meant, so you do not have to write
/// out every way of saying a command.
///
/// Anything that speaks the OpenAI chat API works: a model on your own
/// computer through Ollama, LM Studio or llama.cpp, or a service on the
/// internet. Your commands are handed to it as tools, so it can run them.
///
/// ```dart
/// VoiceAssistantExtension(
///   aiServer: const VoiceAiServer(
///     url: 'http://192.168.1.20:11434/v1', // Ollama at home
///     model: 'qwen3:8b',
///   ),
/// )
/// ```
///
/// Without a connection the car falls back to matching your commands by
/// their phrases, so the basics keep working in a tunnel.
@freezed
abstract class VoiceAiServer with _$VoiceAiServer {
  const factory VoiceAiServer({
    /// Where the server is, up to and including `/v1`, for example
    /// `'https://api.openai.com/v1'`.
    required String url,

    /// Which model to ask, as the server names it.
    required String model,

    /// The key the server wants, if it wants one.
    String? apiKey,

    /// Anything the assistant should know about your car or how to answer,
    /// added to what SmartifyOS tells it anyway (to answer short, in the
    /// car's language).
    String? instructions,

    /// How long to wait for an answer before falling back to the car.
    @Default(Duration(seconds: 15)) Duration timeout,
  }) = _VoiceAiServer;
}
