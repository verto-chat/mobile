import '../../../../../common/common.dart';
import '../entities/entities.dart';

abstract interface class IUserRepository {
  DomainId get userId;

  Future<UserInfo?> getInitUserInfo({required void Function(DomainResultDErr<UserInfo> fresh)? onFreshData});

  Future<DomainResultDErr<UserInfo>> getUserInfo();

  Future<EmptyDomainResult> updateAvatar({
    required String avatarUrl,
    required String thumbnailAvatarUrl,
    required UserInfo user,
  });

  Future<EmptyDomainResult> updateProfile({
    required String firstName,
    required String? lastName,
    required UserInfo user,
  });
}
