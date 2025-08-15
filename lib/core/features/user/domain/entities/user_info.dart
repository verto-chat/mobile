import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../common/common.dart';

part 'user_info.freezed.dart';

@freezed
sealed class UserInfo with _$UserInfo {
  const factory UserInfo({
    required DomainId id,
    required String firstName,
    required String? lastName,
    required String? email,
    required String? avatarUrl,
    required String? thumbnailAvatarUrl,
    required DomainId? lastAddressId,
  }) = _UserInfo;

  factory UserInfo.empty() {
    return const UserInfo(
      id: DomainId.fromString(id: "id"),
      firstName: '',
      lastName: null,
      email: null,
      avatarUrl: null,
      thumbnailAvatarUrl: null,
      lastAddressId: null,
    );
  }
}

extension UserInfoExt on UserInfo {
  String? get thumbnail => thumbnailAvatarUrl ?? avatarUrl;
}
