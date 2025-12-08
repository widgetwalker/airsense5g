import 'package:air_quality_guardian/domain/entities/user.dart';

abstract class AuthRepository {
  /// Login with email and password
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
  });

  /// Logout current user
  Future<void> logout();

  /// Refresh authentication token
  Future<String> refreshToken(String refreshToken);

  /// Request password reset
  Future<void> forgotPassword(String email);

  /// Reset password with OTP
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  /// Get current user
  Future<User?> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();
}
