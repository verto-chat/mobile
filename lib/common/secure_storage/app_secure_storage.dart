import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../logger/logger.dart';
import 'secure_storage_interface.dart';

class AppSecureStorage implements ISecureStorage {
  final FlutterSecureStorage _flutterSecureStorage;
  final ILogger _logger;

  AppSecureStorage(this._flutterSecureStorage, this._logger);

  @override
  Future<String?> read({required String key}) async {
    try {
      return await _flutterSecureStorage.read(key: key);
    } catch (e, s) {
      _logger.log(LogLevel.error, e.toString(), exception: e, stacktrace: s);
      return null;
    }
  }

  @override
  Future<bool> write({required String key, required String value}) async {
    try {
      await _flutterSecureStorage.write(key: key, value: value);
      return true;
    } catch (e, s) {
      _logger.log(LogLevel.error, e.toString(), exception: e, stacktrace: s);
      return false;
    }
  }

  @override
  Future<Map<String, String>?> readAll() async {
    try {
      return await _flutterSecureStorage.readAll();
    } catch (e, s) {
      _logger.log(LogLevel.error, e.toString(), exception: e, stacktrace: s);
      return null;
    }
  }

  @override
  Future<bool> delete({required String key}) async {
    try {
      await _flutterSecureStorage.delete(key: key);
      return true;
    } catch (e, s) {
      _logger.log(LogLevel.error, e.toString(), exception: e, stacktrace: s);
      return false;
    }
  }

  @override
  Future<bool> deleteAll() async {
    try {
      await _flutterSecureStorage.deleteAll();
      return true;
    } catch (e, s) {
      _logger.log(LogLevel.error, e.toString(), exception: e, stacktrace: s);
      return false;
    }
  }
}
