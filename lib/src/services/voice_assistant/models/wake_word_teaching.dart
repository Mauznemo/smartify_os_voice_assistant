import 'package:freezed_annotation/freezed_annotation.dart';

part 'wake_word_teaching.freezed.dart';

/// A spelling of the wake word the car learned from the driver's voice, and
/// how many of their recordings it heard.
@freezed
abstract class LearnedSpelling with _$LearnedSpelling {
  const factory LearnedSpelling({
    required String spelling,
    required int heard,
  }) = _LearnedSpelling;
}

/// Where teaching the car the wake word has got to.
@freezed
sealed class WakeWordTeaching with _$WakeWordTeaching {
  /// Not teaching.
  const factory WakeWordTeaching.idle() = WakeWordTeachingIdle;

  /// Recording the driver saying it, [recorded] of [wanted] times so far.
  const factory WakeWordTeaching.recording({
    required int recorded,
    required int wanted,

    /// What it heard last, so the driver sees it is listening.
    String? lastHeard,

    /// Whether the last thing heard did not sound like the wake word and
    /// was left out.
    @Default(false) bool lastLeftOut,
  }) = WakeWordTeachingRecording;

  /// Trying spellings against the recordings, [tried] of [total].
  const factory WakeWordTeaching.working({
    required int tried,
    required int total,
  }) = WakeWordTeachingWorking;

  /// Finished: of [recordings], [before] were heard with what it knew
  /// before, and [after] are now.
  const factory WakeWordTeaching.done({
    required int recordings,
    required int before,
    required int after,
    required List<LearnedSpelling> learned,
  }) = WakeWordTeachingDone;

  /// It could not be taught, for [reason] (already in the car's language).
  const factory WakeWordTeaching.failed(String reason) = WakeWordTeachingFailed;
}
