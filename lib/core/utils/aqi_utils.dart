import 'package:flutter/material.dart';
import 'package:air_quality_guardian/core/constants/aqi_constants.dart';

class AqiUtils {
  AqiUtils._();

  /// Get AQI category based on AQI value
  static String getAqiCategory(int aqi) {
    if (aqi <= AqiConstants.goodMax) {
      return AqiConstants.categoryGood;
    } else if (aqi <= AqiConstants.moderateMax) {
      return AqiConstants.categoryModerate;
    } else if (aqi <= AqiConstants.unhealthySensitiveMax) {
      return AqiConstants.categoryUnhealthySensitive;
    } else if (aqi <= AqiConstants.unhealthyMax) {
      return AqiConstants.categoryUnhealthy;
    } else if (aqi <= AqiConstants.veryUnhealthyMax) {
      return AqiConstants.categoryVeryUnhealthy;
    } else {
      return AqiConstants.categoryHazardous;
    }
  }

  /// Get color for AQI value
  static Color getAqiColor(int aqi) {
    if (aqi <= AqiConstants.goodMax) {
      return AqiConstants.colorGood;
    } else if (aqi <= AqiConstants.moderateMax) {
      return AqiConstants.colorModerate;
    } else if (aqi <= AqiConstants.unhealthySensitiveMax) {
      return AqiConstants.colorUnhealthySensitive;
    } else if (aqi <= AqiConstants.unhealthyMax) {
      return AqiConstants.colorUnhealthy;
    } else if (aqi <= AqiConstants.veryUnhealthyMax) {
      return AqiConstants.colorVeryUnhealthy;
    } else {
      return AqiConstants.colorHazardous;
    }
  }

  /// Calculate risk level based on AQI and user health profile
  static String calculateRiskLevel({
    required int aqi,
    required List<String> healthConditions,
    required int sensitivity,
  }) {
    // Base risk from AQI
    int baseRisk = 0;
    if (aqi <= AqiConstants.goodMax) {
      baseRisk = 1;
    } else if (aqi <= AqiConstants.moderateMax) {
      baseRisk = 2;
    } else if (aqi <= AqiConstants.unhealthySensitiveMax) {
      baseRisk = 3;
    } else if (aqi <= AqiConstants.unhealthyMax) {
      baseRisk = 4;
    } else {
      baseRisk = 5;
    }

    // Adjust for health conditions
    final hasConditions = healthConditions.any((condition) =>
        condition != AqiConstants.conditionNone,);
    
    if (hasConditions && baseRisk >= 2) {
      baseRisk += 1;
    }

    // Adjust for sensitivity
    if (sensitivity >= 4 && baseRisk >= 2) {
      baseRisk += 1;
    }

    // Map to risk level
    if (baseRisk <= 2) {
      return AqiConstants.riskLow;
    } else if (baseRisk <= 4) {
      return AqiConstants.riskMedium;
    } else if (baseRisk <= 6) {
      return AqiConstants.riskHigh;
    } else {
      return AqiConstants.riskSevere;
    }
  }

  /// Get health suggestions based on AQI and health profile
  static List<String> getHealthSuggestions({
    required int aqi,
    required List<String> healthConditions,
    required String riskLevel,
  }) {
    final suggestions = <String>[];

    if (aqi <= AqiConstants.goodMax) {
      suggestions.add('Air quality is good. Enjoy outdoor activities!');
      suggestions.add('Perfect time for exercise and outdoor play.');
    } else if (aqi <= AqiConstants.moderateMax) {
      suggestions.add('Air quality is acceptable for most people.');
      if (healthConditions.contains(AqiConstants.conditionAsthma) ||
          healthConditions.contains(AqiConstants.conditionCOPD)) {
        suggestions.add('Consider reducing prolonged outdoor exertion if you have respiratory issues.');
      }
      suggestions.add('Sensitive individuals should monitor symptoms.');
    } else if (aqi <= AqiConstants.unhealthySensitiveMax) {
      suggestions.add('Wear N95 mask if going outside.');
      suggestions.add('Limit prolonged outdoor activities.');
      if (healthConditions.contains(AqiConstants.conditionAsthma)) {
        suggestions.add('Keep your inhaler handy.');
      }
      suggestions.add('Close windows and use air purifier indoors.');
    } else if (aqi <= AqiConstants.unhealthyMax) {
      suggestions.add('Avoid outdoor activities.');
      suggestions.add('Wear N95 mask if you must go outside.');
      suggestions.add('Keep windows closed and use air purifier.');
      suggestions.add('Monitor health symptoms closely.');
      if (healthConditions.contains(AqiConstants.conditionHeartDisease)) {
        suggestions.add('Consult your doctor if experiencing symptoms.');
      }
    } else {
      suggestions.add('Stay indoors with windows closed.');
      suggestions.add('Use air purifier on high setting.');
      suggestions.add('Avoid all outdoor activities.');
      suggestions.add('Wear N95 mask even for brief outdoor exposure.');
      suggestions.add('Seek medical attention if experiencing symptoms.');
    }

    return suggestions.take(5).toList();
  }

  /// Get pollutant status compared to WHO guidelines
  static String getPollutantStatus(String pollutant, double value) {
    double guideline;
    
    switch (pollutant) {
      case AqiConstants.pollutantPM25:
        guideline = AqiConstants.whoGuidelinePM25;
        break;
      case AqiConstants.pollutantPM10:
        guideline = AqiConstants.whoGuidelinePM10;
        break;
      case AqiConstants.pollutantO3:
        guideline = AqiConstants.whoGuidelineO3;
        break;
      case AqiConstants.pollutantNO2:
        guideline = AqiConstants.whoGuidelineNO2;
        break;
      case AqiConstants.pollutantSO2:
        guideline = AqiConstants.whoGuidelineSO2;
        break;
      case AqiConstants.pollutantCO:
        guideline = AqiConstants.whoGuidelineCO;
        break;
      default:
        return 'unknown';
    }

    if (value <= guideline) {
      return 'good';
    } else if (value <= guideline * 2) {
      return 'moderate';
    } else {
      return 'unhealthy';
    }
  }

  /// Get icon for AQI category
  static IconData getAqiIcon(int aqi) {
    if (aqi <= AqiConstants.goodMax) {
      return Icons.sentiment_very_satisfied;
    } else if (aqi <= AqiConstants.moderateMax) {
      return Icons.sentiment_satisfied;
    } else if (aqi <= AqiConstants.unhealthySensitiveMax) {
      return Icons.sentiment_neutral;
    } else if (aqi <= AqiConstants.unhealthyMax) {
      return Icons.sentiment_dissatisfied;
    } else {
      return Icons.sentiment_very_dissatisfied;
    }
  }

  /// Get risk color
  static Color getRiskColor(String riskLevel) {
    switch (riskLevel) {
      case AqiConstants.riskLow:
        return AqiConstants.colorGood;
      case AqiConstants.riskMedium:
        return AqiConstants.colorModerate;
      case AqiConstants.riskHigh:
        return AqiConstants.colorUnhealthy;
      case AqiConstants.riskSevere:
        return AqiConstants.colorHazardous;
      default:
        return Colors.grey;
    }
  }
}
