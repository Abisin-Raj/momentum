class SleepUtils {
  /// Calculates a recovery score based on sleep duration.
  /// Standard: 8 hours (480 minutes) is 100%.
  static int calculateRecoveryScore(int durationMinutes) {
    if (durationMinutes <= 0) return 0;
    
    // Base score calculation: 8 hours = 100%
    int score = ((durationMinutes / 480) * 100).round();
    
    // Penalize heavily if under 6 hours
    if (durationMinutes < 360) {
      score = (score * 0.8).round();
    }
    
    return score.clamp(0, 100);
  }

  /// Formats duration in minutes to a human-readable string (e.g. "7.5h").
  static String formatHours(int minutes) {
    return (minutes / 60.0).toStringAsFixed(1);
  }
}
