import 'dart:async';

import 'package:smartify_os_voice_assistant/src/services/voice_assistant/commands/models/voice_command_run.dart';

/// Something the driver can ask the car to do by voice.
///
/// Say what it does, how the driver might say it, and what to run:
///
/// ```dart
/// VoiceCommand(
///   id: 'windows_up',
///   title: 'Close the windows',
///   phrases: ['close the windows', 'windows up', 'fenster zu'],
///   onRun: (run) {
///     myCar.windows(up: true);
///     return "I'm closing the windows.";
///   },
/// )
/// ```
///
/// Answer the way a person would ("I've closed the windows"), since it is
/// read out loud. Writing out every way of saying it gets long, so you can list words
/// instead: the command matches when what was said has a word from each
/// list, in any order. This one hears "close the windows", "windows up",
/// "could you raise the window please" and many more:
///
/// ```dart
/// VoiceCommand(
///   id: 'windows_up',
///   title: 'Close the windows',
///   words: [
///     ['window', 'windows'],
///     ['up', 'raise', 'close', 'shut'],
///   ],
///   onRun: (run) => myCar.windows(up: true),
/// )
/// ```
///
/// A phrase can leave a gap for a value with `{name}`, which the command
/// reads back with `run.value('name')` or `run.number('name')`:
///
/// ```dart
/// VoiceCommand(
///   id: 'temperature',
///   title: 'Set the temperature',
///   phrases: ['set the temperature to {degrees}', 'make it {degrees} degrees'],
///   onRun: (run) {
///     final degrees = run.number('degrees');
///     if (degrees == null) return 'To how many degrees?';
///     myCar.setTemperature(degrees);
///     return "I've set it to ${degrees.round()} degrees.";
///   },
/// )
/// ```
///
/// Phrases and words can be in any language, and in several at once. Yours
/// always win over the built-in ones, which only run when none of yours
/// matched. Among yours, the one that matched the most words wins.
///
/// With an AI server set up, every command is also handed to it as a tool,
/// described by [title] (and [description] when there is one), so it can run
/// commands for sentences you never thought of.
class VoiceCommand {
  /// A short name for this command, unique among all commands, for example
  /// `'windows_up'`. Also the name the AI server knows it by, so only use
  /// letters, digits and `_`.
  final String id;

  /// What it does, in a few words, as the driver would put it: `'Close the
  /// windows'`. Shown in Settings under what you can say.
  final String title;

  /// More about what it does or when to use it, only for the AI server.
  final String? description;

  /// Whole sentences that run it, with `{name}` where a value goes. Words
  /// said before or after a phrase do not stop it from matching.
  final List<String> phrases;

  /// Lists of words, of which what was said has to contain one each, in any
  /// order. An entry can also be several words, `'turn up'`.
  final List<List<String>> words;

  /// What each `{name}` in [phrases] is, for the AI server:
  /// `{'degrees': 'The temperature in degrees'}`. A name used in a phrase
  /// but left out here is still handed over, just without an explanation.
  final Map<String, String> values;

  /// Runs the command. Return what the assistant should answer, as a
  /// person would say it ("I've closed the windows"), or `null` for it to
  /// only show that it is done.
  final FutureOr<String?> Function(VoiceCommandRun run) onRun;

  const VoiceCommand({
    required this.id,
    required this.title,
    required this.onRun,
    this.description,
    this.phrases = const [],
    this.words = const [],
    this.values = const {},
  });

  /// Every `{name}` used in [phrases] or [values].
  Set<String> get valueNames => {
    ...values.keys,
    for (final phrase in phrases)
      for (final match in _slot.allMatches(phrase)) match.group(1)!,
  };

  static final _slot = RegExp(r'\{(\w+)\}');
}
