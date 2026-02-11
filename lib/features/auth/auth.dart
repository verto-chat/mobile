import 'package:context_di/context_di.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openapi/openapi.dart';
import 'package:provider/provider.dart';

import '../../common/common.dart';
import '../../core/core.dart';
import '../../core/features/upload/data/upload_repository.dart';
import '../../core/features/user/data/data.dart';
import '../../core/features/user/data/data_sources/local/local_user_source.dart';
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
              child: CreateChatsFeature(
                child: ChatsFeature(child: ProfileFeature(child: child)),
              ),
            ),
          ),
        ),
      );

  @override
  List<Registration> register() {
    return [registerSingleton((context) => context.read<Openapi>().getUserApi()), ...super.register()];
  }
}

@Feature()
@Factory(SignUpBloc)
@Factory(SignInBloc)
class LoggedOutFeature extends FeatureDependencies with _$LoggedOutFeatureMixin {
  const LoggedOutFeature({super.key, super.child});
}
