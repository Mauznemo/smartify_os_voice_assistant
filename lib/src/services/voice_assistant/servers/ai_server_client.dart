import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:smartify_os_core/date_time.dart';
import 'package:smartify_os_core/utils.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/models/voice_command.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/models/voice_ai_server.dart';

/// Internal: what the AI server made of a sentence.
class AiServerAnswer {
  /// What to say back. Empty when it ran a command and had nothing to add.
  final String text;

  /// The commands it ran, by `id`.
  final List<String> ran;

  const AiServerAnswer({required this.text, required this.ran});
}

/// Internal: asks an AI server what to do about a sentence, through the
/// OpenAI chat API, with every voice command handed over as a tool it can
/// call.
///
/// The car runs the commands, never the server: it only says which one, and
/// the car tells it what came of it, until it has an answer. Anything going
/// wrong (no connection, a server that is too slow, an answer that is not
/// what was asked for) comes back as `null`, and the car then falls back to
/// its own phrases.
abstract final class AiServerClient {
  static const _tag = 'VoiceAssistant.AiServer';

  /// How many times the server may run commands before it has to answer.
  static const _rounds = 4;

  static Future<AiServerAnswer?> ask({
    required VoiceAiServer server,
    required String text,
    required List<VoiceCommand> commands,
    required String languageCode,
    required Future<String?> Function(
      VoiceCommand command,
      Map<String, String> values,
    )
    runCommand,
  }) async {
    final byId = {for (final command in commands) command.id: command};
    final messages = <Map<String, Object?>>[
      {'role': 'system', 'content': _instructions(server, languageCode)},
      {'role': 'user', 'content': text},
    ];
    final ran = <String>[];

    try {
      for (var round = 0; round < _rounds; round++) {
        final reply = await _chat(server, messages, commands);
        if (reply == null) return null;
        final calls = reply['tool_calls'];
        if (calls is! List || calls.isEmpty) {
          return AiServerAnswer(
            text: (reply['content'] as String? ?? '').trim(),
            ran: ran,
          );
        }

        messages.add({
          'role': 'assistant',
          'content': reply['content'],
          'tool_calls': calls,
        });
        for (final call in calls) {
          if (call case {
            'id': final String id,
            'function': {
              'name': final String name,
              'arguments': final String arguments,
            },
          }) {
            final command = byId[name];
            String result;
            if (command == null) {
              result = 'There is no command called $name.';
            } else {
              ran.add(name);
              final answer = await runCommand(command, _values(arguments));
              result = answer == null || answer.isEmpty ? 'Done.' : answer;
            }
            messages.add({
              'role': 'tool',
              'tool_call_id': id,
              'content': result,
            });
          }
        }
      }
      return AiServerAnswer(text: '', ran: ran);
    } on Object catch (error) {
      SmartifyOsLog.warning(_tag, 'Could not ask ${server.url}', error);
      return null;
    }
  }

  static Future<Map<String, Object?>?> _chat(
    VoiceAiServer server,
    List<Map<String, Object?>> messages,
    List<VoiceCommand> commands,
  ) async {
    final body = jsonEncode({
      'model': server.model,
      'messages': messages,
      if (commands.isNotEmpty) 'tools': [for (final c in commands) _tool(c)],
      if (commands.isNotEmpty) 'tool_choice': 'auto',
    });

    final client = HttpClient()..connectionTimeout = server.timeout;
    try {
      final response = await () async {
        final request = await client.postUrl(
          Uri.parse('${_trimSlash(server.url)}/chat/completions'),
        );
        request.headers.contentType = ContentType.json;
        final key = server.apiKey;
        if (key != null && key.isNotEmpty) {
          request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $key');
        }
        request.add(utf8.encode(body));
        final response = await request.close();
        return (
          response.statusCode,
          await response.transform(utf8.decoder).join(),
        );
      }().timeout(server.timeout);

      final (status, text) = response;
      if (status != HttpStatus.ok) {
        SmartifyOsLog.warning(_tag, 'The server answered $status: $text');
        return null;
      }
      final json = jsonDecode(text);
      if (json case {
        'choices': [{'message': final Map<String, Object?> m}, ...],
      }) {
        return m;
      }
      SmartifyOsLog.warning(_tag, 'Did not understand the answer: $text');
      return null;
    } on TimeoutException {
      SmartifyOsLog.warning(_tag, 'No answer within ${server.timeout}');
      return null;
    } finally {
      client.close(force: true);
    }
  }

  static Map<String, Object?> _tool(VoiceCommand command) => {
    'type': 'function',
    'function': {
      'name': command.id,
      'description': [
        command.title,
        if (command.description != null) command.description,
      ].join('. '),
      'parameters': {
        'type': 'object',
        'properties': {
          for (final name in command.valueNames)
            name: {
              'type': 'string',
              if (command.values[name] case final String description)
                'description': description,
            },
        },
      },
    },
  };

  static Map<String, String> _values(String arguments) {
    try {
      final json = jsonDecode(arguments.isEmpty ? '{}' : arguments);
      if (json is! Map) return const {};
      return {
        for (final MapEntry(:key, :value) in json.entries)
          if (value != null) '$key': '$value',
      };
    } on FormatException {
      return const {};
    }
  }

  static String _instructions(VoiceAiServer server, String languageCode) {
    final now = SmartifyOsTime.now;
    final time =
        '${now.year}-${_two(now.month)}-${_two(now.day)} '
        '${_two(now.hour)}:${_two(now.minute)}';
    final language = _languageNames[languageCode] ?? languageCode;
    return [
      'You are the voice assistant built into a car. The driver talks to you '
          'while driving, and your answer is read out loud.',
      'Always answer in $language, in one or two short sentences, without '
          'lists, markdown or emoji.',
      'Use the tools to do what the driver asks. When a tool did it, confirm '
          'it in a few words. When nothing you can do fits, say so briefly.',
      'It is $time.',
      if (server.instructions case final String extra) extra,
    ].join('\n');
  }

  static String _two(int value) => value.toString().padLeft(2, '0');

  static String _trimSlash(String url) =>
      url.endsWith('/') ? url.substring(0, url.length - 1) : url;

  static const _languageNames = {
    'en': 'English',
    'de': 'German',
    'fr': 'French',
    'es': 'Spanish',
    'it': 'Italian',
    'nl': 'Dutch',
    'pl': 'Polish',
    'pt': 'Portuguese',
    'sv': 'Swedish',
  };
}
