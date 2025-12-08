import 'package:equatable/equatable.dart';

class Alert extends Equatable {
  final String id;
  final String userId;
  final String type;
  final String severity;
  final String title;
  final String message;
  final String? sensorId;
  final int? aqiValue;
  final DateTime timestamp;
  final bool isRead;
  final String? deepLink;

  const Alert({
    required this.id,
    required this.userId,
    required this.type,
    required this.severity,
    required this.title,
    required this.message,
    required this.timestamp, required this.isRead, this.sensorId,
    this.aqiValue,
    this.deepLink,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        severity,
        title,
        message,
        sensorId,
        aqiValue,
        timestamp,
        isRead,
        deepLink,
      ];

  Alert copyWith({
    String? id,
    String? userId,
    String? type,
    String? severity,
    String? title,
    String? message,
    String? sensorId,
    int? aqiValue,
    DateTime? timestamp,
    bool? isRead,
    String? deepLink,
  }) {
    return Alert(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      title: title ?? this.title,
      message: message ?? this.message,
      sensorId: sensorId ?? this.sensorId,
      aqiValue: aqiValue ?? this.aqiValue,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      deepLink: deepLink ?? this.deepLink,
    );
  }
}
