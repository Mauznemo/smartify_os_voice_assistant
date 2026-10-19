/// How easily the wake word starts the assistant.
enum WakeWordSensitivity {
  /// Starts less often by mistake, but has to be said clearly.
  low,

  /// What suits most cars.
  normal,

  /// Hears it from further away, and starts by mistake more often.
  high;

  /// Internal: how sure the wake word model has to be, lower is easier.
  double get threshold => switch (this) {
    low => 0.15,
    normal => 0.1,
    high => 0.05,
  };

  /// Internal: how much the wake word is preferred over anything else that
  /// sounds like it, higher is easier.
  double get boost => switch (this) {
    low => 2.0,
    normal => 2.5,
    high => 3.0,
  };
}
