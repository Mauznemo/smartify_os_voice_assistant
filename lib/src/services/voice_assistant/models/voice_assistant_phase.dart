/// What the voice assistant is doing right now.
enum VoiceAssistantPhase {
  /// Nothing. It may still be waiting for the wake word, see
  /// `VoiceAssistantState.wakeWordListening`.
  idle,

  /// Loading what it needs to listen. What you say is already being
  /// recorded, so nothing is lost.
  preparing,

  /// Listening to you.
  listening,

  /// You stopped talking, and it is working out what you said.
  understanding,

  /// Working out what to do about it, on the car or on the AI server.
  thinking,

  /// Saying its answer.
  speaking,

  /// Finished, with the answer still on screen for a moment.
  done,
}
