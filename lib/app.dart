import 'package:auto_route/auto_route.dart';
import 'package:context_di/context_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'core/core.dart';
import 'features/auth/presentation/managers/auth_bloc.dart';
import 'features/features.dart';
import 'i18n/translations.g.dart';
import 'router/app_router.dart';

class VertoChatApp extends StatelessWidget {
  const VertoChatApp({super.key, required this.initialDependencies});

  final List<Registration> initialDependencies;

  @override
  Widget build(BuildContext context) {
    return AppFeature(initialDependencies, child: TranslationProvider(child: const _AppWrapper()));
  }
}

class _AppWrapper extends StatefulWidget {
  const _AppWrapper();

  @override
  State<_AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<_AppWrapper> {
  late final RouterConfig<UrlState> _loggedInRouterConfig;
  late final RouterConfig<UrlState> _loggedOutRouterConfig;

  @override
  void initState() {
    super.initState();

    _loggedInRouterConfig = AppRouter(
      context.read(),
      context.read(),
    ).config(navigatorObservers: () => [context.resolve<TalkerRouteObserver>()]);

    _loggedOutRouterConfig = AppRouter(
      context.read(),
      context.read(),
    ).config(navigatorObservers: () => [context.resolve<TalkerRouteObserver>()]);

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    ).then((value) => SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]));
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<AuthBloc, AuthState>(
    builder: (context, state) {
      return switch (state) {
        LoggedInState() => LoggedInFeature(child: _App(router: _loggedInRouterConfig)),
        LoggedOutState() => LoggedOutFeature(child: _App(router: _loggedOutRouterConfig)),
      };
    },
  );
}

class _App extends StatelessWidget {
  const _App({required RouterConfig<UrlState> router}) : _routerConfig = router;

  final RouterConfig<UrlState> _routerConfig;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return MaterialApp.router(
          showPerformanceOverlay: false,
          debugShowCheckedModeBanner: false,
          locale: TranslationProvider.of(context).flutterLocale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocaleUtils.supportedLocales,
          title: 'Verto Chat',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: state.themeMode,
          routerConfig: _routerConfig,
        );
      },
    );
  }
}
