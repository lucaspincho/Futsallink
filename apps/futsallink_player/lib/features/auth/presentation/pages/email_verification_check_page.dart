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
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(FutsallinkSpacing.md),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomLogoHeader(
                      showBackButton: true,
                      onBackPressed: () => Navigator.pop(context),
                      bottomPadding: 60,
                    ),
                    
                    const SizedBox(height: FutsallinkSpacing.lg),
                    
                    const ScreenTitle(
                      text: 'Verifique seu e-mail',
                      bottomPadding: 8.0,
                    ),
                    const SizedBox(height: FutsallinkSpacing.sm),
                    SubtitleText(
                      text: 'Enviamos um link de verificação para ${widget.email}. Clique no link para verificar seu e-mail e retorne ao app.',
                    ),
                    
                    const SizedBox(height: FutsallinkSpacing.xl * 2),
                    
                    if (_isChecking || state is AuthLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: FutsallinkColors.primary,
                        ),
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
                      text: 'JÁ VERIFIQUEI',
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
                            },
                    ),
                    
                    const SizedBox(height: FutsallinkSpacing.lg),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 