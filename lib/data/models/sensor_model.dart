import 'package:json_annotation/json_annotation.dart';
import 'package:air_quality_guardian/domain/entities/sensor.dart';

part 'sensor_model.g.dart';

@JsonSerializable()
class SensorModel extends Sensor {
  const SensorModel({
    required super.id,
    required super.name,
    required super.latitude,
    required super.longitude,
    required super.address,
    required super.currentAqi,
    required super.pollutants,
    required super.lastUpdated,
    required super.isOnline,
  });

  factory SensorModel.fromJson(Map<String, dynamic> json) =>
      _$SensorModelFromJson(json);

  Map<String, dynamic> toJson() => _$SensorModelToJson(this);

  factory SensorModel.fromEntity(Sensor sensor) {
    return SensorModel(
      id: sensor.id,
      name: sensor.name,
      latitude: sensor.latitude,
      longitude: sensor.longitude,
      address: sensor.address,
      currentAqi: sensor.currentAqi,
      pollutants: sensor.pollutants,
      lastUpdated: sensor.lastUpdated,
      isOnline: sensor.isOnline,
    );
  }

  Sensor toEntity() {
    return Sensor(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      address: address,
      currentAqi: currentAqi,
      pollutants: pollutants,
      lastUpdated: lastUpdated,
      isOnline: isOnline,
    );
  }
}
