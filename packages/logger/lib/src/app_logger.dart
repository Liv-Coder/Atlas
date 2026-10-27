import 'dart:developer' as developer;
import 'log_level.dart';

class AppLogger {
  const AppLogger._();

  static LogLevel minimumLevel = LogLevel.debug;

  static void debug(String message, {String tag = 'Atlas', Object? data}) =>
      _log(LogLevel.debug, message, tag: tag, data: data);

  static void info(String message, {String tag = 'Atlas', Object? data}) =>
      _log(LogLevel.info, message, tag: tag, data: data);

  static void warning(String message, {String tag = 'Atlas', Object? data}) =>
      _log(LogLevel.warning, message, tag: tag, data: data);

  static void error(
    String message, {
    String tag = 'Atlas',
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _log(
        LogLevel.error,
        message,
        tag: tag,
        data: error,
        stackTrace: stackTrace,
      );

  static String redactSecrets(String input) {
    return input.replaceAllMapped(
      RegExp(r'(sk-|cline_api_key_|Bearer\s+)[A-Za-z0-9_\-]{8,}'),
      (match) => '${match.group(1)}••••••••',
    );
  }

  static void _log(
    LogLevel level,
    String message, {
    required String tag,
    Object? data,
    StackTrace? stackTrace,
  }) {
    if (level.index < minimumLevel.index) return;
    final sanitized = redactSecrets(message);
    final suffix = data != null ? ' | ${redactSecrets(data.toString())}' : '';
    developer.log(
      '[${level.label}] $sanitized$suffix',
      name: tag,
      stackTrace: stackTrace,
    );
  }
}
