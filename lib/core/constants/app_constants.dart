class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Air Quality Guardian';
  static const String appVersion = '1.0.0';

  // Cache Durations
  static const Duration dashboardCacheDuration = Duration(minutes: 30);
  static const Duration sensorCacheDuration = Duration(minutes: 15);
  static const Duration forecastCacheDuration = Duration(hours: 1);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Validation
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minPasswordLength = 8;
  static const int minAge = 1;
  static const int maxAge = 120;
  static const int minOutdoorHours = 0;
  static const int maxOutdoorHours = 24;

  // Map
  static const double defaultZoom = 12.0;
  static const double markerClusterZoom = 10.0;
  static const double defaultLatitude = 28.6139; // Delhi
  static const double defaultLongitude = 77.2090;

  // Refresh Intervals
  static const Duration dashboardRefreshInterval = Duration(minutes: 5);
  static const Duration mapRefreshInterval = Duration(minutes: 3);

  // Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';

  // Hive Boxes
  static const String boxUser = 'user_box';
  static const String boxSensor = 'sensor_box';
  static const String boxDashboard = 'dashboard_box';
  static const String boxForecast = 'forecast_box';
  static const String boxAlerts = 'alerts_box';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Debounce Durations
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const Duration inputDebounce = Duration(milliseconds: 300);
}
