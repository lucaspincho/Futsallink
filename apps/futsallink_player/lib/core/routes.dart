import 'package:flutter/material.dart';
import '../features/auth/presentation/pages/phone_auth_screen.dart';
import '../features/auth/presentation/pages/otp_verification_screen.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/email_auth_screen.dart';
import '../features/auth/presentation/pages/verify_email_screen.dart';
import '../features/auth/presentation/pages/create_password_screen.dart';
import '../features/profile/presentation/pages/profile_name_screen.dart';
import '../features/profile/presentation/pages/profile_age_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String phoneAuth = '/phone-auth';
  static const String otpVerification = '/otp-verification';
  static const String emailAuth = '/email-auth';
  static const String verifyEmail = '/verify-email';
  static const String createPassword = '/create-password';
  static const String profileName = '/profile-name';
  static const String profileAge = '/profile-age';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return _materialRoute(LoginScreen()); // ❌ Removido o 'const'

      case phoneAuth:
        return _materialRoute(PhoneAuthScreen()); // ❌ Removido o 'const'

      case otpVerification:
        if (settings.arguments is String) {
          return _materialRoute(
            OTPVerificationScreen(verificationId: settings.arguments as String),
          );
        }
        return _errorRoute();

      case emailAuth:
        return _materialRoute(EmailAuthScreen()); // ❌ Removido o 'const'

      case verifyEmail:
        if (settings.arguments is String) {
          return _materialRoute(
            VerifyEmailScreen(email: settings.arguments as String),
          );
        }
        return _errorRoute();

      case createPassword:
        if (settings.arguments is String) {
          return _materialRoute(
            CreatePasswordScreen(email: settings.arguments as String),
          );
        }
        return _errorRoute();

      case profileName:
        return _materialRoute(ProfileNameScreen()); // ❌ Removido o 'const'

      case profileAge:
        return _materialRoute(ProfileAgeScreen()); // ❌ Removido o 'const'

      default:
        return _errorRoute();
    }
  }

  static MaterialPageRoute _materialRoute(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text(
            "Rota não encontrada",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
