import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartify_os_voice_assistant/src/services/voice_assistant/models/voice_assistant_phase.dart';

part 'voice_assistant_state.freezed.dart';

/// Everything the voice assistant shows: what it is doing, what it heard and
/// what it answered.
///
/// Watch it with `ref.watch(voiceAssistantStateProvider)`, or read
/// `SmartifyOsVoiceAssistant.state`.
@freezed
abstract class VoiceAssistantState with _$VoiceAssistantState {
  const VoiceAssistantState._();

  const factory VoiceAssistantState({
    @Default(VoiceAssistantPhase.idle) VoiceAssistantPhase phase,

    /// What it heard you say so far. Grows while you talk, and is final from
    /// [VoiceAssistantPhase.thinking] on.
    @Default('') String heard,

    /// What it answered, once it has.
    String? reply,

    /// Whether the answer is coming from the AI server rather than the car.
    @Default(false) bool askingServer,

    /// Whether it ended because something went wrong, rather than with an
    /// answer.
    @Default(false) bool failed,

    /// Whether it is waiting for the wake word right now.
    @Default(false) bool wakeWordListening,
  }) = _VoiceAssistantState;

  /// Whether a conversation is going on, so the panel is on screen.
  bool get isActive => phase != VoiceAssistantPhase.idle;
}
