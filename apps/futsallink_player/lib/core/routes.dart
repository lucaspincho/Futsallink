// Em apps/futsallink_player/lib/core/routes.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:futsallink_player/features/profile/presentation/pages/profile_creation_page.dart';
import 'package:futsallink_player/core/di/injection_container.dart';
import 'package:futsallink_player/features/home/presentation/cubit/home_cubit.dart';
import 'package:futsallink_player/features/tryouts/presentation/pages/tryout_details_screen.dart';
import 'package:futsallink_player/features/tryouts/presentation/bloc/tryout_details_cubit.dart';
import 'package:futsallink_player/features/tryouts/data/repositories/tryout_repository_impl.dart';
import 'package:futsallink_player/features/tryouts/domain/repositories/tryout_repository.dart';
import 'package:futsallink_player/features/clubs/presentation/pages/club_details_screen.dart';
import 'package:futsallink_player/features/clubs/presentation/bloc/club_details_cubit.dart';
import 'package:futsallink_player/features/clubs/data/repositories/club_repository_impl.dart';
import 'package:futsallink_player/features/clubs/domain/repositories/club_repository.dart';
import 'package:futsallink_player/features/clubs/presentation/pages/clubs_screen.dart';
import 'package:futsallink_player/features/clubs/presentation/bloc/clubs_cubit.dart';
import 'package:futsallink_player/features/home/domain/repositories/home_repository.dart';
import 'package:futsallink_player/features/home/data/repositories/home_repository_impl.dart';

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
  
  // Criação de Perfil
  '/profile/create': (context) {
    // Adicionar logs para verificar se a rota está sendo chamada
    print('[AppRouter] Rota /profile/create chamada');
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print('[AppRouter] Argumentos: $args');
    return ProfileCreationPage(
      user: args?['user'] as User?,
      lastCompletedStep: args?['lastCompletedStep'] as int? ?? 0,
    );
  },
  '/profile/complete': (context) {
    // Adicionar logs para verificar se a rota está sendo chamada
    print('[AppRouter] Rota /profile/complete chamada');
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print('[AppRouter] Argumentos: $args');
    return ProfileCreationPage(
      user: args?['user'] as User?,
      lastCompletedStep: args?['lastCompletedStep'] as int? ?? 0,
    );
  },
  '/profile-creation': (context) {
    // Manter compatibilidade com rota antiga, mas adicionar logs
    print('[AppRouter] Rota /profile-creation chamada (compatibilidade)');
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print('[AppRouter] Argumentos: $args');
    return ProfileCreationPage(
      user: args?['user'] as User?,
      lastCompletedStep: args?['lastCompletedStep'] as int? ?? 0,
    );
  },
  
  // Outras rotas da aplicação
  '/home': (context) => BlocProvider<HomeCubit>(
    create: (context) => sl<HomeCubit>(),
    child: const HomePage(),
  ),
  
  // Detalhes da seletiva
  '/tryout-details': (context) {
    final tryoutId = ModalRoute.of(context)?.settings.arguments as String;
    
    // Repositório para carregar detalhes da seletiva
    final tryoutRepository = TryoutRepositoryImpl();
    
    return BlocProvider<TryoutDetailsCubit>(
      create: (context) => TryoutDetailsCubit(tryoutRepository),
      child: TryoutDetailsScreen(tryoutId: tryoutId),
    );
  },
  
  // Detalhes do clube
  '/club-details': (context) {
    final clubId = ModalRoute.of(context)?.settings.arguments as String;
    
    // Repositório para carregar detalhes do clube
    final clubRepository = ClubRepositoryImpl();
    
    return BlocProvider<ClubDetailsCubit>(
      create: (context) => ClubDetailsCubit(clubRepository),
      child: ClubDetailsScreen(clubId: clubId),
    );
  },
  
  // Lista de Clubes
  '/clubs': (context) {
    return BlocProvider<ClubsCubit>(
      create: (context) => ClubsCubit(HomeRepositoryImpl()),
      child: const ClubsScreen(),
    );
  },
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