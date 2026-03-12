import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamic_color/dynamic_color.dart';
import '../core/services/settings_service.dart';
import '../core/services/widget_service.dart';

import 'theme/app_theme.dart';
import 'router.dart';

/// Design: Ocean Blue logo centered with "Momentum" text below
class MomentumApp extends ConsumerStatefulWidget {
  const MomentumApp({super.key});

  @override
  ConsumerState<MomentumApp> createState() => _MomentumAppState();
}

class _MomentumAppState extends ConsumerState<MomentumApp> {
  late final ProviderSubscription<AsyncValue<void>> _widgetSyncSubscription;

  @override
  void initState() {
    super.initState();
    _widgetSyncSubscription = ref.listenManual(widgetSyncProvider, (_, __) {});
  }

  @override
  void dispose() {
    _widgetSyncSubscription.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeModeAsync = ref.watch(appThemeModeProvider);
    final themeKey = themeModeAsync.valueOrNull ?? 'black';

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final theme = AppTheme.getTheme(themeKey);

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value:
              theme.appBarTheme.systemOverlayStyle ??
              SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: Colors.transparent,
                systemNavigationBarDividerColor: Colors.transparent,
                systemNavigationBarContrastEnforced: false,
              ),
          child: MaterialApp.router(
            title: 'Momentum',
            debugShowCheckedModeBanner: false,

            // Theme configuration
            theme: theme,
            darkTheme: theme,
            themeMode: ThemeMode.dark,

            // Router configuration
            routerConfig: router,
          ),
        );
      },
    );
  }
}
