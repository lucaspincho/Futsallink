import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import 'package:futsallink_core/futsallink_core.dart';

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({Key? key}) : super(key: key);

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AuthCredential _credential;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (args != null && args.containsKey('credential')) {
      _credential = args['credential'] as AuthCredential;
    } else {
      // Se não houver credencial, volta para a tela inicial
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/auth-method');
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite sua senha';
    }
    
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, confirme sua senha';
    }
    
    if (value != _passwordController.text) {
      return 'As senhas não coincidem';
    }
    
    return null;
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
            // Usuário autenticado, navegar para a tela de login
            Navigator.of(context).pushReplacementNamed('/login');
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(FutsallinkSpacing.md),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomLogoHeader(
                        showBackButton: true,
                        onBackPressed: () => Navigator.pop(context),
                        topPadding: 16.0,
                        bottomPadding: 60.0,
                      ),
                      const ScreenTitle(
                        text: 'CRIE SUA SENHA',
                        bottomPadding: 8.0,
                      ),
                      const SizedBox(height: FutsallinkSpacing.sm),
                      const SubtitleText(
                        text: 'Defina uma senha segura para sua conta com no mínimo 6 caracteres.',
                      ),
                      const SizedBox(height: 60),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Senha',
                        obscureText: _obscurePassword,
                        validator: _validatePassword,
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
                      const SizedBox(height: FutsallinkSpacing.md),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirmar senha',
                        obscureText: _obscureConfirmPassword,
                        validator: _validateConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 80),
                      PrimaryButton(
                        text: 'CONFIRMAR',
                        isLoading: state is AuthLoading,
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  final name = ''; // Nome será definido em outro momento
                                  
                                  context.read<AuthBloc>().add(
                                    CompleteSignUpEvent(
                                      credential: _credential,
                                      password: _passwordController.text,
                                      name: name,
                                    ),
                                  );
                                }
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 