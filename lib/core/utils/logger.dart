import 'package:flutter/foundation.dart';

/// Defines the hierarchy of logging levels.
/// Logs will only be printed if their level is greater than or equal to
/// the minimum level set in AppLogger.minimumLevel.
enum LogLevel {
  /// The lowest level, typically for fine-grained internal status and loop data.
  debug,

  /// General operational messages, method start/end, and state changes.
  info,

  /// Potential issues that should be reviewed but do not halt execution.
  warning,

  /// Application errors or exceptions that are caught and handled.
  error,

  /// Severe, unexpected errors that indicate a critical failure.
  fatal,

  /// A special level used to turn off all logging.
  silent,
}

/// A simple, static logger utility for controlled and structured logging.
class AppLogger {
  /// The minimum log level that will be printed to the console.
  ///
  /// Example: If set to [LogLevel.warning], only warnings, errors, and fatal
  /// messages will be shown.
  static LogLevel minimumLevel = LogLevel.debug; // Default: show all logs

  /// Private core logging function that handles level check and formatting.
  static void _log(
    LogLevel level,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    // Check if the current log level meets the minimum requirement.
    if (level.index < minimumLevel.index) {
      return;
    }

    // Get the current time for the timestamp.
    final now = DateTime.now().toIso8601String().substring(
      11,
      23,
    ); // HH:mm:ss.mmm
    final levelName = level.name.toUpperCase();

    // Construct the base log entry.
    String logEntry = '[$now] [$levelName] $message';

    // Append error details if provided.
    if (error != null) {
      logEntry += '\n\t--> Error Details: $error';
    }

    // Append stack trace details if provided.
    if (stackTrace != null) {
      // In a real app, you might only log the first few lines of the stack trace
      // to keep the console clean, but here we include the whole thing.
      logEntry += '\n\t--> Stack Trace: $stackTrace';
    }

    // Use standard Dart debugPrint.
    debugPrint(logEntry);
  }

  /// Logs a [LogLevel.debug] message.
  static void debug(String message) => _log(LogLevel.debug, message);

  /// Logs a [LogLevel.info] message.
  static void info(String message) => _log(LogLevel.info, message);

  /// Logs a [LogLevel.warning] message.
  static void warning(String message) => _log(LogLevel.warning, message);

  /// Logs a [LogLevel.error] message. Includes optional error object and stack trace.
  static void error(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.error, message, error, stackTrace);

  /// Logs a [LogLevel.fatal] message. Includes optional error object and stack trace.
  static void fatal(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.fatal, message, error, stackTrace);

  /// Utility function to easily set the minimum logging level.
  static void setMinimumLevel(LogLevel level) {
    minimumLevel = level;
    // We use a direct debugPrint here, as _log might be disabled after this call.
    debugPrint(
      '--- AppLogger: Minimum level set to: ${level.name.toUpperCase()} ---',
    );
  }
}

/// A simple, static logger utility for controlled and structured logging.
class AppLoggers {
  /// The minimum log level that will be printed to the console.
  ///
  /// Example: If set to [LogLevel.warning], only warnings, errors, and fatal
  /// messages will be shown.
  static LogLevel minimumLevel = LogLevel.debug; // Default: show all logs

  /// Private core logging function that handles level check and formatting.
  static void _log(
    LogLevel level,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    // Check if the current log level meets the minimum requirement.
    if (level.index < minimumLevel.index) {
      return;
    }

    // Get the current time for the timestamp.
    final now = DateTime.now().toIso8601String().substring(
      11,
      23,
    ); // HH:mm:ss.mmm
    final levelName = level.name.toUpperCase();

    // Construct the base log entry.
    String logEntry = '[$now] [$levelName] $message';

    // Append error details if provided.
    if (error != null) {
      logEntry += '\n\t--> Error Details: $error';
    }

    // Append stack trace details if provided.
    if (stackTrace != null) {
      // In a real app, you might only log the first few lines of the stack trace
      // to keep the console clean, but here we include the whole thing.
      logEntry += '\n\t--> Stack Trace: $stackTrace';
    }

    // Use standard Dart debugPrint.
    debugPrint(logEntry);
  }

  /// Logs a [LogLevel.debug] message.
  static void debug(String message) => _log(LogLevel.debug, message);

  /// Logs a [LogLevel.info] message.
  static void info(String message) => _log(LogLevel.info, message);

  /// Logs a [LogLevel.warning] message.
  static void warning(String message) => _log(LogLevel.warning, message);

  /// Logs a [LogLevel.error] message. Includes optional error object and stack trace.
  static void error(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.error, message, error, stackTrace);

  /// Logs a [LogLevel.fatal] message. Includes optional error object and stack trace.
  static void fatal(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.fatal, message, error, stackTrace);

  /// Utility function to easily set the minimum logging level.
  static void setMinimumLevel(LogLevel level) {
    minimumLevel = level;
    // We use a direct debugPrint here, as _log might be disabled after this call.
    debugPrint(
      '--- AppLogger: Minimum level set to: ${level.name.toUpperCase()} ---',
    );
  }
}

/// Centralized logging utility
/// أداة مركزية للتسجيل والتتبع
class AppLoggerr {
  static const String _tag = 'ChessApp';

  /// Log info messages
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      print('ℹ️ [${tag ?? _tag}] $message');
    }
  }

  /// Log debug messages
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      print('🐛 [${tag ?? _tag}] $message');
    }
  }

  /// Log warning messages
  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      print('⚠️ [${tag ?? _tag}] $message');
    }
  }

  /// Log error messages
  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? tag,
  }) {
    if (kDebugMode) {
      print('❌ [${tag ?? _tag}] $message');
      if (error != null) print('Error: $error');
      if (stackTrace != null) print('StackTrace: $stackTrace');
    }
  }

  /// Log game events
  static void gameEvent(String event, {Map<String, dynamic>? data}) {
    if (kDebugMode) {
      print('🎮 [GAME_EVENT] $event ${data != null ? '- Data: $data' : ''}');
    }
  }

  /// Log move events
  static void move(String san, {String? fen, bool? isCheck}) {
    if (kDebugMode) {
      final checkIndicator = isCheck == true ? ' ✓ CHECK' : '';
      print(
        '♟️ [MOVE] $san$checkIndicator ${fen != null ? '- FEN: $fen' : ''}',
      );
    }
  }

  /// Log database operations
  static void database(String operation, {dynamic result}) {
    if (kDebugMode) {
      print(
        '💾 [DATABASE] $operation ${result != null ? '- Result: $result' : ''}',
      );
    }
  }
}
