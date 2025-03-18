import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_core/futsallink_core.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import '../bloc/auth_bloc.dart';

class EmailVerificationCheckPage extends StatefulWidget {
  final String email;
  
  const EmailVerificationCheckPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<EmailVerificationCheckPage> createState() => _EmailVerificationCheckPageState();
}

class _EmailVerificationCheckPageState extends State<EmailVerificationCheckPage> {
  Timer? _timer;
  bool _isChecking = false;
  int _secondsLeft = 180; // 3 minutos

  @override
  void initState() {
    super.initState();
    _startVerificationCheck();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  void _startVerificationCheck() {
    // Verificar a cada 5 segundos
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isChecking) {
        setState(() {
          _isChecking = true;
        });
        
        context.read<AuthBloc>().add(
          CheckEmailVerificationEvent(email: widget.email),
        );
        
        setState(() {
          _secondsLeft -= 5;
          if (_secondsLeft <= 0) {
            _timer?.cancel();
          }
          _isChecking = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FutsallinkColors.darkBackground,
      appBar: AppBar(
        title: const Text('Verificação de E-mail'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is EmailVerificationCompletedState) {
            _timer?.cancel();
            Navigator.pushReplacementNamed(
              context, 
              '/create-password',
              arguments: {'credential': state.credential},
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(FutsallinkSpacing.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.mark_email_read,
                  size: 80,
                  color: FutsallinkColors.primary,
                ),
                const SizedBox(height: FutsallinkSpacing.lg),
                Text(
                  'Verifique seu e-mail',
                  style: FutsallinkTypography.headline1.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: FutsallinkSpacing.md),
                Text(
                  'Enviamos um link de verificação para ${widget.email}',
                  style: FutsallinkTypography.headline2.copyWith(
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: FutsallinkSpacing.md),
                Text(
                  'Clique no link para verificar seu e-mail e retorne a este aplicativo',
                  style: FutsallinkTypography.headline2.copyWith(
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: FutsallinkSpacing.xl),
                if (_isChecking || state is AuthLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  Text(
                    'Verificando automaticamente...',
                    style: FutsallinkTypography.body1.copyWith(
                      color: Colors.white54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: FutsallinkSpacing.xl),
                PrimaryButton(
                  text: 'VERIFICAR AGORA',
                  isLoading: _isChecking || state is AuthLoading,
                  onPressed: (_isChecking || state is AuthLoading)
                      ? null
                      : () {
                          setState(() {
                            _isChecking = true;
                          });
                          context.read<AuthBloc>().add(
                            CheckEmailVerificationEvent(email: widget.email),
                          );
                          setState(() {
                            _isChecking = false;
                          });
                        },
                ),
                const SizedBox(height: FutsallinkSpacing.md),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Voltar'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 