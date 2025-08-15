import '../entities/entities.dart';
import 'database_provider.dart';

extension SessionLogsDao on DatabaseProvider {
  static const _sessionLimit = 10;

  Future<void> createSession(SessionInfo session) async {
    final db = await database;
    await db.insert('session_info', {
      'key': session.key,
      'date': session.date.millisecondsSinceEpoch,
      'level': session.level?.index,
    });

    // Удаляем самые старые, если больше лимита
    await removeOldSessions(_sessionLimit);
  }

  Future<List<SessionInfo>> getSessionsList() async {
    final db = await database;
    final maps = await db.query('session_info', orderBy: 'date DESC', limit: _sessionLimit);
    return maps
        .map(
          (m) => SessionInfo(
            key: m['key'] as String,
            date: DateTime.fromMillisecondsSinceEpoch(m['date'] as int),
            level: m['level'] != null ? LogLevel.values[m['level'] as int] : null,
          ),
        )
        .toList();
  }

  Future<void> insertLog(String sessionKey, Log log) async {
    final db = await database;
    await db.insert('logs', {
      'session_key': sessionKey,
      'log_row': log.logRow,
      'log_level': log.logLevel.index,
      'create_date': log.createDate.millisecondsSinceEpoch,
    });
  }

  Future<void> updateSessionLevel(String sessionKey, LogLevel newLevel) async {
    final db = await database;
    await db.update('session_info', {'level': newLevel.index}, where: 'key = ?', whereArgs: [sessionKey]);
  }

  Future<List<Log>> getLogsBySession(String sessionKey) async {
    final db = await database;
    final maps = await db.query('logs', where: 'session_key = ?', whereArgs: [sessionKey], orderBy: 'create_date ASC');
    return maps
        .map(
          (m) => Log(
            m['log_row'] as String,
            LogLevel.values[m['log_level'] as int],
            DateTime.fromMillisecondsSinceEpoch(m['create_date'] as int),
          ),
        )
        .toList();
  }

  Future<void> removeOldSessions(int keepCount) async {
    final db = await database;
    final all = await db.query('session_info', columns: ['key'], orderBy: 'date ASC');
    if (all.length <= keepCount) return;
    final toDelete = all.take(all.length - keepCount).map((e) => e['key'] as String);
    for (var key in toDelete) {
      await db.delete('session_info', where: 'key = ?', whereArgs: [key]);
    }
  }
}
