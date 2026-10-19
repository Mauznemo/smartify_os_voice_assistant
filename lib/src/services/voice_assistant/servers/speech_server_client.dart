import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:smartify_os_core/utils.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/models/voice_speech_server.dart';

/// Internal: asks a speech server to speak a sentence, through the OpenAI
/// speech API.
abstract final class SpeechServerClient {
  static const _tag = 'VoiceAssistant.SpeechServer';

  /// The sentence as a WAV file, or `null` when the server could not be
  /// reached in time.
  static Future<Uint8List?> speak(VoiceSpeechServer server, String text) async {
    final client = HttpClient()..connectionTimeout = server.timeout;
    try {
      return await () async {
        final url = server.url.endsWith('/')
            ? server.url.substring(0, server.url.length - 1)
            : server.url;
        final request = await client.postUrl(Uri.parse('$url/audio/speech'));
        request.headers.contentType = ContentType.json;
        final key = server.apiKey;
        if (key != null && key.isNotEmpty) {
          request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $key');
        }
        request.add(
          utf8.encode(
            jsonEncode({
              'model': server.model,
              'voice': server.voice,
              'input': text,
              'response_format': 'wav',
            }),
          ),
        );
        final response = await request.close();
        final builder = BytesBuilder(copy: false);
        await response.forEach(builder.add);
        if (response.statusCode != HttpStatus.ok) {
          SmartifyOsLog.warning(
            _tag,
            'The server answered ${response.statusCode}',
          );
          return null;
        }
        return builder.takeBytes();
      }().timeout(server.timeout);
    } on Object catch (error) {
      SmartifyOsLog.warning(_tag, 'Could not reach ${server.url}', error);
      return null;
    } finally {
      client.close(force: true);
    }
  }
}
