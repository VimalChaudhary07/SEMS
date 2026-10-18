// Centralized configuration for switching between mock and production data.
// Set [useMockData] to false when production services are available.
abstract final class AppConfig {
  /// When true, the app uses local mock data from JSON files and in-memory
  /// repositories. When false, the app will use production API-backed
  /// repositories (not yet implemented).
  static const bool useMockData = true;

  /// Base URL for the production API (unused while [useMockData] is true).
  static const String apiBaseUrl = 'https://api.sems.example.com';

  /// MQTT broker host for real-time telemetry (unused while mock).
  static const String mqttHost = 'mqtt.sems.example.com';

  /// Default timeout for API requests.
  static const Duration apiTimeout = Duration(seconds: 15);
}
