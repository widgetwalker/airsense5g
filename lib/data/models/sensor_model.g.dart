// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorModel _$SensorModelFromJson(Map<String, dynamic> json) => SensorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      currentAqi: (json['currentAqi'] as num).toInt(),
      pollutants: (json['pollutants'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      isOnline: json['isOnline'] as bool,
    );

Map<String, dynamic> _$SensorModelToJson(SensorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'currentAqi': instance.currentAqi,
      'pollutants': instance.pollutants,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'isOnline': instance.isOnline,
    };
