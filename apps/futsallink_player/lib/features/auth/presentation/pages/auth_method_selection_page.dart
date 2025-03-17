import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_core/futsallink_core.dart';
import 'package:futsallink_player/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class AuthMethodSelectionPage extends StatelessWidget {
  const AuthMethodSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FutsallinkColors.darkBackground,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthMethodSelectionState) {
            if (state.selectedMethod == AuthMethod.email) {
              Navigator.of(context).pushNamed('/email-verification');
            } else if (state.selectedMethod == AuthMethod.phone) {
              Navigator.of(context).pushNamed('/phone-verification');
            }
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
                    'CRIAÇÃO DE CONTA',
                    style: FutsallinkTypography.headline1.copyWith(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: FutsallinkSpacing.md),
                  Text(
                    'Como você prefere fazer seu cadastro?',
                    style: FutsallinkTypography.headline2.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: FutsallinkSpacing.xl),
                  _buildAuthMethodOption(
                    context: context,
                    icon: Icons.email,
                    title: 'Por e-mail',
                    description: 'Você receberá um e-mail de verificação',
                    method: AuthMethod.email,
                  ),
                  const SizedBox(height: FutsallinkSpacing.md),
                  _buildAuthMethodOption(
                    context: context,
                    icon: Icons.phone_android,
                    title: 'Por telefone',
                    description: 'Você receberá um SMS com código de verificação',
                    method: AuthMethod.phone,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Já tem uma conta? ',
                        style: FutsallinkTypography.headline2.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      CustomLink(
                        text: 'Faça login',
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: FutsallinkSpacing.md),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAuthMethodOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required AuthMethod method,
  }) {
    const borderRadius = 8.0;
    
    return GestureDetector(
      onTap: () {
        context.read<AuthBloc>().add(ChooseAuthMethodEvent(authMethod: method));
      },
      child: Container(
        padding: const EdgeInsets.all(FutsallinkSpacing.md),
        decoration: BoxDecoration(
          color: FutsallinkColors.cardBackground,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: FutsallinkColors.primary.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(FutsallinkSpacing.sm),
              decoration: const BoxDecoration(
                color: FutsallinkColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: FutsallinkSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: FutsallinkTypography.headline2.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: FutsallinkTypography.body2.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: FutsallinkColors.primary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
} 