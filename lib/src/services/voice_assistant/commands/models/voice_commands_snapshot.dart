import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/models/voice_command.dart';

/// Every voice command registered right now, and which are turned off.
///
/// A new one is handed out each time anything changes. You never create one
/// yourself.
class VoiceCommandsSnapshot {
  /// Every command by its `id`, in the order they were added, the built-in
  /// ones first.
  final Map<String, VoiceCommand> commandsById;

  /// The `id`s of the commands turned off with `hideCommand`.
  final Set<String> hidden;

  const VoiceCommandsSnapshot({
    this.commandsById = const {},
    this.hidden = const {},
  });

  static const VoiceCommandsSnapshot empty = VoiceCommandsSnapshot();

  /// Whether a command with this `id` exists.
  bool hasCommand(String id) => commandsById.containsKey(id);

  /// The commands that can run right now, in the order they were added.
  List<VoiceCommand> get active => [
    for (final command in commandsById.values)
      if (!hidden.contains(command.id)) command,
  ];
}
