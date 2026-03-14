// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier for managing active workout session

@ProviderFor(ActiveWorkoutSession)
final activeWorkoutSessionProvider = ActiveWorkoutSessionProvider._();

/// Notifier for managing active workout session
final class ActiveWorkoutSessionProvider
    extends $NotifierProvider<ActiveWorkoutSession, ActiveSession?> {
  /// Notifier for managing active workout session
  ActiveWorkoutSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeWorkoutSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeWorkoutSessionHash();

  @$internal
  @override
  ActiveWorkoutSession create() => ActiveWorkoutSession();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActiveSession? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActiveSession?>(value),
    );
  }
}

String _$activeWorkoutSessionHash() =>
    r'dad419e83503dc59f7e80ea08c5ce8b055c97b25';

/// Notifier for managing active workout session

abstract class _$ActiveWorkoutSession extends $Notifier<ActiveSession?> {
  ActiveSession? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ActiveSession?, ActiveSession?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ActiveSession?, ActiveSession?>,
              ActiveSession?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider for adding a new workout

@ProviderFor(WorkoutManager)
final workoutManagerProvider = WorkoutManagerProvider._();

/// Provider for adding a new workout
final class WorkoutManagerProvider
    extends $AsyncNotifierProvider<WorkoutManager, void> {
  /// Provider for adding a new workout
  WorkoutManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutManagerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutManagerHash();

  @$internal
  @override
  WorkoutManager create() => WorkoutManager();
}

String _$workoutManagerHash() => r'7fe4f8bcc763b16254a42acbb2224efae32d6f4a';

/// Provider for adding a new workout

abstract class _$WorkoutManager extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider for the next scheduled workout

@ProviderFor(nextWorkout)
final nextWorkoutProvider = NextWorkoutProvider._();

/// Provider for the next scheduled workout

final class NextWorkoutProvider
    extends $FunctionalProvider<AsyncValue<dynamic>, dynamic, FutureOr<dynamic>>
    with $FutureModifier<dynamic>, $FutureProvider<dynamic> {
  /// Provider for the next scheduled workout
  NextWorkoutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nextWorkoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nextWorkoutHash();

  @$internal
  @override
  $FutureProviderElement<dynamic> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<dynamic> create(Ref ref) {
    return nextWorkout(ref);
  }
}

String _$nextWorkoutHash() => r'cf885839af8fbbc68048aa9ee93282b2f3904cb2';

/// Provider for the workout scheduled after the next one

@ProviderFor(tomorrowWorkout)
final tomorrowWorkoutProvider = TomorrowWorkoutProvider._();

/// Provider for the workout scheduled after the next one

final class TomorrowWorkoutProvider
    extends $FunctionalProvider<AsyncValue<dynamic>, dynamic, FutureOr<dynamic>>
    with $FutureModifier<dynamic>, $FutureProvider<dynamic> {
  /// Provider for the workout scheduled after the next one
  TomorrowWorkoutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tomorrowWorkoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tomorrowWorkoutHash();

  @$internal
  @override
  $FutureProviderElement<dynamic> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<dynamic> create(Ref ref) {
    return tomorrowWorkout(ref);
  }
}

String _$tomorrowWorkoutHash() => r'bee352267f19c798a26fcbd6b350835ee1b3e092';
