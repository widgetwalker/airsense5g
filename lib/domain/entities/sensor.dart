import 'package:equatable/equatable.dart';

class Sensor extends Equatable {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final int currentAqi;
  final Map<String, double> pollutants;
  final DateTime lastUpdated;
  final bool isOnline;

  const Sensor({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.currentAqi,
    required this.pollutants,
    required this.lastUpdated,
    required this.isOnline,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        latitude,
        longitude,
        address,
        currentAqi,
        pollutants,
        lastUpdated,
        isOnline,
      ];

  Sensor copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    String? address,
    int? currentAqi,
    Map<String, double>? pollutants,
    DateTime? lastUpdated,
    bool? isOnline,
  }) {
    return Sensor(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      currentAqi: currentAqi ?? this.currentAqi,
      pollutants: pollutants ?? this.pollutants,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
