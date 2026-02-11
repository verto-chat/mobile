import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:context_di/context_di.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_settings.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart' hide LogLevel;

import 'app_db.dart';
import 'common/common.dart';
import 'common/logger/data/database_provider.dart';
import 'common/logger/data/logger_repository.dart';
import 'common/logger/domain/logger_repository.dart';
import 'common/logger/presentation/talker_observer.dart';
import 'common/logger/talker_logger.dart';
import 'common/preferences/shared_preferences.dart';
import 'core/core.dart';
import 'firebase_options.dart';

Future<List<Registration>> configure() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  MobileAds.instance.initialize();

  // if (kReleaseMode) {
  //   AppMetrica.activate(const AppMetricaConfig("ab124b4a-dda2-44f5-8cce-a381798caf65"));
  // }

  final versionProvider = await VersionProvider.create();
  final sharedPreferences = await AppSharedPreferences.create();

  final endpointsManager = EndpointsManager(sharedPreferences, useProdApiWhenDebug: false);

  final endpoints = await endpointsManager.getEndpoints();

  await Supabase.initialize(url: endpoints.supabaseUrl, anonKey: endpoints.supabaseAnonKey);

  final langRepo = LangRepository(sharedPreferences);
  await langRepo.init();

  final deviceIdProvider = await DeviceIdProvider.create();
  final pushActionNotificator = PushActionNotificator();

  AndroidOptions getAndroidOptions() => const AndroidOptions(resetOnError: true);

  final flutterSecureStorage = FlutterSecureStorage(aOptions: getAndroidOptions());

  final logger = TalkerLoggerImpl();

  final localPushPresenter = LocalPushPresenter(logger, pushActionNotificator);
  await localPushPresenter.setup();

  ISecureStorage secureStorage = AppSecureStorage(flutterSecureStorage, logger);

  final dbProvider = await DatabaseProvider.init(secureStorage);

  final loggerRepository = LoggerRepository(dbProvider);

  await loggerRepository.init();

  logger.talkerInstance.configure(observer: MainTalkerObserver(loggerRepository));

  FlutterError.onError = (FlutterErrorDetails details) {
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    }
    logger.log(LogLevel.error, details.summary.toString(), exception: details.exception, stacktrace: details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (kReleaseMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
    logger.log(LogLevel.error, error.toString(), exception: error, stacktrace: stack);
    return true;
  };

  Bloc.observer = TalkerBlocObserver(
    talker: logger.talkerInstance,
    settings: const TalkerBlocLoggerSettings(printStateFullData: false, printEventFullData: false),
  );

  final deepLinksNotificator = DeepLinksNotificator();

  final db = AppDatabase();

  //await _initAppsFlyer(logger, deepLinksNotificator);

  await _logStartMessage(logger, versionProvider);

  return [
    SingletonRegistration<ILogger>((c) => logger, lazy: false),
    SingletonRegistration<SupabaseClient>((c) => Supabase.instance.client, lazy: false),
    SingletonRegistration<VersionProvider>((c) => versionProvider, lazy: false),
    SingletonRegistration<LangRepository>((c) => langRepo, lazy: false),
    SingletonRegistration<ILoggerRepository>((c) => loggerRepository, lazy: false),
    SingletonRegistration<ISharedPreferences>((c) => sharedPreferences, lazy: false),
    SingletonRegistration<DeviceIdProvider>((c) => deviceIdProvider, lazy: false),
    SingletonRegistration<PushActionNotificator>((c) => pushActionNotificator, lazy: false),
    SingletonRegistration<DeepLinksNotificator>((c) => deepLinksNotificator, lazy: false),
    SingletonRegistration<LocalPushPresenter>((c) => localPushPresenter, lazy: false),
    SingletonRegistration<EndpointsManager>((c) => endpointsManager, lazy: false),
    SingletonRegistration<IEndpoints>((c) => endpoints, lazy: false),
    SingletonRegistration<AppDatabase>((c) => db, lazy: false),
    FactoryRegistration<TalkerRouteObserver>((c) => TalkerRouteObserver(logger.talkerInstance)),
    SingletonRegistration<TalkerDioLogger>(
      (c) => TalkerDioLogger(
        talker: logger.talkerInstance,
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: false,
          printResponseHeaders: false,
          printResponseMessage: true,
        ),
      ),
      lazy: false,
    ),
  ];
}

Future<void> _logStartMessage(ILogger logger, VersionProvider versionProvider) async {
  final platform = _getPlatformName();
  final version = "${versionProvider.version}-${versionProvider.buildNumber}";

  logger.log(LogLevel.info, "Application started: platform: $platform; version: $version");
}

String _getPlatformName() {
  String platform = switch (defaultTargetPlatform) {
    TargetPlatform.android => "android",
    TargetPlatform.iOS => "iOS",
    TargetPlatform.macOS => "macOS",
    TargetPlatform.windows => "windows",
    TargetPlatform.linux => "linux",
    _ => "unknown",
  };

  if (kIsWeb) {
    platform = "web";
  }

  return platform;
}

Future<void> _initAppsFlyer(ILogger logger, DeepLinksNotificator deepLinksNotificator) async {
  logger.log(LogLevel.info, "Initialize Apps Flyer");

  AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
    afDevKey: "3uDG2BkBTo5giYacnERZwT",
    appId: Platform.isIOS ? "6744974673" : "com.ovdix.app",
    showDebug: false,
    manualStart: true,
  ); // Optional field

  try {
    final sdk = AppsflyerSdk(appsFlyerOptions);

    await sdk.initSdk(registerConversionDataCallback: true, registerOnDeepLinkingCallback: true);

    _subscribeDeepLinks(sdk, logger, deepLinksNotificator);

    if (Platform.isAndroid) {
      sdk.performOnDeepLinking();
    }

    sdk.startSDK(
      onSuccess: () {
        logger.log(LogLevel.info, "AppsFlyer SDK initialized successfully.");
      },
      onError: (errorCode, errorMessage) {
        logger.log(LogLevel.error, "Error initializing AppsFlyer SDK: Code $errorCode - $errorMessage");
      },
    );
  } catch (e) {
    logger.log(LogLevel.error, "Error initializing AppsFlyer SDK", exception: e);
  }
}

void _subscribeDeepLinks(AppsflyerSdk appsflyerSdk, ILogger logger, DeepLinksNotificator deepLinksNotificator) {
  appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
    switch (dp.status) {
      case Status.FOUND:
        logger.log(LogLevel.info, dp.deepLink?.toString() ?? 'DeepLink found and is null');
        logger.log(LogLevel.info, "deep link value: ${dp.deepLink?.deepLinkValue}");

        if (dp.deepLink != null) {
          final url = dp.deepLink!.getStringValue("link");

          if (url != null) {
            deepLinksNotificator.notify(DeepLinkInfo(url: url));
          }
        }

        break;
      case Status.NOT_FOUND:
        logger.log(LogLevel.info, "deep link not found");
        break;
      case Status.ERROR:
        logger.log(LogLevel.info, "deep link error: ${dp.error}");
        break;
      case Status.PARSE_ERROR:
        logger.log(LogLevel.info, "deep link status parsing error");
        break;
    }
  });
}
