// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsService)
final settingsServiceProvider = SettingsServiceProvider._();

final class SettingsServiceProvider
    extends
        $FunctionalProvider<SettingsService, SettingsService, SettingsService>
    with $Provider<SettingsService> {
  SettingsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsServiceHash();

  @$internal
  @override
  $ProviderElement<SettingsService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SettingsService create(Ref ref) {
    return settingsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsService>(value),
    );
  }
}

String _$settingsServiceHash() => r'626173756d1be84bec56f4e54c791f6675823426';

@ProviderFor(pexelsApiKey)
final pexelsApiKeyProvider = PexelsApiKeyProvider._();

final class PexelsApiKeyProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  PexelsApiKeyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pexelsApiKeyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pexelsApiKeyHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return pexelsApiKey(ref);
  }
}

String _$pexelsApiKeyHash() => r'b57e11d4217d94167e980594a45f44470431a18a';

@ProviderFor(unsplashApiKey)
final unsplashApiKeyProvider = UnsplashApiKeyProvider._();

final class UnsplashApiKeyProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  UnsplashApiKeyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unsplashApiKeyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unsplashApiKeyHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return unsplashApiKey(ref);
  }
}

String _$unsplashApiKeyHash() => r'eaf67d363232edd68972e4779ae1b1c417efe50e';

@ProviderFor(geminiApiKey)
final geminiApiKeyProvider = GeminiApiKeyProvider._();

final class GeminiApiKeyProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  GeminiApiKeyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geminiApiKeyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geminiApiKeyHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return geminiApiKey(ref);
  }
}

String _$geminiApiKeyHash() => r'8a984ce5e87b011a33d4d4769b88a594397ed8ef';

@ProviderFor(gemini2ApiKey)
final gemini2ApiKeyProvider = Gemini2ApiKeyProvider._();

final class Gemini2ApiKeyProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  Gemini2ApiKeyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gemini2ApiKeyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gemini2ApiKeyHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return gemini2ApiKey(ref);
  }
}

String _$gemini2ApiKeyHash() => r'311e7dd1a04b1386f845aee830a48350e8e55bee';

@ProviderFor(groqApiKey)
final groqApiKeyProvider = GroqApiKeyProvider._();

final class GroqApiKeyProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  GroqApiKeyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groqApiKeyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groqApiKeyHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return groqApiKey(ref);
  }
}

String _$groqApiKeyHash() => r'59139d17e0562c4a164c05fa0a7ff09ae0b8d7cd';

@ProviderFor(GeminiModel)
final geminiModelProvider = GeminiModelProvider._();

final class GeminiModelProvider
    extends $AsyncNotifierProvider<GeminiModel, String> {
  GeminiModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geminiModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geminiModelHash();

  @$internal
  @override
  GeminiModel create() => GeminiModel();
}

String _$geminiModelHash() => r'9d366f200222c96422c8e25549b7dd9e7e5a8beb';

abstract class _$GeminiModel extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(restTimer)
final restTimerProvider = RestTimerProvider._();

final class RestTimerProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  RestTimerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'restTimerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$restTimerHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return restTimer(ref);
  }
}

String _$restTimerHash() => r'79a520d0b7f9e619498a5447e78e56df345832b8';

@ProviderFor(weightUnit)
final weightUnitProvider = WeightUnitProvider._();

final class WeightUnitProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  WeightUnitProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weightUnitProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weightUnitHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return weightUnit(ref);
  }
}

String _$weightUnitHash() => r'8a4bf16514276e46f84fc01e5250b45d27afa067';

@ProviderFor(WidgetTheme)
final widgetThemeProvider = WidgetThemeProvider._();

final class WidgetThemeProvider
    extends $AsyncNotifierProvider<WidgetTheme, String> {
  WidgetThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'widgetThemeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$widgetThemeHash();

  @$internal
  @override
  WidgetTheme create() => WidgetTheme();
}

String _$widgetThemeHash() => r'82afa081250e3cc8357644552eca71184fe4da87';

abstract class _$WidgetTheme extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(AppThemeMode)
final appThemeModeProvider = AppThemeModeProvider._();

final class AppThemeModeProvider
    extends $AsyncNotifierProvider<AppThemeMode, String> {
  AppThemeModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemeModeHash();

  @$internal
  @override
  AppThemeMode create() => AppThemeMode();
}

String _$appThemeModeHash() => r'059fa2dcf55063b94c315a540cc149e4c98fe4ed';

abstract class _$AppThemeMode extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ModelRotationMode)
final modelRotationModeProvider = ModelRotationModeProvider._();

final class ModelRotationModeProvider
    extends $AsyncNotifierProvider<ModelRotationMode, String> {
  ModelRotationModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'modelRotationModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$modelRotationModeHash();

  @$internal
  @override
  ModelRotationMode create() => ModelRotationMode();
}

String _$modelRotationModeHash() => r'deeb63acafc5c0d396771c90ecb3ccc203e2a76b';

abstract class _$ModelRotationMode extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(TimeFormat)
final timeFormatProvider = TimeFormatProvider._();

final class TimeFormatProvider
    extends $AsyncNotifierProvider<TimeFormat, String> {
  TimeFormatProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'timeFormatProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$timeFormatHash();

  @$internal
  @override
  TimeFormat create() => TimeFormat();
}

String _$timeFormatHash() => r'a2681a02b89a4f5e416c4e91516de6ba4008cea1';

abstract class _$TimeFormat extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(BoxingGameEnabled)
final boxingGameEnabledProvider = BoxingGameEnabledProvider._();

final class BoxingGameEnabledProvider
    extends $AsyncNotifierProvider<BoxingGameEnabled, bool> {
  BoxingGameEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'boxingGameEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$boxingGameEnabledHash();

  @$internal
  @override
  BoxingGameEnabled create() => BoxingGameEnabled();
}

String _$boxingGameEnabledHash() => r'62d80eab0fd732a383a92fec0fbee4416ea0a547';

abstract class _$BoxingGameEnabled extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
