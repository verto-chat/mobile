import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthApi {
  final SupabaseClient _supabase;

  SupabaseAuthApi(this._supabase);

  Future<bool> checkUserRegistered({required String email}) async {
    return await _supabase.rpc<bool>('check_user_registered', params: {'p_email': email});
  }

  Future<bool> checkUserRegisteredByAppleId({required String appleId}) async {
    return await _supabase.rpc<bool>('check_user_registered_by_apple_id', params: {'p_apple_id': appleId});
  }

  Future<void> loginByPassword({required String email, required String password}) =>
      _supabase.auth.signInWithPassword(email: email, password: password);

  Future<void> sendResetPasswordCode({required String email}) => _supabase.auth.resetPasswordForEmail(email.trim());

  Future<String?> checkResetCode(String email, String code) async {
    final result = await _supabase.auth.verifyOTP(email: email, token: code, type: OtpType.recovery);

    return result.user?.id;
  }

  Future<void> resetPassword({required String password}) async {
    await _supabase.auth.updateUser(UserAttributes(password: password));
  }

  Future<void> changePassword({required String currentPassword, required String password}) async {
    await _supabase.auth.signInWithPassword(email: _supabase.auth.currentUser!.email, password: currentPassword);

    await _supabase.auth.updateUser(UserAttributes(password: password));
  }

  Future<void> logOut() => _supabase.auth.signOut();

  Future<void> deleteAccount() async {
    final userId = _supabase.auth.currentUser!.id;

    await _supabase.rpc<dynamic>('delete_user', params: {'uid': userId});

    await _supabase.auth.signOut();
  }
}
