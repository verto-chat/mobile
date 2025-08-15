import 'package:context_di/context_di.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../common/common.dart';
import '../../core/core.dart';
import '../../core/features/upload/data/upload_repository.dart';
import '../../core/features/user/data/data.dart';
import '../features.dart';
import 'presentation/managers/sign_in_bloc.dart';
import 'presentation/managers/sign_up_bloc.dart';

export 'domain/domain.dart';
export 'presentation/presentation.dart';

part 'auth.g.dart';

@Feature()
@Singleton(LocalUserSource)
@Singleton(UserRepository, as: IUserRepository)
@Singleton(UploadRepository, as: IUploadRepository)
@Singleton(ShareImpl, as: IShare)
class LoggedInFeature extends FeatureDependencies with _$LoggedInFeatureMixin {
  LoggedInFeature({super.key, required Widget child})
    : super(
        child: UsersFeature(
          child: InAppFeature(
            child: MultiProvider(
              providers: [BlocProvider(create: (c) => c.read<CreateSubscriptionBloc>().call(c), lazy: false)],
              child: ChatsFeature(child: ProfileFeature(child: child)),
            ),
          ),
        ),
      );

  @override
  List<Registration> register() {
    return [
      registerSingleton((context) {
        final dio = context.read<CreateDio>().call(context, const (backendSupport: true));

        final endpoints = context.read<IEndpoints>();

        return UserApi(dio, baseUrl: "${endpoints.baseUrl}/users");
      }),

      ...super.register(),
    ];
  }
}

@Feature()
@Factory(SignUpBloc)
@Factory(SignInBloc)
class LoggedOutFeature extends FeatureDependencies with _$LoggedOutFeatureMixin {
  const LoggedOutFeature({super.key, super.child});
}
