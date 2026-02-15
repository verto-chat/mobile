import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../common/common.dart';
import '../../../../core/core.dart';
import '../../domain/domain.dart';

class UsersRepository implements IUsersRepository {
  final SupabaseClient _supabase;

  UsersRepository(this._supabase);

  @override
  Future<DomainResultDErr<List<UserInfo>>> getUsers() async {
    try {
      final userId = _supabase.auth.currentUser!.id;

      final response = await _supabase.from('users').select().neq('id', userId);

      final users = response.map((data) => _createUserEntity(data)).toList();

      return Success(data: users);
    } catch (e) {
      return Error(errorData: const DomainErrorType.serverError());
    }
  }

  UserInfo _createUserEntity(Map<String, dynamic> data) {
    return UserInfo(
      id: DomainId.fromString(id: data['id'] as String),
      firstName: data["first_name"] as String,
      lastName: data["last_name"] as String?,
      avatarUrl: data["avatar_url"] as String?,
      thumbnailAvatarUrl: data["thumbnail_avatar_url"] as String?,
      email: '',
    );
  }
}
