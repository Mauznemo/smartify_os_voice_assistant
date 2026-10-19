import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/models/voice_command.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/voice_commands_registry.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/models/voice_assistant_state.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/models/speech_model.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/speech_models/speech_model_store.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/voice_assistant_service.dart';

/// The voice assistant, from anywhere in your app: start it from a button of
/// your own, and add commands.
///
/// A physical button that starts and stops it:
///
/// ```dart
/// myButton.presses.listen((_) => SmartifyOsVoiceAssistant.toggleListening());
/// ```
///
/// Or one held down while you talk, like a walkie-talkie:
///
/// ```dart
/// myButton.downs.listen((_) => SmartifyOsVoiceAssistant.startListening());
/// myButton.ups.listen((_) => SmartifyOsVoiceAssistant.stopListening());
/// ```
///
/// A command added later, from another part of your app:
///
/// ```dart
/// SmartifyOsVoiceAssistant.addCommand(
///   VoiceCommand(
///     id: 'lights_on',
///     title: 'Turn the lights on',
///     phrases: ['lights on', 'turn on the lights'],
///     onRun: (run) => myCar.lights(on: true),
///   ),
/// );
/// ```
///
/// **None of these throw**, and all of them do nothing until the extension
/// was set up.
class SmartifyOsVoiceAssistant {
  SmartifyOsVoiceAssistant._();

  static VoiceAssistantService get _service => VoiceAssistantService.instance;
  static VoiceCommandsRegistry get _commands => VoiceCommandsRegistry.instance;

  /// Starts listening, and shows the panel. Does nothing while it already
  /// listens.
  static Future<void> startListening() => _service.startListening();

  /// Stops listening and acts on what was said, for a button that is let go.
  static void stopListening() => _service.stopListening();

  /// What one button does: starts listening, acts on what was said while it
  /// listens, and stops it while it answers.
  static void toggleListening() => _service.toggleListening();

  /// Stops whatever it is doing, and takes the panel away.
  static void closeAssistant() => _service.closeAssistant();

  /// Acts on [text] as if it had been said, for a typed question or to try a
  /// command without talking.
  static Future<void> respondToText(String text) =>
      _service.respondToText(text);

  /// Says [text] out loud in the assistant's voice, with the panel showing
  /// it.
  static Future<void> speakText(String text) => _service.speakText(text);

  /// What it is doing right now, what it heard and what it answered.
  static VoiceAssistantState get state => _service.state;

  /// Emits every time [state] changes.
  static Stream<VoiceAssistantState> get stateChanges => _service.changes;

  /// Whether the wake word is on.
  static bool get wakeWordEnabled =>
      _service.isStarted && _service.settings.wakeWord.value;

  /// Turns the wake word on or off, the same as the switch in Settings.
  static void setWakeWordEnabled(bool enabled) {
    if (!_service.isStarted) return;
    _service.settings.wakeWord.value = enabled;
  }

  /// Adds a command. One with the same `id` is replaced, which is also how
  /// you change a built-in one (see `VoiceCommands`).
  static void addCommand(VoiceCommand command) => _commands.addCommand(command);

  /// Adds several commands at once.
  static void addCommands(Iterable<VoiceCommand> commands) =>
      _commands.addCommands(commands);

  /// Removes a command.
  static void removeCommand(String id) => _commands.removeCommand(id);

  /// Turns a command off without removing it. [showCommand] brings it back.
  static void hideCommand(String id) => _commands.hideCommand(id);

  /// Turns a command back on after [hideCommand].
  static void showCommand(String id) => _commands.showCommand(id);

  /// Whether a command with this `id` exists.
  static bool hasCommand(String id) => _commands.snapshot.hasCommand(id);

  /// Every command that can run right now.
  static List<VoiceCommand> get commands => _commands.snapshot.active;

  /// Whether [model] is downloaded and ready.
  static bool isModelDownloaded(SpeechModel model) =>
      SpeechModelStore.instance.isDownloaded(model);

  /// Downloads [model], which the driver can also do in Settings. Finishes
  /// with whether it worked.
  static Future<bool> downloadModel(SpeechModel model) =>
      SpeechModelStore.instance.download(model);

  /// Deletes [model] from the car.
  static Future<void> deleteModel(SpeechModel model) =>
      SpeechModelStore.instance.delete(model);
}
