import 'package:flutter/material.dart';
import 'package:air_quality_guardian/presentation/screens/splash/splash_screen.dart';
import 'package:air_quality_guardian/presentation/screens/auth/login_screen.dart';
import 'package:air_quality_guardian/presentation/screens/auth/signup_screen.dart';
import 'package:air_quality_guardian/presentation/screens/main_navigation.dart';
import 'package:air_quality_guardian/presentation/screens/profile/profile_screen.dart';
import 'package:air_quality_guardian/presentation/screens/profile/health_form_screen.dart';
import 'package:air_quality_guardian/presentation/screens/settings/settings_screen.dart';

class AppRoutes {
  AppRoutes._();

  // Route names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String map = '/map';
  static const String forecast = '/forecast';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String healthForm = '/health-form';
  static const String settings = '/settings';

  // Route generator
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const MainNavigation());

      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      case '/health-form':
        return MaterialPageRoute(builder: (_) => const HealthFormScreen());

      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
