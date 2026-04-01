import 'dart:developer' as dev;

/// Lightweight logger for Connexa.
/// Wraps `dart:developer` log with severity levels and optional tag.
class AppLogger {
  AppLogger._();

  static void debug(String message, {String? tag}) =>
      _log(message, level: 500, tag: tag ?? 'DEBUG');

  static void info(String message, {String? tag}) =>
      _log(message, level: 800, tag: tag ?? 'INFO');

  static void warning(String message, {String? tag}) =>
      _log(message, level: 900, tag: tag ?? 'WARN');

  static void error(String message, {Object? error, StackTrace? stack, String? tag}) =>
      _log(message, level: 1000, tag: tag ?? 'ERROR', error: error, stack: stack);

  static void _log(
    String message, {
    required int level,
    required String tag,
    Object? error,
    StackTrace? stack,
  }) {
    dev.log(
      message,
      name: 'Connexa.$tag',
      level: level,
      error: error,
      stackTrace: stack,
    );
  }
}
