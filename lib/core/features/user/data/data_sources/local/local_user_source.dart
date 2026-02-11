import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:openapi/openapi.dart';

import '/app_db.dart';

class LocalUserSource {
  final AppDatabase _db;

  LocalUserSource(this._db);

  Future<UserInfoDto?> getCachedUserInfo() async {
    final model = await _db.users.select().getSingleOrNull();

    return model?.toDto();
  }

  Future<void> cacheUserInfo(UserInfoDto data) async {
    await _db.users.deleteAll();

    await _db.users.insertOne(data.toData());
  }
}

extension _UserExtension on User {
  UserInfoDto toDto() {
    return UserInfoDto.fromJson(jsonDecode(this.json) as Map<String, dynamic>);
  }
}

extension _UserInfoEntityExtension on UserInfoDto {
  User toData() => User(id: 0, json: jsonEncode(toJson()));
}
