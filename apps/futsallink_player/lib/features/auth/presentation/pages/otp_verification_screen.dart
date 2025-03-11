import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String verificationId; // ID da verificação recebido da tela anterior

  const OTPVerificationScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  String smsCode = ''; // Armazena o código digitado
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isResendEnabled = false; // Controla reenvio de código
  int secondsRemaining = 90; // Tempo para reenvio
  late Timer _timer; // Timer para contagem regressiva
  bool _isLoading = false; // ✅ Adicionado controle de carregamento

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  // Função para iniciar o contador de tempo para reenvio
  void startResendTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          isResendEnabled = true;
        });
        _timer.cancel();
      }
    });
  }

  // Função para reenviar o código OTP
  void _resendCode() {
    setState(() {
      isResendEnabled = false;
      secondsRemaining = 90;
    });
    startResendTimer();
    // Aqui você pode chamar o Firebase novamente para reenviar o código
  }

  // Função para verificar o código inserido
  void _verifyOTP() async {
    try {
      setState(() {
        _isLoading = true;
      });

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      print("Autenticação bem-sucedida!");

      setState(() {
        _isLoading = false;
      });

      // Redirecionar o usuário para a próxima tela após sucesso
    } catch (e) {
      print("Erro ao validar código: $e");

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao verificar código: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E1A2A),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo do App
            CustomLogoHeader(
              showBackButton: true,
            ),

            // Título
            ScreenTitle(
                text:
                    "CÓDIGO DE VERIFICAÇÃO"),

            // Subtítulo
            SubtitleText(
              text:
                  "Verifique o código enviado ao seu número e digite-o abaixo.",
            ),
            SizedBox(height: 50),

            // Campo de Código OTP
            PinCodeTextField(
              appContext: context,
              length: 6, // Código de 6 dígitos
              keyboardType: TextInputType.number,
              textStyle: TextStyle(color: Colors.white),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 60,
                fieldWidth: 50,
                activeFillColor: Colors.white,
                inactiveColor: Colors.grey[400],
                selectedColor: Colors.blue,
              ),
              onChanged: (value) {
                setState(() {
                  smsCode = value;
                });
              },
            ),
            SizedBox(height: 60),

            // ✅ Substituído pelo PrimaryButton
            PrimaryButton(
              text: "ENVIAR",
              isLoading: _isLoading,
              onPressed: smsCode.length == 6 ? _verifyOTP : null,
            ),
            SizedBox(height: 20),

            // Reenviar código
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: isResendEnabled ? _resendCode : null,
                  child: Text(
                    "Reenviar código",
                    style: TextStyle(
                      color: isResendEnabled ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  "${secondsRemaining ~/ 60}:${(secondsRemaining % 60).toString().padLeft(2, '0')}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
