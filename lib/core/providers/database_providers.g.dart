// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Single database instance for the entire app

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// Single database instance for the entire app

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// Single database instance for the entire app
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'448adad5717e7b1c0b3ca3ca7e03d0b2116237af';

/// Provider for checking if setup is complete (from database)

@ProviderFor(isSetupComplete)
final isSetupCompleteProvider = IsSetupCompleteProvider._();

/// Provider for checking if setup is complete (from database)

final class IsSetupCompleteProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Provider for checking if setup is complete (from database)
  IsSetupCompleteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isSetupCompleteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isSetupCompleteHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isSetupComplete(ref);
  }
}

String _$isSetupCompleteHash() => r'193889f2209c4a353b314b42535079977e9b31c9';

/// Provider for the current user

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

/// Provider for the current user

final class CurrentUserProvider
    extends $FunctionalProvider<AsyncValue<dynamic>, dynamic, FutureOr<dynamic>>
    with $FutureModifier<dynamic>, $FutureProvider<dynamic> {
  /// Provider for the current user
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $FutureProviderElement<dynamic> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<dynamic> create(Ref ref) {
    return currentUser(ref);
  }
}

String _$currentUserHash() => r'1a191177f2ac7c3d4b8b10312426b849d64ad8ce';

/// Provider for watching the current user

@ProviderFor(userStream)
final userStreamProvider = UserStreamProvider._();

/// Provider for watching the current user

final class UserStreamProvider
    extends $FunctionalProvider<AsyncValue<dynamic>, dynamic, Stream<dynamic>>
    with $FutureModifier<dynamic>, $StreamProvider<dynamic> {
  /// Provider for watching the current user
  UserStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userStreamHash();

  @$internal
  @override
  $StreamProviderElement<dynamic> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<dynamic> create(Ref ref) {
    return userStream(ref);
  }
}

String _$userStreamHash() => r'423f4fc516c5dbee9c27c14e87910bc044b8cbb5';

/// Provider for all workouts (reactive stream)

@ProviderFor(workoutsStream)
final workoutsStreamProvider = WorkoutsStreamProvider._();

/// Provider for all workouts (reactive stream)

final class WorkoutsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<dynamic>>,
          List<dynamic>,
          Stream<List<dynamic>>
        >
    with $FutureModifier<List<dynamic>>, $StreamProvider<List<dynamic>> {
  /// Provider for all workouts (reactive stream)
  WorkoutsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<dynamic>> create(Ref ref) {
    return workoutsStream(ref);
  }
}

String _$workoutsStreamHash() => r'f8e2318ac10402add59834d2d75c8a966c8a42f9';

/// Provider for today's completed workout IDs

@ProviderFor(todayCompletedWorkoutIds)
final todayCompletedWorkoutIdsProvider = TodayCompletedWorkoutIdsProvider._();

/// Provider for today's completed workout IDs

final class TodayCompletedWorkoutIdsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<int>>,
          List<int>,
          FutureOr<List<int>>
        >
    with $FutureModifier<List<int>>, $FutureProvider<List<int>> {
  /// Provider for today's completed workout IDs
  TodayCompletedWorkoutIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayCompletedWorkoutIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayCompletedWorkoutIdsHash();

  @$internal
  @override
  $FutureProviderElement<List<int>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<int>> create(Ref ref) {
    return todayCompletedWorkoutIds(ref);
  }
}

String _$todayCompletedWorkoutIdsHash() =>
    r'709e98fe2defe6b0ffa9551fb24728bfd26833fc';

/// Provider for activity grid data (last N days)

@ProviderFor(activityGrid)
final activityGridProvider = ActivityGridFamily._();

/// Provider for activity grid data (last N days)

