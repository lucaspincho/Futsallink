import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _phoneController = TextEditingController();
  
  // Formatador de máscara para o número de telefone
  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // Método para extrair apenas os números do telefone
  String _getPhoneNumbers() {
    return _phoneMaskFormatter.getUnmaskedText();
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
          } else if (state is PhoneVerificationSentState) {
            Navigator.of(context).pushNamed(
              '/verification-code',
              arguments: {
                'verificationId': state.verificationId,
                'phoneNumber': _getPhoneNumbers(),
              },
            );
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
                    CustomLogoHeader(
                      showBackButton: true,
                      onBackPressed: () => Navigator.pop(context),
                      topPadding: 16.0,
                      bottomPadding: 60.0,
                    ),
                    ScreenTitle(
                      text: 'SEU TELEFONE É',
                      bottomPadding: FutsallinkSpacing.md,
                    ),
                    SubtitleText(
                      text: 'Digite um número de telefone válido\nque será vinculado à sua conta.',
                    ),
                    const SizedBox(height: 80),
                    CustomTextField(
                      controller: _phoneController,
                      hintText: 'Nº de Telefone',
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        // A máscara será aplicada automaticamente
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um número de telefone';
                        }
                        if (_getPhoneNumbers().length < 11) {
                          return 'Número de telefone inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: FutsallinkSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomLink(
                          text: 'Usar e-mail',
                          onPressed: () {
                            // Implementar navegação para tela de cadastro com e-mail
                          },
                        ),
                        CustomLink(
                          text: 'Já possui uma conta?',
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed('/login');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                    PrimaryButton(
                      text: 'CONFIRMAR',
                      isLoading: state is AuthLoading,
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              final phoneText = _getPhoneNumbers();
                              if (phoneText.length >= 11) {
                                context.read<AuthBloc>().add(
                                      LoginWithPhoneEvent(
                                        phoneNumber: '+55$phoneText',
                                      ),
                                    );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Digite um número de telefone válido')),
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