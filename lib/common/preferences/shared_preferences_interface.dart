import 'dart:async';

abstract interface class ISharedPreferences {
  Future<bool> setString(String key, String value);

  FutureOr<String?> getString(String key);
}
