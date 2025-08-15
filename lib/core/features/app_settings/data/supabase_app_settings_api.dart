import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAppSettingsApi {
  final SupabaseClient _supabaseClient;

  SupabaseAppSettingsApi(this._supabaseClient);

  Future<bool> hasInternalPermissions(String deviceId) async {
    final result = await _supabaseClient.from('internal_devices').select('*').eq('device_id', deviceId).maybeSingle();

    return result != null;
  }
}
