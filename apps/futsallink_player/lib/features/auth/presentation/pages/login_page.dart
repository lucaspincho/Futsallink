// Em apps/futsallink_player/lib/features/auth/presentation/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
          } else if (state is AuthenticatedState) {
            // Navegue para a tela principal após login bem-sucedido
            Navigator.of(context).pushReplacementNamed('/home');
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(FutsallinkSpacing.md),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: FutsallinkSpacing.lg),
                    const CustomLogoHeader(),
                    const SizedBox(height: FutsallinkSpacing.xl),
                    Text(
                      'LOGIN',
                      style: FutsallinkTypography.headline1.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Para acessar a plataforma coloque suas informações de login',
                      style: FutsallinkTypography.headline2.copyWith(
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: FutsallinkSpacing.xl),
                    CustomTextField(
                      controller: _emailController,
                      hintText: 'E-mail ou telefone',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: FutsallinkSpacing.md),
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Senha',
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomLink(
                        text: 'Esqueceu sua senha?',
                        onPressed: () {
                          Navigator.of(context).pushNamed('/forgot-password');
                        },
                      ),
                    ),
                    const SizedBox(height: FutsallinkSpacing.lg),
                    PrimaryButton(
                      text: 'ENTRAR',
                      isLoading: state is AuthLoading,
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              context.read<AuthBloc>().add(
                                    LoginWithEmailPasswordEvent(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text,
                                    ),
                                  );
                            },
                    ),
                    const SizedBox(height: FutsallinkSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Não tem uma conta? ',
                          style: FutsallinkTypography.headline2.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        CustomLink(
                          text: 'Crie aqui',
                          onPressed: () {
                            Navigator.of(context).pushNamed('/email-verification');
                          },
                        ),
                      ],
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