/// Application environment configuration.
enum Environment { dev, staging, prod }

class AppEnvironment {
  AppEnvironment._();

  static Environment _current = Environment.dev;

  static Environment get current => _current;

  static void setCurrent(Environment env) => _current = env;

  static bool get isDev => _current == Environment.dev;
  static bool get isStaging => _current == Environment.staging;
  static bool get isProd => _current == Environment.prod;

  /// Whether to use mock datasources instead of real API.
  static bool get useMock => _current == Environment.dev;

  static String get baseUrl => switch (_current) {
    Environment.dev => 'http://10.0.2.2:3000/api/v1',
    Environment.staging => 'https://staging-api.connexa.app/api/v1',
    Environment.prod => 'https://api.connexa.app/api/v1',
  };

  static Duration get requestTimeout => switch (_current) {
    Environment.dev => const Duration(seconds: 30),
    _ => const Duration(seconds: 15),
  };
}
