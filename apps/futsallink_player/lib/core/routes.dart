// Em apps/futsallink_player/lib/core/routes.dart

import 'package:flutter/material.dart';
import 'package:futsallink_player/features/auth/presentation/pages/auth_method_page.dart';
import 'package:futsallink_player/features/auth/presentation/pages/login_page.dart';
import 'package:futsallink_player/features/auth/presentation/pages/register_page.dart';

// Rotas da aplicação
final Map<String, WidgetBuilder> appRoutes = {
  // Autenticação
  '/': (context) => const AuthMethodPage(),
  '/auth-method': (context) => const AuthMethodPage(),
  '/login': (context) => const LoginPage(),
  '/phone-verification': (context) => const RegisterPage(),
  
  // Outras rotas da aplicação
  '/home': (context) => const Scaffold(body: Center(child: Text('Home Page'))),
  // Adicione outras rotas aqui
};

// Páginas temporárias para compilação
class VerificationCodePage extends StatelessWidget {
  final String verificationId;
  final String phoneNumber;
  
  const VerificationCodePage({Key? key, required this.verificationId, required this.phoneNumber}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Página de Verificação de Código - $phoneNumber'),
      ),
    );
  }
}

class CreatePasswordPage extends StatelessWidget {
  final String phoneNumber;
  
  const CreatePasswordPage({Key? key, required this.phoneNumber}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Página de Criação de Senha - $phoneNumber'),
      ),
    );
  }
}

// Gerenciador de rotas para lidar com rotas que precisam de parâmetros
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/verification-code':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => VerificationCodePage(
            verificationId: args['verificationId'],
            phoneNumber: args['phoneNumber'],
          ),
        );
        
      case '/create-password':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => CreatePasswordPage(
            phoneNumber: args['phoneNumber'],
          ),
        );
        
      default:
        if (appRoutes.containsKey(settings.name)) {
          return MaterialPageRoute(
            builder: appRoutes[settings.name]!,
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
}