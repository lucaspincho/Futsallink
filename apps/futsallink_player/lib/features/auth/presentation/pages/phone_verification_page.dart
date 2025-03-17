import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsallink_core/futsallink_core.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import '../bloc/auth_bloc.dart';

class PhoneVerificationPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const PhoneVerificationPage({
    Key? key, 
    required this.verificationId,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verifyCode() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      
      context.read<AuthBloc>().add(
        VerifyPhoneCodeEvent(
          verificationId: widget.verificationId, 
          code: _codeController.text.trim(),
        ),
      );
    }
  }

  String? _validateCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Insira o código';
    }
    if (value.length < 6) {
      return 'O código deve ter 6 dígitos';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar Telefone'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            setState(() {
              _isSubmitting = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is PhoneVerificationCompletedState) {
            Navigator.pushReplacementNamed(
              context, 
              '/create-password',
              arguments: state.credential,
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Digite o código enviado para',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.phoneNumber,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _codeController,
                    decoration: const InputDecoration(
                      labelText: 'Código de verificação',
                      helperText: 'Digite o código de 6 dígitos recebido por SMS',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    validator: _validateCode,
                    enabled: !_isSubmitting,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _verifyCode,
                    child: _isSubmitting
                        ? const CircularProgressIndicator()
                        : const Text('Verificar Código'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _isSubmitting 
                        ? null 
                        : () {
                            Navigator.pop(context);
                          },
                    child: const Text('Usar outro número'),
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