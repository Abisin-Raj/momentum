// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(testProvider)
final testProviderProvider = TestProviderProvider._();

final class TestProviderProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  TestProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'testProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$testProviderHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return testProvider(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$testProviderHash() => r'e3dd51e18bc1a1a787fa15be053976f6f5c3a2b4';
