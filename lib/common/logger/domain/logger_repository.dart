import '../../common.dart';

abstract interface class ILoggerRepository {
  Future<void> storeLog(Log log);

  Future<List<SessionInfo>?> getSessionsList();

  Future<List<Log>?> getLogByBoxId(String key);

  void dispose();
}
