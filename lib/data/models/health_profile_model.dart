import 'package:json_annotation/json_annotation.dart';

part 'health_profile_model.g.dart';

@JsonSerializable()
class HealthProfileModel {
  final String id;
  final String userId;
  final int age;
  final String gender;
  final List<String> conditions;
  final String activityLevel;
  final int sensitivity;
  final double outdoorHours;
  final NotificationPrefsModel notificationPrefs;
  final DateTime updatedAt;

  const HealthProfileModel({
    required this.id,
    required this.userId,
    required this.age,
    required this.gender,
    required this.conditions,
    required this.activityLevel,
    required this.sensitivity,
    required this.outdoorHours,
    required this.notificationPrefs,
    required this.updatedAt,
  });

  factory HealthProfileModel.fromJson(Map<String, dynamic> json) =>
      _$HealthProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$HealthProfileModelToJson(this);
}

@JsonSerializable()
class NotificationPrefsModel {
  final bool push;
  final bool email;
  final bool sms;
  final List<String> alertTypes;

  const NotificationPrefsModel({
    required this.push,
    required this.email,
    required this.sms,
    required this.alertTypes,
  });

  factory NotificationPrefsModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationPrefsModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationPrefsModelToJson(this);
}
