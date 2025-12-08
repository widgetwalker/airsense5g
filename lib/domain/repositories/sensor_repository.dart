import 'package:air_quality_guardian/domain/entities/sensor.dart';

abstract class SensorRepository {
  /// Get all sensors
  Future<List<Sensor>> getSensors();

  /// Get sensor by ID
  Future<Sensor> getSensorById(String id);

  /// Get realtime data for all sensors
  Future<List<Sensor>> getRealtimeSensors();

  /// Get realtime data for specific sensor
  Future<Sensor> getRealtimeSensorById(String id);

  /// Get sensors near a location
  Future<List<Sensor>> getSensorsNearby({
    required double latitude,
    required double longitude,
    required double radius,
  });

  /// Get sensor history
  Future<List<Map<String, dynamic>>> getSensorHistory({
    required String sensorId,
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get forecast for sensor
  Future<Map<String, dynamic>> getSensorForecast(String sensorId);

  /// Get personalized dashboard data
  Future<Map<String, dynamic>> getDashboardData(String userId);

  /// Get personalized forecast summary
  Future<Map<String, dynamic>> getForecastSummary(String userId);
}
