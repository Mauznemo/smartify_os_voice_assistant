import 'package:smartify_os_core/utils.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/models/voice_command.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/models/voice_commands_snapshot.dart';

/// Keeps track of every voice command, and which of them are turned off.
///
/// Internal: use the `SmartifyOsVoiceAssistant` facade instead. Nothing here
/// throws, bad input is logged and worked around. [hideCommand] and
/// [showCommand] also work on a name nothing is registered under yet, so the
/// order things start up in never matters.
class VoiceCommandsRegistry {
  static const _tag = 'VoiceAssistant';

  static final VoiceCommandsRegistry instance = VoiceCommandsRegistry._();
  VoiceCommandsRegistry._();

  static final _validId = RegExp(r'^[A-Za-z0-9_]+$');

  final Map<String, VoiceCommand> _commands = {};
  final Set<String> _hidden = {};

  final ValueStream<VoiceCommandsSnapshot> _snapshot = ValueStream(
    VoiceCommandsSnapshot.empty,
  );

  /// Everything registered right now.
  VoiceCommandsSnapshot get snapshot => _snapshot.value;

  /// Emits a new snapshot every time anything changes.
  Stream<VoiceCommandsSnapshot> get changes => _snapshot.stream;

  /// Adds a command. One with the same `id` is replaced, where it was.
  void addCommand(VoiceCommand command) {
    if (!_validId.hasMatch(command.id)) {
      SmartifyOsLog.warning(
        _tag,
        'Command "${command.id}" was not added: an id may only have letters, '
        'digits and _',
      );
      return;
    }
    if (command.phrases.isEmpty && command.words.isEmpty) {
      SmartifyOsLog.warning(
        _tag,
        'Command "${command.id}" has no phrases or words, so only the AI '
        'server can run it',
      );
    }
    if (_commands.containsKey(command.id)) {
      SmartifyOsLog.info(_tag, 'Command "${command.id}" was replaced');
    }
    _commands[command.id] = command;
    _publish();
  }

  void addCommands(Iterable<VoiceCommand> commands) {
    for (final command in commands) {
      addCommand(command);
    }
  }

  /// Removes a command completely.
  void removeCommand(String id) {
    if (_commands.remove(id) == null) {
      SmartifyOsLog.warning(_tag, 'Cannot remove unknown command "$id"');
      return;
    }
    _hidden.remove(id);
    _publish();
  }

  /// Turns a command off without removing it, so [showCommand] can bring it
  /// back.
  void hideCommand(String id) {
    _warnIfUnknown(id);
    if (!_hidden.add(id)) return;
    _publish();
  }

  /// Turns a command back on.
  void showCommand(String id) {
    _warnIfUnknown(id);
    if (!_hidden.remove(id)) return;
    _publish();
  }

  /// Throws everything away. Only useful in tests.
  void reset() {
    _commands.clear();
    _hidden.clear();
    _publish();
  }

  void _warnIfUnknown(String id) {
    if (_commands.containsKey(id)) return;
    SmartifyOsLog.warning(_tag, 'No command is registered as "$id" yet');
  }

  /// Hands out a read-only copy of the state above. `forceSet` rather than
  /// `value`, since a snapshot is a new object every time.
  void _publish() {
    _snapshot.forceSet(
      VoiceCommandsSnapshot(
        commandsById: Map.unmodifiable(_commands),
        hidden: Set.unmodifiable(_hidden),
      ),
    );
  }
}
