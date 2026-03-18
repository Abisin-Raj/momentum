// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeWorkoutSessionHash() =>
    r'eaf79e9a7a7464874337785ae50f85ef215868c8';

/// Notifier for managing active workout session
///
/// Copied from [ActiveWorkoutSession].
@ProviderFor(ActiveWorkoutSession)
final activeWorkoutSessionProvider =
    NotifierProvider<ActiveWorkoutSession, ActiveSession?>.internal(
      ActiveWorkoutSession.new,
      name: r'activeWorkoutSessionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeWorkoutSessionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveWorkoutSession = Notifier<ActiveSession?>;
String _$workoutManagerHash() => r'7fe4f8bcc763b16254a42acbb2224efae32d6f4a';

/// Provider for adding a new workout
///
/// Copied from [WorkoutManager].
@ProviderFor(WorkoutManager)
final workoutManagerProvider =
    AutoDisposeAsyncNotifierProvider<WorkoutManager, void>.internal(
      WorkoutManager.new,
      name: r'workoutManagerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$workoutManagerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WorkoutManager = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
