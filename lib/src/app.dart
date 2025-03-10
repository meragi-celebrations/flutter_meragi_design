import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/theme.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MDApp extends StatelessWidget {
  final String? title;
  final TransitionBuilder? builder;
  final ThemeMode? themeMode;
  final Locale? locale;
  final Iterable<Locale>? supportedLocales;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final bool showPerformanceOverlay;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;
  final Map<LogicalKeySet, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;
  final String? restorationScopeId;
  final MDTheme theme;
  final RouterConfig<Object> routerConfig;

  const MDApp({
    super.key,
    this.title,
    this.builder,
    this.themeMode,
    this.locale,
    this.supportedLocales,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.localizationsDelegates,
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    required this.theme,
    required this.routerConfig,
  });

  @override
  Widget build(BuildContext context) {
    return ShadApp.materialRouter(
      title: title ?? '',
      routerConfig: routerConfig,
      builder: builder,
      themeMode: themeMode ?? ThemeMode.light,
      locale: locale,
      supportedLocales: supportedLocales ?? const [Locale('en', 'US')],
      localeListResolutionCallback: localeListResolutionCallback,
      localeResolutionCallback: localeResolutionCallback,
      localizationsDelegates: localizationsDelegates,
      showPerformanceOverlay: showPerformanceOverlay,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      shortcuts: shortcuts,
      actions: actions,
      restorationScopeId: restorationScopeId,
      theme: theme.shadTheme,
      materialThemeBuilder: (context, builtTheme) => theme.themeData.copyWith(
        colorScheme: builtTheme.colorScheme,
      ),
    );
  }
}
