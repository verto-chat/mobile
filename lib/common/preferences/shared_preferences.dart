import 'package:shared_preferences/shared_preferences.dart';

import 'shared_preferences_interface.dart';

class AppSharedPreferences implements ISharedPreferences {
  final SharedPreferences _sharedPreferences;

  AppSharedPreferences._create(this._sharedPreferences);

  static Future<AppSharedPreferences> create() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    return AppSharedPreferences._create(sharedPreferences);
  }

  @override
  String? getString(String key) {
    return _sharedPreferences.getString(key);
  }

  @override
  Future<bool> setString(String key, String value) {
    return _sharedPreferences.setString(key, value);
  }
}
