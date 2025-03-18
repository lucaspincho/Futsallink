import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_player/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ResetPasswordPhoneVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  
  const ResetPasswordPhoneVerificationPage({
    Key? key,
    required this.phoneNumber,
    required this.verificationId,
  }) : super(key: key);

  @override
  State<ResetPasswordPhoneVerificationPage> createState() => _ResetPasswordPhoneVerificationPageState();
}

class _ResetPasswordPhoneVerificationPageState extends State<ResetPasswordPhoneVerificationPage> {
  final TextEditingController _codeController = TextEditingController();
  bool _isCodeComplete = false;
  
  @override
  void dispose() {
    _codeController.dispose();
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
          'Verificar Código',
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
          } else if (state is PasswordResetCodeVerifiedState) {
            // Navegar para a tela de definição de nova senha
            Navigator.of(context).pushNamed(
              '/new-password-form',
              arguments: {
                'credential': state.credential,
              },
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(FutsallinkSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Um código de verificação foi enviado para:',
                    style: FutsallinkTypography.body1.copyWith(
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: FutsallinkSpacing.sm),
                  Text(
                    widget.phoneNumber,
                    style: FutsallinkTypography.body1.copyWith(
                      color: FutsallinkColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: FutsallinkSpacing.xl),
                  Text(
                    'Digite o código recebido',
                    style: FutsallinkTypography.body1.copyWith(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: FutsallinkSpacing.xl),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: FutsallinkSpacing.md),
                    child: PinCodeTextField(
                      appContext: context,
                      length: 6,
                      controller: _codeController,
                      autoFocus: true,
                      autoDisposeControllers: false, // Permitir que destruamos manualmente
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeColor: FutsallinkColors.primary,
                        inactiveColor: Colors.white.withOpacity(0.3),
                        selectedColor: FutsallinkColors.primary,
                        activeFillColor: Colors.transparent,
                        inactiveFillColor: Colors.transparent,
                        selectedFillColor: Colors.transparent,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isCodeComplete = value.length == 6;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: FutsallinkSpacing.xl),
                  PrimaryButton(
                    text: 'VERIFICAR CÓDIGO',
                    isLoading: state is AuthLoading,
                    onPressed: (_isCodeComplete && state is! AuthLoading)
                        ? () {
                            final code = _codeController.text.trim();
                            if (code.length == 6) {
                              context.read<AuthBloc>().add(
                                    VerifyPasswordResetCodeEvent(
                                      verificationId: widget.verificationId,
                                      code: code,
                                    ),
                                  );
                            }
                          }
                        : null,
                  ),
                  const SizedBox(height: FutsallinkSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Não recebeu o código? ',
                        style: FutsallinkTypography.body2.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      CustomLink(
                        text: 'Reenviar',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 