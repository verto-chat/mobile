import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../common.dart';
import '../domain/logger_repository.dart';
import 'database_provider.dart';
import 'session_logs_dao.dart';

class LoggerRepository implements ILoggerRepository {
  static const _sessionSuffix = '_session_log';

  final DatabaseProvider _dbProvider;
  late final SessionInfo _currentSession;

  LoggerRepository(this._dbProvider);

  Future<void> init() async {
    _currentSession = SessionInfo(key: const Uuid().v4() + _sessionSuffix, date: DateTime.now());
    await _dbProvider.createSession(_currentSession);
  }

  @override
  Future<void> storeLog(Log log) async {
    await _dbProvider.insertLog(_currentSession.key, log);

    if (_currentSession.level == null || log.logLevel.index > _currentSession.level!.index) {
      _currentSession.level = log.logLevel;
      await _dbProvider.updateSessionLevel(_currentSession.key, log.logLevel);
    }
  }

  @override
  Future<List<SessionInfo>?> getSessionsList() async {
    return await _dbProvider.getSessionsList();
  }

  @override
  Future<List<Log>?> getLogByBoxId(String boxId) async {
    return await _dbProvider.getLogsBySession(boxId);
  }

  @override
  void dispose() {
    _dbProvider.close();
  }
}
