import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/providers/database_providers.dart';
import 'package:momentum/core/database/app_database.dart';
import 'package:momentum/core/constants/muscle_data.dart';
import 'package:momentum/core/utils/calorie_calculator.dart';

// Note: activityGridProvider is in database_providers.dart

// Muscle Workload (Last 5 days to define "soreness")
final muscleWorkloadProvider = FutureProvider<Map<String, int>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final rawData = await db.getMuscleWorkload(30);
  
  // Normalize keys to match 3D model expectations (e.g. "Front Delts" -> "Front Shoulders")
  final normalized = <String, int>{};
  rawData.forEach((key, value) {
     final normKey = MuscleData.normalize(key);
     normalized[normKey] = (normalized[normKey] ?? 0) + value;
  });
  
  return normalized;
});

// Calculate Volume Load (Current Week)
// Returns [CurrentWeekVolume, LastWeekVolume]
final volumeLoadProvider = FutureProvider<List<double>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  
  // Current Week (Last 7 days)
  final current = await db.getVolumeLoad(7, offsetDays: 0);
  
  // Last Week (7 days before that)
  final last = await db.getVolumeLoad(7, offsetDays: 7);
  
  return [current, last];
});

// Calculate Reps Progression (Current vs Last Week) - For Bodyweight
final repsProgressionProvider = FutureProvider<List<int>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final current = await db.getTotalReps(7, offsetDays: 0);
  final last = await db.getTotalReps(7, offsetDays: 7);
  return [current, last];
});

// Analytics Summary (Last 30 days)
final analyticsSummaryProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return db.getAnalyticsSummary(30);
});

// Workout Progress Insight (Family provider by workout ID)
// Used in Home Screen to show "velocity" or "consistency" for the specific workout
final workoutInsightProvider = FutureProvider.family<Map<String, dynamic>, int>((ref, workoutId) async {
  final db = ref.watch(appDatabaseProvider);
  
  // Check connectivity (simple check)
  final connectivity = await Connectivity().checkConnectivity();
  
  if (connectivity.contains(ConnectivityResult.none)) {
    return {'offline': true};
  }
  
  // Fetch workout progress
  final progressData = await db.getWorkoutProgressSummary(workoutId, days: 30);
  final sessionCount = progressData['sessionCount'] as int;
  
  if (sessionCount == 0) {
    return {'firstSession': true};
  }
  
  return {
    ...progressData,
  };
});
// Daily Nutrition Summary (Today)
final dailyNutritionProvider = StreamProvider<Map<String, double>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final now = DateTime.now();
  
  return db.watchFoodLogsForDate(now).map((logs) {
    double calories = 0;
    double protein = 0;
    double carbs = 0;
    double fats = 0;
    
    for (final log in logs) {
      calories += log.calories;
      protein += log.protein;
      carbs += log.carbs;
      fats += log.fats;
    }
    
    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
    };
  });
});

// Daily Food Logs List
final dailyFoodLogsProvider = StreamProvider<List<FoodLog>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchFoodLogsForDate(DateTime.now());
});

// Net Calories (Food - Workout)
// Combining analytics summary (which gives average daily calories burned over 30 days... 
// WAIT, analytics is 30 days avg. We need TODAY'S burn for Net Calories.)
// Let's rely on a new provider for Today's Burn specifically.
final dailyBurnProvider = FutureProvider<int>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  // Quick estimation from completed sessions today:
  final todaySessions = await db.getSessionsForDate(DateTime.now());
  final completed = todaySessions.where((s) => s.completedAt != null);
  
  // Get user weight once for all calculations
  final user = await db.getUser();
  final userWeight = user?.weightKg ?? 70.0;
  
  int totalCalories = 0;
  for (final s in completed) {
    totalCalories += CalorieCalculator.estimateSessionCalories(
      caloriesBurned: s.caloriesBurned,
      durationSeconds: s.durationSeconds,
      weightKg: userWeight,
      intensity: s.intensity,
    );
  }
  
  return totalCalories;
});


final netCaloriesProvider = FutureProvider<Map<String, int>>((ref) async {
  // Fetch nutrition and burn data in parallel for better performance
  final results = await Future.wait([
    ref.watch(dailyNutritionProvider.future),
    ref.watch(dailyBurnProvider.future),
  ]);
  
  final foodAsync = results[0] as Map<String, double>;
  final burnAsync = results[1] as int;
  
  final eaten = foodAsync['calories']?.toInt() ?? 0;
  final burned = burnAsync;
  
  return {
    'eaten': eaten,
    'burned': burned,
    'net': eaten - burned,
  };
});
