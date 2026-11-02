/// Current wall-clock time. Injected so time-based logic stays testable.
typedef Now = DateTime Function();

/// A stream that emits once per tick. Injected so countdowns stay testable.
typedef Ticker = Stream<void> Function();

Stream<void> everySecond() => Stream<void>.periodic(const Duration(seconds: 1));
