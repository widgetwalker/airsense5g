import 'package:flutter/material.dart';
import 'package:air_quality_guardian/domain/entities/sensor.dart';
import 'package:air_quality_guardian/core/utils/aqi_utils.dart';

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
      // TODO: Implement actual API call
      // For now, using mock data
      await Future.delayed(const Duration(seconds: 1));

      _currentSensor = Sensor(
        id: '1',
        name: 'Downtown Area',
        latitude: 28.6139,
        longitude: 77.2090,
        address: 'Connaught Place, New Delhi',
        currentAqi: 156,
        pollutants: const {
          'PM2.5': 85.0,
          'PM10': 120.0,
          'O3': 45.0,
          'NO2': 38.0,
          'SO2': 12.0,
          'CO': 2.5,
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