final class ActivityGridProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<DateTime, String>>,
          Map<DateTime, String>,
          Stream<Map<DateTime, String>>
        >
    with
        $FutureModifier<Map<DateTime, String>>,
        $StreamProvider<Map<DateTime, String>> {
  /// Provider for activity grid data (last N days)
  ActivityGridProvider._({
    required ActivityGridFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'activityGridProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activityGridHash();

  @override
  String toString() {
    return r'activityGridProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Map<DateTime, String>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<DateTime, String>> create(Ref ref) {
    final argument = this.argument as int;
    return activityGrid(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityGridProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activityGridHash() => r'3d18482915f88257e3a503f7d3b614e988b930e8';

/// Provider for activity grid data (last N days)

final class ActivityGridFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Map<DateTime, String>>, int> {
  ActivityGridFamily._()
    : super(
        retry: null,
        name: r'activityGridProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for activity grid data (last N days)

  ActivityGridProvider call(int days) =>
      ActivityGridProvider._(argument: days, from: this);

  @override
  String toString() => r'activityGridProvider';
}

/// Provider for exercises in a workout

@ProviderFor(exercisesForWorkout)
final exercisesForWorkoutProvider = ExercisesForWorkoutFamily._();

/// Provider for exercises in a workout

final class ExercisesForWorkoutProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<dynamic>>,
          List<dynamic>,
          FutureOr<List<dynamic>>
        >
    with $FutureModifier<List<dynamic>>, $FutureProvider<List<dynamic>> {
  /// Provider for exercises in a workout
  ExercisesForWorkoutProvider._({
    required ExercisesForWorkoutFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'exercisesForWorkoutProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$exercisesForWorkoutHash();

  @override
  String toString() {
    return r'exercisesForWorkoutProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<dynamic>> create(Ref ref) {
    final argument = this.argument as int;
    return exercisesForWorkout(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExercisesForWorkoutProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exercisesForWorkoutHash() =>
    r'42cebabca7919da5c9588bc4feabad9e7d0c8a01';

/// Provider for exercises in a workout

final class ExercisesForWorkoutFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<dynamic>>, int> {
  ExercisesForWorkoutFamily._()
    : super(
        retry: null,
        name: r'exercisesForWorkoutProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for exercises in a workout

  ExercisesForWorkoutProvider call(int workoutId) =>
      ExercisesForWorkoutProvider._(argument: workoutId, from: this);

  @override
  String toString() => r'exercisesForWorkoutProvider';
}

/// Provider for weekly stats

@ProviderFor(weeklyStats)
final weeklyStatsProvider = WeeklyStatsProvider._();

/// Provider for weekly stats

final class WeeklyStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, int>>,
          Map<String, int>,
          FutureOr<Map<String, int>>
        >
    with $FutureModifier<Map<String, int>>, $FutureProvider<Map<String, int>> {
  /// Provider for weekly stats
  WeeklyStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyStatsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, int>> create(Ref ref) {
    return weeklyStats(ref);
  }
}

String _$weeklyStatsHash() => r'fdb9ab9a48842fd4a085fe6696163946a0647d96';

/// Provider for weekly insight text

@ProviderFor(weeklyInsight)
final weeklyInsightProvider = WeeklyInsightProvider._();

/// Provider for weekly insight text

final class WeeklyInsightProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// Provider for weekly insight text
  WeeklyInsightProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weeklyInsightProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weeklyInsightHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return weeklyInsight(ref);
  }
}

String _$weeklyInsightHash() => r'836830b14c7bc702fe9fb7a599dab3ee343df060';

/// Provider for session history with workout details

@ProviderFor(sessionHistory)
final sessionHistoryProvider = SessionHistoryFamily._();

/// Provider for session history with workout details

final class SessionHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  /// Provider for session history with workout details
  SessionHistoryProvider._({
    required SessionHistoryFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'sessionHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sessionHistoryHash();

  @override
  String toString() {
    return r'sessionHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    final argument = this.argument as int;
    return sessionHistory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sessionHistoryHash() => r'f4afdec4153d336270ce91f5b48ad9b384bfaf7c';

/// Provider for session history with workout details

final class SessionHistoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Map<String, dynamic>>>, int> {
  SessionHistoryFamily._()
    : super(
        retry: null,
        name: r'sessionHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for session history with workout details

  SessionHistoryProvider call(int limit) =>
      SessionHistoryProvider._(argument: limit, from: this);

  @override
  String toString() => r'sessionHistoryProvider';
}

/// Provider for exercise details of a specific session

@ProviderFor(sessionExerciseDetails)
final sessionExerciseDetailsProvider = SessionExerciseDetailsFamily._();

/// Provider for exercise details of a specific session

final class SessionExerciseDetailsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  /// Provider for exercise details of a specific session
  SessionExerciseDetailsProvider._({
    required SessionExerciseDetailsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'sessionExerciseDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sessionExerciseDetailsHash();

  @override
  String toString() {
    return r'sessionExerciseDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    final argument = this.argument as int;
    return sessionExerciseDetails(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionExerciseDetailsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sessionExerciseDetailsHash() =>
    r'083f69c34c7dc7ba2c0b309547a97edaf266bd7c';

/// Provider for exercise details of a specific session

final class SessionExerciseDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Map<String, dynamic>>>, int> {
  SessionExerciseDetailsFamily._()
    : super(
        retry: null,
        name: r'sessionExerciseDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for exercise details of a specific session

  SessionExerciseDetailsProvider call(int sessionId) =>
      SessionExerciseDetailsProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'sessionExerciseDetailsProvider';
}

/// Provider for sleep logs (last 30 days)

@ProviderFor(sleepLogs)
final sleepLogsProvider = SleepLogsFamily._();

/// Provider for sleep logs (last 30 days)

final class SleepLogsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<dynamic>>,
          List<dynamic>,
          Stream<List<dynamic>>
        >
    with $FutureModifier<List<dynamic>>, $StreamProvider<List<dynamic>> {
  /// Provider for sleep logs (last 30 days)
  SleepLogsProvider._({
    required SleepLogsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'sleepLogsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sleepLogsHash();

  @override
  String toString() {
    return r'sleepLogsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<dynamic>> create(Ref ref) {
    final argument = this.argument as int;
    return sleepLogs(ref, days: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SleepLogsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sleepLogsHash() => r'8d6b725d470cfb1774116eabe1c2fb79aaf95e9c';

/// Provider for sleep logs (last 30 days)

final class SleepLogsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<dynamic>>, int> {
  SleepLogsFamily._()
    : super(
        retry: null,
        name: r'sleepLogsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for sleep logs (last 30 days)

  SleepLogsProvider call({int days = 30}) =>
      SleepLogsProvider._(argument: days, from: this);

  @override
  String toString() => r'sleepLogsProvider';
}
