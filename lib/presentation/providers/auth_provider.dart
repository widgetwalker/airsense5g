import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:air_quality_guardian/data/models/user_model.dart';
import 'package:air_quality_guardian/data/models/simple_health_profile.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  SimpleHealthProfile? _healthProfile;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;

  // Getters
  UserModel? get currentUser => _currentUser;
  SimpleHealthProfile? get healthProfile => _healthProfile;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize and check if user is logged in
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final authBox = await Hive.openBox('auth');
      final userId = authBox.get('currentUserId');

      if (userId != null) {
        final usersBox = await Hive.openBox('users');
        final userData = usersBox.get(userId);

        if (userData != null) {
          _currentUser =
              UserModel.fromJson(Map<String, dynamic>.from(userData));
          _isAuthenticated = true;

          // Load health profile
          final profilesBox = await Hive.openBox('health_profiles');
          final profileData = profilesBox.get(userId);
          if (profileData != null) {
            _healthProfile = SimpleHealthProfile.fromJson(
                Map<String, dynamic>.from(profileData),);
          }
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Sign up
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final usersBox = await Hive.openBox('users');

      // Check if email already exists
      final existingUser = usersBox.values.firstWhere(
        (user) => user['email'] == email,
        orElse: () => null,
      );

      if (existingUser != null) {
        _error = 'Email already registered';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Create new user
      final userId = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();
      final newUser = UserModel(
        id: userId,
        name: name,
        email: email,
        createdAt: now,
        updatedAt: now,
        isVerified: false,
      );

      // Store user data
      await usersBox.put(userId, {
        ...newUser.toJson(),
        'password': password, // In production, hash this!
      });

      // Store current user ID
      final authBox = await Hive.openBox('auth');
      await authBox.put('currentUserId', userId);

      _currentUser = newUser;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final usersBox = await Hive.openBox('users');

      // Find user by email
      String? userId;
      Map<String, dynamic>? userData;

      for (var key in usersBox.keys) {
        final user = Map<String, dynamic>.from(usersBox.get(key));
        if (user['email'] == email) {
          userId = key.toString();
          userData = user;
          break;
        }
      }

      if (userData == null) {
        _error = 'Email not found';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Check password
      if (userData['password'] != password) {
        _error = 'Incorrect password';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Store current user ID
      final authBox = await Hive.openBox('auth');
      await authBox.put('currentUserId', userId);

      _currentUser = UserModel.fromJson(userData);
      _isAuthenticated = true;

      // Load health profile
      final profilesBox = await Hive.openBox('health_profiles');
      final profileData = profilesBox.get(userId);
      if (profileData != null) {
        _healthProfile = SimpleHealthProfile.fromJson(
            Map<String, dynamic>.from(profileData),);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Save health profile
  Future<bool> saveHealthProfile(SimpleHealthProfile profile) async {
    if (_currentUser == null) return false;

    try {
      final profilesBox = await Hive.openBox('health_profiles');
      await profilesBox.put(_currentUser!.id, profile.toJson());
      _healthProfile = profile;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    final authBox = await Hive.openBox('auth');
    await authBox.delete('currentUserId');

    _currentUser = null;
    _healthProfile = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // Update profile picture
  Future<bool> updateProfilePicture(XFile file) async {
    if (_currentUser == null) return false;

    try {
      final usersBox = await Hive.openBox('users');
      final userData =
          Map<String, dynamic>.from(usersBox.get(_currentUser!.id));

      // Convert image to base64 for cross-platform storage
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);

      userData['profilePicture'] = base64Image;
      userData['updatedAt'] = DateTime.now().toIso8601String();

      await usersBox.put(_currentUser!.id, userData);

      _currentUser = UserModel.fromJson(userData);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
