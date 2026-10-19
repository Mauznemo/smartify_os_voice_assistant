/// A voice assistant for SmartifyOS that works without the internet: a wake
/// word or a button, your own commands, and spoken answers.
///
/// ```dart
/// await SmartifyOs().init(
///   extensions: [
///     VoiceAssistantExtension(
///       wakeWord: 'Hey Miata',
///       commands: [
///         VoiceCommand(
///           id: 'windows_up',
///           title: 'Close the windows',
///           words: [
///             ['window', 'windows'],
///             ['up', 'raise', 'close'],
///           ],
///           onRun: (run) => myCar.windows(up: true),
///         ),
///       ],
///     ),
///   ],
/// );
/// ```
///
/// [SmartifyOsVoiceAssistant] starts it from a button of your own and adds
/// commands later, [SpeechModels] lists the models it can run.
library;

export 'src/providers/voice_assistant_provider.dart';
export 'src/services/voice_assistant/commands/built_in_voice_commands.dart'
    show VoiceCommands;
export 'src/services/voice_assistant/commands/models/voice_command.dart';
export 'src/services/voice_assistant/commands/models/voice_command_run.dart';
export 'src/services/voice_assistant/commands/models/voice_commands_snapshot.dart';
export 'src/services/voice_assistant/models/voice_ai_server.dart';
export 'src/services/voice_assistant/models/voice_assistant_phase.dart';
export 'src/services/voice_assistant/models/voice_assistant_state.dart';
export 'src/services/voice_assistant/models/voice_speech_server.dart';
export 'src/services/voice_assistant/models/wake_word_log_entry.dart';
export 'src/services/voice_assistant/models/wake_word_sensitivity.dart';
export 'src/services/voice_assistant/smartify_os_voice_assistant.dart';
export 'src/services/voice_assistant/speech_models/models/speech_model.dart';
export 'src/services/voice_assistant/speech_models/models/speech_model_status.dart';
export 'src/services/voice_assistant/speech_models/speech_models.dart';
export 'src/services/voice_assistant/voice_assistant_settings_pages.dart'
    show VoiceAssistantSettingsPages;
export 'src/services/voice_assistant/voice_assistant_sounds.dart';
export 'src/voice_assistant_entries.dart' show VoiceAssistantIds;
export 'src/voice_assistant_extension.dart';
