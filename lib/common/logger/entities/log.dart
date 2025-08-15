import 'log_level.dart';

class Log {
  late String logRow;
  late LogLevel logLevel;
  late DateTime createDate;

  Log(this.logRow, this.logLevel, this.createDate);

  @override
  String toString() {
    return '$createDate | $logLevel | $logRow';
  }
}
