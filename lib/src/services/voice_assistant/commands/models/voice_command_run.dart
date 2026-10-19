import 'package:flutter/widgets.dart';
import 'package:smartify_os_core/core.dart';

/// What a [VoiceCommand] is handed when it runs: what was said, and the
/// values filled into its `{name}` gaps.
class VoiceCommandRun {
  /// The whole sentence as it was heard.
  final String text;

  /// The values for the command's `{name}` gaps, as they were said.
  final Map<String, String> values;

  /// Whether the AI server picked this command, rather than one of its
  /// phrases matching.
  final bool fromAiServer;

  const VoiceCommandRun({
    required this.text,
    this.values = const {},
    this.fromAiServer = false,
  });

  /// The value said for `{name}`, or `null` when there was none.
  String? value(String name) {
    final value = values[name]?.trim();
    return value == null || value.isEmpty ? null : value;
  }

  /// The first number in the value said for `{name}`, so "21 degrees" reads
  /// as 21. `null` when there is no number in it.
  double? number(String name) {
    final value = this.value(name);
    if (value == null) return null;
    final match = _number.firstMatch(value);
    if (match == null) return null;
    return double.tryParse(match.group(0)!.replaceAll(',', '.'));
  }

  /// Somewhere to open a window from:
  /// `SmartifyOsNavigator.push(run.context!, const MyWindow())`.
  BuildContext? get context => SmartifyOsNavigator.navigatorKey.currentContext;

  static final _number = RegExp(r'-?\d+(?:[.,]\d+)?');
}
