import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:air_quality_guardian/app/theme.dart';
import 'package:air_quality_guardian/app/routes.dart';
import 'package:air_quality_guardian/presentation/providers/dashboard_provider.dart';
import 'package:air_quality_guardian/presentation/providers/auth_provider.dart';

class AirQualityGuardianApp extends StatelessWidget {
  final AuthProvider? initialAuthProvider;

  const AirQualityGuardianApp({
    super.key, 
    this.initialAuthProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => initialAuthProvider ?? (AuthProvider()..initialize()),
        ),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: MaterialApp(
        title: 'Air Quality Guardian',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
