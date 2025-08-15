import 'package:talker_flutter/talker_flutter.dart';
import '../domain/logger_repository.dart';
import '../entities/log.dart';
import '../entities/log_level.dart' as local_log;

class MainTalkerObserver extends TalkerObserver {
  final ILoggerRepository _loggerStorage;

  MainTalkerObserver(this._loggerStorage);

  @override
  void onError(TalkerError err) {
    super.onError(err);
    _loggerStorage.storeLog(Log(err.generateTextMessage(), local_log.LogLevel.error, err.time));
  }

  @override
  void onException(TalkerException err) {
    super.onException(err);
    _loggerStorage.storeLog(Log(err.generateTextMessage(), local_log.LogLevel.error, err.time));
  }

  @override
  void onLog(TalkerData log) {
    super.onLog(log);
    _loggerStorage.storeLog(Log(log.generateTextMessage(), log.logLevel.toLocalLog(), log.time));
  }
}

extension LogLevelExtension on LogLevel? {
  local_log.LogLevel toLocalLog() {
    return switch (this) {
      LogLevel.error => local_log.LogLevel.error,
      LogLevel.critical => local_log.LogLevel.fatal,
      LogLevel.info => local_log.LogLevel.info,
      LogLevel.debug => local_log.LogLevel.debug,
      LogLevel.verbose => local_log.LogLevel.trace,
      LogLevel.warning => local_log.LogLevel.warning,
      null => local_log.LogLevel.trace,
    };
  }
}
