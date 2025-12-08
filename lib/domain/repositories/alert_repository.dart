import 'package:air_quality_guardian/domain/entities/alert.dart';

abstract class AlertRepository {
  /// Get alerts for user
  Future<List<Alert>> getAlerts(String userId);

  /// Mark alert as read
  Future<void> markAlertAsRead(String alertId);

  /// Delete alert
  Future<void> deleteAlert(String alertId);

  /// Update alert settings
  Future<void> updateAlertSettings({
    required String userId,
    required Map<String, dynamic> settings,
  });

  /// Get alert settings
  Future<Map<String, dynamic>> getAlertSettings(String userId);
}
