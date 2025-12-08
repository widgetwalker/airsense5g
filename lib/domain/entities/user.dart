import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isVerified;
  final String? fcmToken;
  final String? profilePicture;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.isVerified,
    this.fcmToken,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        createdAt,
        updatedAt,
        isVerified,
        fcmToken,
        profilePicture,
      ];

  User copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    String? fcmToken,
    String? profilePicture,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      fcmToken: fcmToken ?? this.fcmToken,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}
