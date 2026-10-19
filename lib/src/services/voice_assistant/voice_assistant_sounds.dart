/// The sounds the voice assistant makes, for when you only want to change
/// some of them:
///
/// ```dart
/// VoiceAssistantExtension(
///   listeningSound: 'assets/sounds/my_beep.wav',
///   heardSound: VoiceAssistantSounds.heard, // unchanged
///   nothingHeardSound: null, // silent
/// )
/// ```
abstract final class VoiceAssistantSounds {
  /// It started listening: two soft notes going up.
  static const listening =
      'packages/smartify_os_voice_assistant/assets/sounds/listening.wav';

  /// It stopped listening and heard something: a bright chord going up.
  static const heard =
      'packages/smartify_os_voice_assistant/assets/sounds/heard.wav';

  /// It stopped listening without hearing anything: two low notes going
  /// down.
  static const nothingHeard =
      'packages/smartify_os_voice_assistant/assets/sounds/nothing_heard.wav';
}
