import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/models.dart';

class SupabaseLegalApi {
  final SupabaseClient _supabaseClient;

  SupabaseLegalApi(this._supabaseClient);

  Future<LegalInfoDto> getInfo({required String languageCode}) async {
    final langCode = languageCode.split('-').first;

    final policyUrlResponse =
        await _supabaseClient.from('app_settings').select('value').eq('key', "policyUrl").single();
    final termsUrlResponse = await _supabaseClient.from('app_settings').select('value').eq('key', "termsUrl").single();
    final gdprUrlResponse = await _supabaseClient.from('app_settings').select('value').eq('key', "gdprUrl").single();

    final policyUrl = policyUrlResponse['value'] as String;
    final termsUrl = termsUrlResponse['value'] as String;
    final gdprUrl = gdprUrlResponse['value'] as String;

    return LegalInfoDto(
      policyUrl: policyUrl.replaceAll(":lang", langCode),
      termsUrl: termsUrl.replaceAll(":lang", langCode),
      gdprUrl: gdprUrl.replaceAll(":lang", langCode),
      languageCode: languageCode,
    );
  }
}
