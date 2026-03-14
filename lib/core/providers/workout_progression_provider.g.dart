// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_progression_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workoutProgression)
final workoutProgressionProvider = WorkoutProgressionProvider._();

final class WorkoutProgressionProvider
    extends
        $FunctionalProvider<
          AsyncValue<WorkoutProgression>,
          WorkoutProgression,
          FutureOr<WorkoutProgression>
        >
    with
        $FutureModifier<WorkoutProgression>,
        $FutureProvider<WorkoutProgression> {
  WorkoutProgressionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workoutProgressionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workoutProgressionHash();

  @$internal
  @override
  $FutureProviderElement<WorkoutProgression> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WorkoutProgression> create(Ref ref) {
    return workoutProgression(ref);
  }
}

String _$workoutProgressionHash() =>
    r'3f3efdaa27f0d005b9a1ca5f21b5fff910523a23';
