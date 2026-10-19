import 'package:freezed_annotation/freezed_annotation.dart';

part 'speech_model_status.freezed.dart';

/// Whether a speech model is on the car, or on its way.
@freezed
abstract class SpeechModelStatus with _$SpeechModelStatus {
  const SpeechModelStatus._();

  const factory SpeechModelStatus({
    /// Whether it is on the car, complete, ready to be used.
    @Default(false) bool downloaded,

    /// How far along its download is, from 0 to 1, while it downloads.
    double? progress,

    /// Whether the last try to download it failed.
    @Default(false) bool failed,
  }) = _SpeechModelStatus;

  /// Whether it is downloading right now.
  bool get downloading => progress != null;
}
