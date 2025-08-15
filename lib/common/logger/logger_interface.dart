import 'entities/entities.dart';

abstract interface class ILogger {
  void log(LogLevel logLevel, String text, {dynamic exception, StackTrace? stacktrace});
}
