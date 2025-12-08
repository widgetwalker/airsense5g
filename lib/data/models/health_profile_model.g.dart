// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthProfileModel _$HealthProfileModelFromJson(Map<String, dynamic> json) =>
    HealthProfileModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
      conditions: (json['conditions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      activityLevel: json['activityLevel'] as String,
      sensitivity: (json['sensitivity'] as num).toInt(),
      outdoorHours: (json['outdoorHours'] as num).toDouble(),
      notificationPrefs: NotificationPrefsModel.fromJson(
          json['notificationPrefs'] as Map<String, dynamic>),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$HealthProfileModelToJson(HealthProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'age': instance.age,
      'gender': instance.gender,
      'conditions': instance.conditions,
      'activityLevel': instance.activityLevel,
      'sensitivity': instance.sensitivity,
      'outdoorHours': instance.outdoorHours,
      'notificationPrefs': instance.notificationPrefs,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

NotificationPrefsModel _$NotificationPrefsModelFromJson(
        Map<String, dynamic> json) =>
    NotificationPrefsModel(
      push: json['push'] as bool,
      email: json['email'] as bool,
      sms: json['sms'] as bool,
      alertTypes: (json['alertTypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$NotificationPrefsModelToJson(
        NotificationPrefsModel instance) =>
    <String, dynamic>{
      'push': instance.push,
      'email': instance.email,
      'sms': instance.sms,
      'alertTypes': instance.alertTypes,
    };
