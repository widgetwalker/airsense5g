import 'package:json_annotation/json_annotation.dart';
import 'package:air_quality_guardian/domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.createdAt,
    required super.updatedAt,
    required super.isVerified,
    super.fcmToken,
    super.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      isVerified: user.isVerified,
      fcmToken: user.fcmToken,
      profilePicture: user.profilePicture,
    );
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isVerified: isVerified,
      fcmToken: fcmToken,
      profilePicture: profilePicture,
    );
  }
}
