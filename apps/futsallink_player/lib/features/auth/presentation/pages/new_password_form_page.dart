import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_core/futsallink_core.dart';
import 'package:futsallink_player/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class NewPasswordFormPage extends StatefulWidget {
  final AuthCredential credential;
  
  const NewPasswordFormPage({
    Key? key,
    required this.credential,
  }) : super(key: key);

  @override
  State<NewPasswordFormPage> createState() => _NewPasswordFormPageState();
}

class _NewPasswordFormPageState extends State<NewPasswordFormPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
        title: Text(
          'Nova Senha',
          style: FutsallinkTypography.headline2.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is PasswordResetCompletedState) {
            // Mostrar mensagem de sucesso e navegar para o login
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Senha redefinida com sucesso!')),
            );
            
            // Navegar para o login após breve atraso
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            });
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
                    Text(
                      'Crie uma nova senha',
                      style: FutsallinkTypography.body1.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: FutsallinkSpacing.xl),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Nova senha',
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, informe uma senha';
                        }
                        if (value.length < 6) {
                          return 'A senha deve ter pelo menos 6 caracteres';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: FutsallinkSpacing.md),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: 'Confirme a nova senha',
                      obscureText: _obscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, confirme sua senha';
                        }
                        if (value != _passwordController.text) {
                          return 'As senhas não correspondem';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: FutsallinkSpacing.xl),
                    PrimaryButton(
                      text: 'REDEFINIR SENHA',
                      isLoading: state is AuthLoading,
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      ConfirmPasswordResetEvent(
                                        newPassword: _passwordController.text,
                                        // Enviando código apenas se for redefinição por e-mail
                                        verificationCode: widget.credential.verificationCode,
                                      ),
                                    );
                              }
                            },
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