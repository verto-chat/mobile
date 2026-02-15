import 'package:context_di/context_di.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import '../../../common/common.dart';
import '../../../common/network/network_service.dart';
import '../../../features/auth/auth.dart';
import '../../../features/auth/data/data.dart';
import '../../../features/auth/data/repositories/apple_sign_in_provider.dart';
import '../../../features/auth/data/repositories/google_sign_in_provider.dart';
import '../../../features/auth/presentation/managers/auth_bloc.dart';
import '../../../features/in_app/in_app.dart';
import '../../core.dart';
import '../upload/data/supabase_upload_api.dart';

export 'app_bloc.dart';

part 'app.g.dart';

@Feature()
@Singleton(SafeDio)
@Singleton(NetworkService, as: INetworkService)
@Singleton(SupabaseAuthApi)
@Singleton(ExternalOpenUrl)
@Singleton(AppleSignInProvider)
@Singleton(GoogleSignInProvider)
@Singleton(AuthRepository, as: IAuthRepository)
@Singleton(TokenRepository, as: ITokenRepository)
@Singleton(PushActionNotificator)
@Singleton(PushProvider)
@Singleton(TokenService)
class AppFeature extends FeatureDependencies with _$AppFeatureMixin {
  const AppFeature(this.initialDependencies, {super.key, super.builder, super.child});

  final List<Registration> initialDependencies;

  @override
  List<Registration> register() => [
    ...initialDependencies,

    registerSingleton<SupabaseUploadApi>((c) => SupabaseUploadApi(c.read())),

    registerSingleton((c) {
      final dio = Dio(
        BaseOptions(
          baseUrl: c.read<IEndpoints>().baseUrl,
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          connectTimeout: const Duration(seconds: 30),
        ),
      );

      dio.interceptors
        ..add(c.read<TalkerDioLogger>())
        ..add(SupabaseTokenInterceptor(c.read()));

      return Openapi(dio: dio);
    }),

    registerSingleton((context) => context.read<Openapi>().getDeviceApi()),
    registerSingleton((context) => context.read<Openapi>().getAuthApi()),
    registerSingleton((context) => context.read<Openapi>().getUserApi()),

    ...super.register(),

    registerSingleton<AppBloc>((c) => AppBloc(c, c.read(), c.read()), dispose: (c, bloc) => bloc.close()),
    registerSingleton<AuthBloc>((c) => AuthBloc(c, c.read()), dispose: (c, bloc) => bloc.close()),
    SingletonRegistration<IMetrica>((c) => kReleaseMode ? AppMetricaMetrica() : FakeMetrica(), lazy: false),
    SingletonRegistration<IAdMobId>((c) => TestAdMobId(), lazy: false),
    // SingletonRegistration<IAdMobId>((c) => kReleaseMode ? ProductionAdMobId() : TestAdMobId(), lazy: false),
  ];
}
