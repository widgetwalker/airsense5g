import 'package:flutter/material.dart';

import 'package:air_quality_guardian/app/app.dart';
import 'package:air_quality_guardian/core/di/service_locator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:air_quality_guardian/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize dependency injection
  await setupServiceLocator();

  // Initialize AuthProvider to ensure persistence
  final authProvider = AuthProvider();
  await authProvider.initialize();

  runApp(AirQualityGuardianApp(initialAuthProvider: authProvider));
}
