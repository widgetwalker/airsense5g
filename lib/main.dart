import 'package:flutter/material.dart';

import 'package:air_quality_guardian/app/app.dart';
import 'package:air_quality_guardian/core/di/service_locator.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize dependency injection
  await setupServiceLocator();

  // TODO: Initialize Firebase
  // await Firebase.initializeApp();

  runApp(const AirQualityGuardianApp());
}
