import 'package:flutter/material.dart';

class AqiConstants {
  AqiConstants._();

  // AQI Categories
  static const String categoryGood = 'Good';
  static const String categoryModerate = 'Moderate';
  static const String categoryUnhealthySensitive = 'Unhealthy for Sensitive';
  static const String categoryUnhealthy = 'Unhealthy';
  static const String categoryVeryUnhealthy = 'Very Unhealthy';
  static const String categoryHazardous = 'Hazardous';

  // AQI Breakpoints
  static const int goodMax = 50;
  static const int moderateMax = 100;
  static const int unhealthySensitiveMax = 150;
  static const int unhealthyMax = 200;
  static const int veryUnhealthyMax = 300;
  static const int hazardousMax = 500;

  // AQI Colors
  static const Color colorGood = Color(0xFF43A047);
  static const Color colorModerate = Color(0xFFFFEB3B);
  static const Color colorUnhealthySensitive = Color(0xFFFB8C00);
  static const Color colorUnhealthy = Color(0xFFE53935);
  static const Color colorVeryUnhealthy = Color(0xFF8E24AA);
  static const Color colorHazardous = Color(0xFF6D1B1B);

  // Risk Levels
  static const String riskLow = 'Low';
  static const String riskMedium = 'Medium';
  static const String riskHigh = 'High';
  static const String riskSevere = 'Severe';

  // Pollutant Names
  static const String pollutantPM25 = 'PM2.5';
  static const String pollutantPM10 = 'PM10';
  static const String pollutantO3 = 'O3';
  static const String pollutantNO2 = 'NO2';
  static const String pollutantSO2 = 'SO2';
  static const String pollutantCO = 'CO';

  // WHO Guidelines (µg/m³ for PM, ppb for gases)
  static const double whoGuidelinePM25 = 15.0;
  static const double whoGuidelinePM10 = 45.0;
  static const double whoGuidelineO3 = 100.0;
  static const double whoGuidelineNO2 = 40.0;
  static const double whoGuidelineSO2 = 40.0;
  static const double whoGuidelineCO = 4.0;

  // Health Conditions
  static const String conditionAsthma = 'Asthma';
  static const String conditionCOPD = 'COPD';
  static const String conditionHeartDisease = 'Heart Disease';
  static const String conditionAllergies = 'Allergies';
  static const String conditionDiabetes = 'Diabetes';
  static const String conditionNone = 'None';

  // Activity Levels
  static const String activitySedentary = 'Sedentary';
  static const String activityLight = 'Light';
  static const String activityModerate = 'Moderate';
  static const String activityActive = 'Active';
  static const String activityVeryActive = 'Very Active';

  // Alert Types
  static const String alertTypeThreshold = 'threshold';
  static const String alertTypeSpike = 'spike';
  static const String alertTypeForecast = 'forecast';
  static const String alertTypeRecovery = 'recovery';
  static const String alertTypeDaily = 'daily';

  // Alert Severities
  static const String severityInfo = 'info';
  static const String severityWarning = 'warning';
  static const String severityCritical = 'critical';
}
