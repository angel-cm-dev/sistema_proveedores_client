import 'dart:async';
import '../utils/app_logger.dart';

/// Simple retry/timeout helpers for future API integration.
class NetworkHelpers {
  NetworkHelpers._();

  /// Default request timeout.
  static const defaultTimeout = Duration(seconds: 15);

  /// Max retry attempts for transient failures.
  static const maxRetries = 3;

  /// Executes [action] with a timeout. Throws [TimeoutException] if exceeded.
  static Future<T> withTimeout<T>(
    Future<T> Function() action, {
    Duration timeout = defaultTimeout,
  }) async {
    try {
      return await action().timeout(timeout);
    } on TimeoutException {
      AppLogger.warning('Request timed out after ${timeout.inSeconds}s', tag: 'Network');
      rethrow;
    }
  }

  /// Retries [action] up to [maxAttempts] times with exponential backoff.
  /// Only retries on exceptions; if action returns normally, returns the result.
  static Future<T> withRetry<T>(
    Future<T> Function() action, {
    int maxAttempts = maxRetries,
    Duration initialDelay = const Duration(milliseconds: 500),
  }) async {
    int attempt = 0;
    while (true) {
      try {
        attempt++;
        return await action();
      } catch (e, stack) {
        if (attempt >= maxAttempts) {
          AppLogger.error(
            'Failed after $maxAttempts attempts',
            error: e,
            stack: stack,
            tag: 'Network',
          );
          rethrow;
        }
        final delay = initialDelay * (1 << (attempt - 1)); // exponential backoff
        AppLogger.info(
          'Attempt $attempt failed, retrying in ${delay.inMilliseconds}ms...',
          tag: 'Network',
        );
        await Future.delayed(delay);
      }
    }
  }

  /// Combines timeout + retry for a resilient request pattern.
  static Future<T> resilientRequest<T>(
    Future<T> Function() action, {
    Duration timeout = defaultTimeout,
    int maxAttempts = maxRetries,
  }) {
    return withRetry(
      () => withTimeout(action, timeout: timeout),
      maxAttempts: maxAttempts,
    );
  }
}
