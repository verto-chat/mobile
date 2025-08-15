import 'dart:async';

import '../../../../../common/common.dart';
import '../../../../core.dart';
import '../supabase_app_settings_api.dart';

class AppSettingsRepository implements IAppSettingsRepository {
  final SupabaseAppSettingsApi _supabaseAppSettingsApi;
  final DeviceIdProvider _deviceIdProvider;
  final ILogger _logger;

  AppSettings? _appSetting;

  AppSettingsRepository(this._supabaseAppSettingsApi, this._deviceIdProvider, this._logger);

  Future<AppSettings?>? _getSettingsProcess;

  @override
  Future<AppSettings?> getSettings() async {
    await _getSettingsProcess;

    if (_appSetting != null) {
      return _appSetting;
    }

    _getSettingsProcess = Future<AppSettings?>(() async {
      _appSetting = await _fetchAppSettings();
      return _appSetting;
    });

    return _getSettingsProcess!;
  }

  Future<AppSettings> _fetchAppSettings() async {
    try {
      final result = await _supabaseAppSettingsApi.hasInternalPermissions(_deviceIdProvider.deviceId ?? "");

      return AppSettings(hasInternalAccess: result);
    } catch (e) {
      _logger.log(LogLevel.error, e.toString());
    }

    return const AppSettings(hasInternalAccess: false);
  }
}
