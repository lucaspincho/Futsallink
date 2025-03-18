import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ForgotPasswordPhonePage extends StatefulWidget {
  const ForgotPasswordPhonePage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPhonePage> createState() => _ForgotPasswordPhonePageState();
}

class _ForgotPasswordPhonePageState extends State<ForgotPasswordPhonePage> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _phoneNumber = '';
  
  @override
  void dispose() {
    _phoneController.dispose();
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
          'Redefinir por Telefone',
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
          } else if (state is PasswordResetPhoneVerificationSentState) {
            // Navegar para a tela de verificação de código
            Navigator.of(context).pushNamed(
              '/reset-password-phone-verification',
              arguments: {
                'phoneNumber': state.phoneNumber,
                'verificationId': state.verificationId,
              },
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
                    Text(
                      'Informe seu número de telefone para receber o código de verificação por SMS:',
                      style: FutsallinkTypography.body1.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: FutsallinkSpacing.xl),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          _phoneNumber = number.phoneNumber ?? '';
                        },
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.DIALOG,
                          showFlags: true,
                        ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: const TextStyle(color: Colors.white),
                        textFieldController: _phoneController,
                        formatInput: true,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputDecoration: InputDecoration(
                          hintText: 'Número de telefone',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          border: InputBorder.none,
                        ),
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: FutsallinkSpacing.xl),
                    PrimaryButton(
                      text: 'ENVIAR CÓDIGO',
                      isLoading: state is AuthLoading,
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate() && _phoneNumber.isNotEmpty) {
                                context.read<AuthBloc>().add(
                                      ResetPasswordViaPhoneEvent(
                                        phoneNumber: _phoneNumber,
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