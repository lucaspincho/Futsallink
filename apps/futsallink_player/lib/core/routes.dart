// Em apps/futsallink_player/lib/core/routes.dart

import 'package:flutter/material.dart';
import 'package:futsallink_core/futsallink_core.dart';
import 'package:futsallink_player/features/auth/presentation/pages/login_page.dart';
import 'package:futsallink_player/features/auth/presentation/pages/email_verification_page.dart';
import 'package:futsallink_player/features/auth/presentation/pages/phone_input_page.dart';
import 'package:futsallink_player/features/auth/presentation/pages/phone_verification_page.dart';
import 'package:futsallink_player/features/auth/presentation/pages/create_password_page.dart';
import 'package:futsallink_player/features/auth/presentation/pages/email_verification_check_page.dart';
import 'package:futsallink_player/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:futsallink_player/features/auth/presentation/pages/forgot_password_email_page.dart';
import 'package:futsallink_player/features/auth/presentation/pages/forgot_password_phone_page.dart';
import 'package:futsallink_player/features/auth/presentation/pages/reset_password_email_confirmation_page.dart';
import 'package:futsallink_player/features/auth/presentation/pages/reset_password_phone_verification_page.dart';
import 'package:futsallink_player/features/auth/presentation/pages/new_password_form_page.dart';
import 'package:futsallink_player/features/home/presentation/pages/home_page.dart';

// Rotas da aplicação
final Map<String, WidgetBuilder> appRoutes = {
  // Autenticação
  '/': (context) => const LoginPage(),
  '/login': (context) => const LoginPage(),
  '/email-verification': (context) => const EmailVerificationPage(),
  '/phone-input': (context) => const PhoneInputPage(),
  '/phone-verification': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return PhoneVerificationPage(
      verificationId: args?['verificationId'] as String,
      phoneNumber: args?['phoneNumber'] as String,
    );
  },
  '/email-verification-check': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as String?;
    return EmailVerificationCheckPage(email: args ?? '');
  },
  '/create-password': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return CreatePasswordPage();
  },
  
  // Rotas para redefinição de senha
  '/forgot-password': (context) => const ForgotPasswordPage(),
  '/forgot-password-email': (context) => const ForgotPasswordEmailPage(),
  '/forgot-password-phone': (context) => const ForgotPasswordPhonePage(),
  '/reset-password-email-confirmation': (context) {
    final email = ModalRoute.of(context)?.settings.arguments as String?;
    return ResetPasswordEmailConfirmationPage(email: email ?? '');
  },
  '/reset-password-phone-verification': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return ResetPasswordPhoneVerificationPage(
      verificationId: args?['verificationId'] as String,
      phoneNumber: args?['phoneNumber'] as String,
    );
  },
  '/new-password-form': (context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return NewPasswordFormPage(
      credential: args?['credential'] as AuthCredential,
    );
  },
  
  // Outras rotas da aplicação
  '/home': (context) => const HomePage(),
  // Adicione outras rotas aqui
};

// Gerenciador de rotas para lidar com rotas que precisam de parâmetros
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (appRoutes.containsKey(settings.name)) {
      return MaterialPageRoute(
        builder: appRoutes[settings.name]!,
        settings: settings,
      );
    }
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('Rota não encontrada: ${settings.name}'),
        ),
      ),
    );
  }
}