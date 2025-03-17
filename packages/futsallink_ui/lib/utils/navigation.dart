import 'package:flutter/material.dart';

class FutsallinkRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String chat = '/chat';
  static const String clubDetails = '/club-details';
}

// Exemplo de página base para simplicidade no código
class FutsallinkPageWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showBackButton;
  
  const FutsallinkPageWrapper({
    Key? key,
    required this.title,
    required this.child,
    this.showBackButton = true,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 24),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        leading: showBackButton 
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );
  }
}