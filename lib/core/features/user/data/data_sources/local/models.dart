import 'dart:convert';

import 'package:objectbox/objectbox.dart';

import '../../data.dart';

@Entity()
class UserInfoEntity {
  @Id()
  int id = 0;

  final String json;

  UserInfoEntity(this.json);

  static UserInfoEntity fromDto(UserInfoDto dto) {
    return UserInfoEntity(jsonEncode(dto.toJson()));
  }

  UserInfoDto toDto() => UserInfoDto.fromJson(jsonDecode(json) as Map<String, dynamic>);
}
