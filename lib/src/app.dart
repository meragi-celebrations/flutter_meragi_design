import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/theme/theme.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MDApp extends StatelessWidget {
  final String? title;
  final Widget? home;
  final Map<String, WidgetBuilder>? routes;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  final RouteFactory? onUnknownRoute;
  final List<NavigatorObserver>? navigatorObservers;
  final GlobalKey<NavigatorState>? navigatorKey;
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
  final RouterConfig<Object>? routerConfig;
  final bool _isRouter;

  MDApp({
    super.key,
    this.title,
    this.home,
    this.routes,
    this.initialRoute,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.navigatorObservers,
    this.navigatorKey,
    this.builder,
    this.themeMode,
    this.locale,
    this.supportedLocales,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    required this.theme,
  })  : _isRouter = false,
        routerConfig = null,
        localizationsDelegates = (localizationsDelegates ?? []).toList()..add(FlutterQuillLocalizations.delegate);

  MDApp.router({
    super.key,
    this.title,
    this.builder,
    this.themeMode,
    this.locale,
    this.supportedLocales,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    required this.theme,
    required this.routerConfig,
  })  : _isRouter = true,
        home = null,
        routes = null,
        initialRoute = null,
        onGenerateRoute = null,
        onUnknownRoute = null,
        navigatorObservers = null,
        localizationsDelegates = (localizationsDelegates ?? []).toList()..add(FlutterQuillLocalizations.delegate),
        navigatorKey = null;

  @override
  Widget build(BuildContext context) {
    return _isRouter
        ? ShadApp.router(
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
            materialThemeBuilder: (context, builtTheme) =>
                theme.themeData.copyWith(colorScheme: builtTheme.colorScheme),
          )
        : ShadApp(
            title: title ?? '',
            home: home,
            routes: routes ?? const {},
            initialRoute: initialRoute,
            onGenerateRoute: onGenerateRoute,
            onUnknownRoute: onUnknownRoute,
            navigatorObservers: navigatorObservers ?? const [],
            navigatorKey: navigatorKey,
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
