import 'package:json_annotation/json_annotation.dart';

import '../../../../../common/common.dart';
import '../../domain/domain.dart';

part 'user_info_dto.g.dart';

@JsonSerializable()
class UserInfoDto {
  final String id;
  final String firstName;
  final String? lastName;
  final String? email;
  final String? avatarUrl;
  final String? thumbnailAvatarUrl;
  final String? lastAddressId;

  UserInfoDto({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatarUrl,
    required this.thumbnailAvatarUrl,
    required this.lastAddressId,
  });

  factory UserInfoDto.fromJson(Map<String, dynamic> json) => _$UserInfoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoDtoToJson(this);

  UserInfo toEntity() {
    return UserInfo(
      id: DomainId.fromString(id: id),
      firstName: firstName,
      lastName: lastName,
      email: email,
      avatarUrl: avatarUrl,
      thumbnailAvatarUrl: thumbnailAvatarUrl,
      lastAddressId: lastAddressId != null ? DomainId.fromString(id: lastAddressId!) : null,
    );
  }

  static UserInfoDto fromEntity(UserInfo entity) {
    return UserInfoDto(
      id: entity.id.toString(),
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      avatarUrl: entity.avatarUrl,
      thumbnailAvatarUrl: entity.thumbnailAvatarUrl,
      lastAddressId: entity.lastAddressId?.toString(),
    );
  }
}

@JsonSerializable()
class UpdateUserDto {
  final String firstName;
  final String? lastName;
  final String? avatarUrl;
  final String? thumbnailAvatarUrl;

  UpdateUserDto({
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
    required this.thumbnailAvatarUrl,
  });
}
