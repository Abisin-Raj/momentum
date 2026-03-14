// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sleepSummary)
final sleepSummaryProvider = SleepSummaryProvider._();

final class SleepSummaryProvider
    extends $FunctionalProvider<AsyncValue<dynamic>, dynamic, Stream<dynamic>>
    with $FutureModifier<dynamic>, $StreamProvider<dynamic> {
  SleepSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sleepSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sleepSummaryHash();

  @$internal
  @override
  $StreamProviderElement<dynamic> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<dynamic> create(Ref ref) {
    return sleepSummary(ref);
  }
}

String _$sleepSummaryHash() => r'626fa67a255291d26024d8c0425e462e50227bbc';
