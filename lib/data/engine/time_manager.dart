// lib/engine/time.dart
class TimeManager {
  Duration allocate({
    required Duration remaining,
    required int movesToGo, // تقدير، مثلاً 30
    Duration increment = Duration.zero,
    Duration min = const Duration(milliseconds: 50),
    Duration max = const Duration(seconds: 5),
  }) {
    final base = remaining ~/ (movesToGo + 1);
    final budget = base + (increment ~/ 2);
    final clamped = budget < min ? min : (budget > max ? max : budget);
    return clamped;
  }
}
