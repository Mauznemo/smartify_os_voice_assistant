import 'package:smartify_os_core/saved_values.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/models/wake_word_sensitivity.dart';

/// Internal: what the driver picked in Settings, kept between drives.
///
/// The defaults come from the extension's own setup, so they are made once
/// it starts rather than being constants.
class VoiceAssistantSettings {
  /// Whether the wake word is on.
  final SavedValue<bool> wakeWord;

  /// How easily the wake word starts it, a [WakeWordSensitivity] by name.
  final SavedValue<String> sensitivity;

  /// The `id` of the speech model that understands what is said.
  final SavedValue<String> recognizer;

  /// Whether answers are spoken, not only shown.
  final SavedValue<bool> speakAnswers;

  /// Whether to ask the AI server, when there is one.
  final SavedValue<bool> useAiServer;

  /// The spellings of the wake word the car learned from the driver's
  /// voice, one per line.
  final SavedValue<String> learnedSpellings;

  VoiceAssistantSettings({
    required bool wakeWordByDefault,
    required String recognizerByDefault,
  }) : wakeWord = SavedValue(
         'voice_assistant.wake_word',
         defaultValue: wakeWordByDefault,
       ),
       sensitivity = SavedValue(
         'voice_assistant.wake_word_sensitivity',
         defaultValue: WakeWordSensitivity.normal.name,
       ),
       recognizer = SavedValue(
         'voice_assistant.recognizer',
         defaultValue: recognizerByDefault,
       ),
       speakAnswers = const SavedValue(
         'voice_assistant.speak_answers',
         defaultValue: true,
       ),
       useAiServer = const SavedValue(
         'voice_assistant.use_ai_server',
         defaultValue: true,
       ),
       learnedSpellings = const SavedValue(
         'voice_assistant.learned_spellings',
         defaultValue: '',
       );

  /// The voice picked for [languageCode]: a speech model's `id`, or
  /// [server] for the speech server. [byDefault] until the driver picks one.
  SavedValue<String> voiceFor(String languageCode, {String byDefault = ''}) =>
      SavedValue(
        'voice_assistant.voice.$languageCode',
        defaultValue: byDefault,
      );

  /// What [voiceFor] holds when the speech server speaks.
  static const server = 'server';

  WakeWordSensitivity get wakeWordSensitivity =>
      WakeWordSensitivity.values.asNameMap()[sensitivity.value] ??
      WakeWordSensitivity.normal;
}
