import 'package:context_di/context_di.dart';

import 'data/repositories/users_repository.dart';
import 'domain/domain.dart';

export 'presentation/presentation.dart';

part 'users.g.dart';

@Feature()
@Singleton(UsersRepository, as: IUsersRepository)
class UsersFeature extends FeatureDependencies with _$UsersFeatureMixin {
  const UsersFeature({super.key, super.builder, super.child});
}
