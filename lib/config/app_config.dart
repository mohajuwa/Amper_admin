// lib/config/app_config.dart
class AppConfig {
  static const String environment =
      String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');

  static const String baseUrl = environment == 'production'
      ? 'https://modwir.com/haytham_store'
      : 'http://localhost/haytham_store';

  static const String apiKey =
      String.fromEnvironment('API_KEY', defaultValue: 'dev_key');

  static const bool enableLogging = environment != 'production';
  static const bool enablePerformanceMonitoring = true;

  static const Duration apiTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  static const Map<String, dynamic> crashlyticsConfig = {
    'enabled': environment == 'production',
    'collect_analytics': true,
  };
}
