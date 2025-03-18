import 'package:flutter/material.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class ResetPasswordEmailConfirmationPage extends StatelessWidget {
  final String email;
  
  const ResetPasswordEmailConfirmationPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FutsallinkColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).popUntil(
            (route) => route.settings.name == '/login',
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(FutsallinkSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.mark_email_read,
                size: 80,
                color: FutsallinkColors.primary,
              ),
              const SizedBox(height: FutsallinkSpacing.xl),
              Text(
                'Email Enviado!',
                style: FutsallinkTypography.headline1.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FutsallinkSpacing.md),
              Text(
                'Instruções de redefinição de senha foram enviadas para:',
                style: FutsallinkTypography.body1.copyWith(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FutsallinkSpacing.sm),
              Text(
                email,
                style: FutsallinkTypography.body1.copyWith(
                  color: FutsallinkColors.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FutsallinkSpacing.xl),
              Text(
                'Verifique sua caixa de entrada e siga as instruções do email para redefinir sua senha.',
                style: FutsallinkTypography.body1.copyWith(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FutsallinkSpacing.xl * 2),
              PrimaryButton(
                text: 'VOLTAR PARA LOGIN',
                onPressed: () {
                  Navigator.of(context).popUntil(
                    (route) => route.settings.name == '/login',
                  );
                },
              ),
              const SizedBox(height: FutsallinkSpacing.md),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
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
                  'TENTAR NOVAMENTE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 