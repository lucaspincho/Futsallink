import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FutsallinkColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(FutsallinkSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: FutsallinkSpacing.lg),
                  const CustomLogoHeader(),
                  const SizedBox(height: FutsallinkSpacing.xl),
                  Text(
                    'ESQUECEU SUA SENHA?',
                    style: FutsallinkTypography.headline1.copyWith(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Como você deseja receber o código de redefinição?',
                    style: FutsallinkTypography.headline2.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: FutsallinkSpacing.xl * 2),
                  PrimaryButton(
                    text: 'REDEFINIR VIA EMAIL',
                    onPressed: () {
                      Navigator.of(context).pushNamed('/forgot-password-email');
                    },
                  ),
                  const SizedBox(height: FutsallinkSpacing.md),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/forgot-password-phone');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.white,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'REDEFINIR VIA SMS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: FutsallinkSpacing.xl * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Lembrou sua senha? ',
                        style: FutsallinkTypography.headline2.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      CustomLink(
                        text: 'Faça login',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 