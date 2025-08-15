import 'dart:developer' as dart_developer;

import 'package:flutter/foundation.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:talker_flutter/talker_flutter.dart' hide LogLevel;

import 'entities/entities.dart';
import 'logger_interface.dart';

class TalkerLoggerImpl implements ILogger {
  late final Talker _talker;

  TalkerLoggerImpl() {
    final settings = TalkerSettings();
    final history = DefaultTalkerHistory(settings);

    _talker = Talker(
      logger: TalkerLogger().copyWith(output: _defaultFlutterOutput),
      settings: settings,
      history: history,
    );
  }

  Talker get talkerInstance => _talker;

  @override
  void log(LogLevel logLevel, String text, {dynamic exception, StackTrace? stacktrace}) {
    String? callMember;

    // skip an extra frame from talker wrapper
    stacktrace ??= filterStackTrace(StackTrace.current, 1);

    final trace = Trace.from(stacktrace);

    if (trace.frames.isNotEmpty && trace.frames.length > 1) {
      String? member = trace.frames[1].member;

      callMember = member?.split(".").take(2).join(" ─> ");
    }

    _log(logLevel, "${callMember ?? "callMember"}: $text", exception, trace.original);
  }

  /// source code copied from TalkerFlutter extension
  static dynamic _defaultFlutterOutput(String message) {
    if (kIsWeb) {
      // ignore: avoid_print
      print(message);
      return;
    }
    if ([TargetPlatform.iOS, TargetPlatform.macOS].contains(defaultTargetPlatform)) {
      dart_developer.log(message, name: 'Talker');
      return;
    }
    debugPrint(message);
  }

  static StackTrace filterStackTrace(StackTrace stackTrace, [int level = 0]) {
    final List<String> lines = stackTrace.toString().split('\n');

    return StackTrace.fromString(lines.skip(level).join('\n'));
  }

  void _log(LogLevel logLevel, String text, dynamic exception, StackTrace? stacktrace) {
    switch (logLevel) {
      case (LogLevel.fatal):
        _talker.critical(text, exception, stacktrace);
      case LogLevel.error:
        _talker.error(text, exception, stacktrace);
      case LogLevel.debug:
        _talker.debug(text, exception, stacktrace);
      case LogLevel.info:
        _talker.info(text, exception);
      case LogLevel.trace:
        _talker.verbose(text, exception, stacktrace);
      case LogLevel.warning:
        _talker.warning(text, exception);
    }
  }
}
