class VolumeCalculator {
  /// Calculates exercise volume.
  /// If [weightKg] is null, it assumes a bodyweight exercise and uses [bodyWeightKg].
  static double calculateVolume({
    required double? weightKg,
    required int reps,
    required double bodyWeightKg,
  }) {
    final effectiveWeight = weightKg ?? bodyWeightKg;
    return effectiveWeight * reps;
  }
}
