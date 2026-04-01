import 'package:dio/dio.dart';
import '../config/app_environment.dart';
import '../errors/failures.dart';
import '../utils/app_logger.dart';

/// Centralized Dio API client with interceptors for auth, logging, and errors.
class ApiClient {
  late final Dio _dio;

  /// In-memory token. In production this should come from secure storage.
  String? _authToken;

  /// Callback invoked when the server returns 401 (session expired).
  void Function()? onSessionExpired;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppEnvironment.baseUrl,
        connectTimeout: AppEnvironment.requestTimeout,
        receiveTimeout: AppEnvironment.requestTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(this),
      _LoggingInterceptor(),
      _ErrorInterceptor(this),
    ]);
  }

  Dio get dio => _dio;

  void setToken(String? token) => _authToken = token;
  String? get token => _authToken;
  void clearToken() => _authToken = null;

  /// Convenience: GET request.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _dio.get<T>(path, queryParameters: queryParameters, options: options);

  /// Convenience: POST request.
  Future<Response<T>> post<T>(String path, {Object? data, Options? options}) =>
      _dio.post<T>(path, data: data, options: options);

  /// Convenience: PUT request.
  Future<Response<T>> put<T>(String path, {Object? data, Options? options}) =>
      _dio.put<T>(path, data: data, options: options);

  /// Convenience: DELETE request.
  Future<Response<T>> delete<T>(String path, {Object? options}) =>
      _dio.delete<T>(path);
}

// ── Auth Interceptor ────────────────────────────────────────────────────────

class _AuthInterceptor extends Interceptor {
  final ApiClient _client;
  const _AuthInterceptor(this._client);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _client.token;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

// ── Logging Interceptor ─────────────────────────────────────────────────────

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.info('→ ${options.method} ${options.uri}', tag: 'API');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.info(
      '← ${response.statusCode} ${response.requestOptions.uri}',
      tag: 'API',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '✕ ${err.requestOptions.method} ${err.requestOptions.uri} → ${err.message}',
      error: err,
      tag: 'API',
    );
    handler.next(err);
  }
}

// ── Error Interceptor ───────────────────────────────────────────────────────

class _ErrorInterceptor extends Interceptor {
  final ApiClient _client;
  const _ErrorInterceptor(this._client);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _client.clearToken();
      _client.onSessionExpired?.call();
    }
    handler.next(err);
  }
}

/// Maps [DioException] to domain [Failure].
Failure mapDioError(DioException e) {
  return switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => const NetworkFailure(),
    DioExceptionType.connectionError => const NetworkFailure(),
    DioExceptionType.badResponse => _mapStatusCode(e.response?.statusCode),
    _ => UnknownFailure(e.message ?? 'Error desconocido de red'),
  };
}

Failure _mapStatusCode(int? code) {
  if (code == null) return const UnknownFailure();
  return switch (code) {
    401 => const SessionExpiredFailure(),
    403 => const ServerFailure('Acceso denegado.'),
    404 => const ServerFailure('Recurso no encontrado.'),
    422 => const ServerFailure('Datos inválidos.'),
    >= 500 => const ServerFailure(),
    _ => const UnknownFailure(),
  };
}
