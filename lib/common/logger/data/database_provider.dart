import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../../common.dart';

class _EncryptionKeyManager {
  static const _keyTitle = 'logs_encryption_key';

  static Future<String> getOrCreate(ISecureStorage storage) async {
    String? key = await storage.read(key: _keyTitle);
    if (key != null) return key;

    final bytes = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    key = base64UrlEncode(bytes);
    await storage.write(key: _keyTitle, value: key);
    return key;
  }
}

class DatabaseProvider {
  static DatabaseProvider? _instance;
  static Database? _db;

  late final String _password;

  static Future<DatabaseProvider> init(ISecureStorage storage) async {
    if (_instance != null) return _instance!;
    final inst = DatabaseProvider();
    inst._password = await _EncryptionKeyManager.getOrCreate(storage);
    _instance = inst;
    return inst;
  }

  Future<Database> get database async {
    if (_db != null) return _db!;

    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, 'logs.db');

    try {
      _db = await openDatabase(path, password: _password, version: 1, onCreate: _createDB);
    } catch (_) {
      // при любом сбое (неверный ключ или повреждённый файл) удаляем и пересоздаём
      await deleteDatabase(path);
      _db = await openDatabase(path, password: _password, version: 1, onCreate: _createDB);
    }

    return _db!;
  }

  FutureOr<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE session_info (
        key TEXT PRIMARY KEY,
        date INTEGER NOT NULL,
        level INTEGER
      );
    ''');
    await db.execute('''
      CREATE TABLE logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_key TEXT NOT NULL,
        log_row TEXT,
        log_level INTEGER,
        create_date INTEGER,
        FOREIGN KEY(session_key) REFERENCES session_info(key) ON DELETE CASCADE
      );
    ''');
  }

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}
