import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isInProgress = false;
  
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu e-mail';
    }
    
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Por favor, insira um e-mail válido';
    }
    
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FutsallinkColors.darkBackground,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is EmailVerificationSentState) {
            setState(() {
              _isInProgress = false;
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('E-mail de verificação enviado! Verifique sua caixa de entrada.'),
                backgroundColor: FutsallinkColors.success,
              ),
            );
            
            // Navegar para a tela de espera de verificação
            Navigator.of(context).pushNamed(
              '/email-verification-check',
              arguments: _emailController.text,
            );
          } else if (state is AuthErrorState) {
            setState(() {
              _isInProgress = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: FutsallinkColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(FutsallinkSpacing.md),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomLogoHeader(
                      showBackButton: true,
                      onBackPressed: () => Navigator.of(context).pop(),
                      bottomPadding: 60,
                    ),
                    
                    const SizedBox(height: FutsallinkSpacing.lg),
                    
                    const ScreenTitle(
                      text: 'Verificação de E-mail',
                      bottomPadding: 8.0,
                    ),
                    const SizedBox(height: FutsallinkSpacing.sm),
                    const SubtitleText(
                      text: 'Enviaremos um link de verificação para o seu e-mail',
                    ),

                    const SizedBox(height: FutsallinkSpacing.xl),
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: FutsallinkSpacing.xl),
                    PrimaryButton(
                      text: 'ENVIAR',
                      isLoading: state is AuthLoading,
                      onPressed: state is AuthLoading || _isInProgress
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isInProgress = true;
                                });
                                context.read<AuthBloc>().add(
                                      InitiateEmailVerificationEvent(
                                        email: _emailController.text.trim(),
                                      ),
                                    );
                              }
                            },
                    ),
                    const SizedBox(height: FutsallinkSpacing.lg),
                    
                    Center(
                      child: CustomLink(
                        text: 'Usar verificação por telefone',
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/phone-input');
                        },
                      ),
                    ),
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