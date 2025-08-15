import '../../../../common/common.dart';
import '../../../../core/core.dart';

abstract interface class IUsersRepository {
  Future<DomainResultDErr<List<UserInfo>>> getUsers();
}
