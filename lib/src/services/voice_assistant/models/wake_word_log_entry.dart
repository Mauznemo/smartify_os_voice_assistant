import 'package:freezed_annotation/freezed_annotation.dart';

part 'wake_word_log_entry.freezed.dart';

/// One line of what the voice assistant heard while waiting for the wake
/// word, for finding out why it does or does not start.
@freezed
abstract class WakeWordLogEntry with _$WakeWordLogEntry {
  const factory WakeWordLogEntry({
    required DateTime time,

    /// Whether this was the wake word, rather than only something said.
    required bool wakeWord,

    /// The way of saying the wake word that was heard, or what was said.
    required String text,
  }) = _WakeWordLogEntry;
}
