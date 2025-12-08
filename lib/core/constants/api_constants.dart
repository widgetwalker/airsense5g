class ApiConstants {
  ApiConstants._();

  // Base URLs
  static const String baseUrlDev = 'https://dev-api.airqualityguardian.com/v1';
  static const String baseUrlProd = 'https://api.airqualityguardian.com/v1';

  // Current environment
  static const bool isDevelopment = true;
  static String get baseUrl => isDevelopment ? baseUrlDev : baseUrlProd;

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth Endpoints
  static const String authSignup = '/auth/signup';
  static const String authLogin = '/auth/login';
  static const String authRefresh = '/auth/refresh';
  static const String authForgotPassword = '/auth/forgot-password';
  static const String authResetPassword = '/auth/reset-password';
  static const String authLogout = '/auth/logout';

  // User Endpoints
  static String userProfile(String userId) => '/user/profile/$userId';
  static String updateProfile(String userId) => '/user/profile/$userId';
  static String deleteProfile(String userId) => '/user/profile/$userId';

  // Sensor Endpoints
  static const String sensorsRealtime = '/sensors/realtime';
  static String sensorRealtimeById(String id) => '/sensors/realtime/$id';
  static String dashboard(String userId) => '/dashboard/$userId';
  static const String sensors = '/sensors';
  static String sensorById(String id) => '/sensors/$id';
  static String sensorHistory(String id) => '/sensors/history/$id';
  static const String sensorsNearby = '/sensors/nearby';

  // Forecast Endpoints
  static String sensorForecast(String id) => '/sensors/forecast/$id';
  static String forecastSummary(String userId) => '/forecast/summary/$userId';

  // Alert Endpoints
  static String alerts(String userId) => '/alerts/$userId';
  static String markAlertRead(String alertId) => '/alerts/$alertId/read';
  static String deleteAlert(String alertId) => '/alerts/$alertId';
  static String alertSettings(String userId) => '/alerts/settings/$userId';

  // Chat Endpoints
  static const String chatQuery = '/chat/query';
  static String chatHistory(String userId) => '/chat/history/$userId';
  static String clearChatHistory(String userId) => '/chat/history/$userId';

  // Headers
  static const String headerContentType = 'Content-Type';
  static const String headerAuthorization = 'Authorization';
  static const String headerAccept = 'Accept';

  // Header Values
  static const String contentTypeJson = 'application/json';
  static String bearerToken(String token) => 'Bearer $token';
}
