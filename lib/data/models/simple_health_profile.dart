class SimpleHealthProfile {
  final int age;
  final String gender;
  final List<String> healthConditions;
  final String activityLevel;
  final int pollutionSensitivity;
  final double? outdoorHoursPerDay;
  final Map<String, bool> notificationPreferences;

  SimpleHealthProfile({
    required this.age,
    required this.gender,
    required this.healthConditions,
    required this.activityLevel,
    required this.pollutionSensitivity,
    required this.notificationPreferences, this.outdoorHoursPerDay,
  });

  Map<String, dynamic> toJson() => {
        'age': age,
        'gender': gender,
        'healthConditions': healthConditions,
        'activityLevel': activityLevel,
        'pollutionSensitivity': pollutionSensitivity,
        'outdoorHoursPerDay': outdoorHoursPerDay,
        'notificationPreferences': notificationPreferences,
      };

  factory SimpleHealthProfile.fromJson(Map<String, dynamic> json) {
    return SimpleHealthProfile(
      age: json['age'] as int,
      gender: json['gender'] as String,
      healthConditions: List<String>.from(json['healthConditions'] as List),
      activityLevel: json['activityLevel'] as String,
      pollutionSensitivity: json['pollutionSensitivity'] as int,
      outdoorHoursPerDay: json['outdoorHoursPerDay'] as double?,
      notificationPreferences:
          Map<String, bool>.from(json['notificationPreferences'] as Map),
    );
  }
}
