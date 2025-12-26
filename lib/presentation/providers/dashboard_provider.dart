import 'package:flutter/material.dart';
import 'package:air_quality_guardian/domain/entities/sensor.dart';
import 'package:air_quality_guardian/core/utils/aqi_utils.dart';
import 'package:dio/dio.dart';

class DashboardProvider with ChangeNotifier {
  Sensor? _currentSensor;
  bool _isLoading = false;
  String? _error;
  List<String> _healthConditions = [];
  int _sensitivity = 3;

  // Getters
  Sensor? get currentSensor => _currentSensor;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get healthConditions => _healthConditions;
  int get sensitivity => _sensitivity;

  // Computed properties
  String get aqiCategory {
    if (_currentSensor == null) return 'Unknown';
    return AqiUtils.getAqiCategory(_currentSensor!.currentAqi);
  }

  Color get aqiColor {
    if (_currentSensor == null) return Colors.grey;
    return AqiUtils.getAqiColor(_currentSensor!.currentAqi);
  }

  String get riskLevel {
    if (_currentSensor == null) return 'Unknown';
    return AqiUtils.calculateRiskLevel(
      aqi: _currentSensor!.currentAqi,
      healthConditions: _healthConditions,
      sensitivity: _sensitivity,
    );
  }

  Color get riskColor {
    return AqiUtils.getRiskColor(riskLevel);
  }

  List<String> get healthSuggestions {
    if (_currentSensor == null) return [];
    return AqiUtils.getHealthSuggestions(
      aqi: _currentSensor!.currentAqi,
      healthConditions: _healthConditions,
      riskLevel: riskLevel,
    );
  }

  // Set user health profile
  void setHealthProfile(List<String> conditions, int sensitivity) {
    _healthConditions = conditions;
    _sensitivity = sensitivity;
    notifyListeners();
  }

  // Fetch dashboard data
  Future<void> fetchDashboardData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final dio = Dio();
      // connecting to localhost (change to 10.0.2.2 for Android Emulator)
      final response = await dio.get('http://localhost:5000/api/data');
      
      Map<String, dynamic> data = {};
      if (response.statusCode == 200) {
        data = response.data;
      }

      // Safe parsing helpers
      double getDouble(String key) {
        if (data[key] == null) return 0.0;
        return double.tryParse(data[key].toString()) ?? 0.0;
      }
      
      int getInt(String key) {
         if (data[key] == null) return 0;
         return int.tryParse(data[key].toString()) ?? 0;
      }

      // If data is empty (no connection yet), keep defaults or show empty
      // But we will try to fill from API response
      
      _currentSensor = Sensor(
        id: '1',
        name: 'Sensor 3 (Live)',
        latitude: 28.6139,
        longitude: 77.2090,
        address: 'Live MQTT Location',
        currentAqi: getInt('aqi') > 0 ? getInt('aqi') : 0, // AQI from payload or calculate?
        pollutants: {
          'PM2.5': getDouble('pm2_5'),
          'PM10': getDouble('pm10'),
          'CO2': getDouble('co2'),
          'TVOC': getDouble('tvoc'),
          'Humidity': getDouble('humidity'),
          'Temp': getDouble('temperature'),
        },
        lastUpdated: DateTime.now(),
        isOnline: true,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh data
  Future<void> refresh() async {
    await fetchDashboardData();
  }
}
