import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import 'otp_verification_screen.dart';
import 'package:futsallink_player/core/routes.dart'; // Importa a tela de verificação OTP

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String phoneNumber = '';
  String verificationId = '';
  bool _isLoading = false; // ✅ Adicionado controle de carregamento

  // ✅ Função para iniciar a autenticação via telefone e redirecionar para a tela OTP
  void _sendCode() async {
    if (phoneNumber.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      print("Enviando código para: $phoneNumber");

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          print("Login automático bem-sucedido!");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Erro ao verificar número: ${e.message}");
          setState(() {
            _isLoading = false;
          });
        },
        codeSent: (String verId, int? resendToken) {
          setState(() {
            verificationId = verId;
            _isLoading = false;
          });

          // ✅ Redireciona para a tela de OTP após o código ser enviado
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OTPVerificationScreen(verificationId: verId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verId) {
          setState(() {
            verificationId = verId;
            _isLoading = false;
          });
          print("Tempo limite de auto recuperação atingido.");
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E1A2A), // Cor de fundo
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo do App
            CustomLogoHeader(
              showBackButton: true,
            ),
            // Título
            ScreenTitle(text: "SEU TELEFONE É"),
            // Subtítulo
            SubtitleText(
              text:
                  "Digite um número de telefone válido que será vinculado à sua conta.",
            ),
            SizedBox(height: 50),

            // ✅ Campo de Telefone com CustomTextField (NOVO)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IntlPhoneField(
                dropdownTextStyle: TextStyle(color: Colors.white, fontSize: 16),
                dropdownIcon:
                    Icon(Icons.arrow_drop_down, color: Colors.white, size: 24),
                style: TextStyle(color: Colors.white, fontSize: 16),
                flagsButtonPadding: EdgeInsets.only(left: 5, right: 5),
                disableLengthCheck: true,
                decoration: InputDecoration(
                  // ✅ Estilo alinhado ao CustomTextField
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: InputBorder.none,
                  hintText: "N° de Telefone",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                initialCountryCode: 'BR',
                onChanged: (phone) {
                  setState(() {
                    phoneNumber = phone.completeNumber;
                  });
                },
              ),
            ),
            SizedBox(height: 10),

            // Botões "Usar e-mail" e "Já possui uma conta?"
            // ✅ Links com CustomLink (NOVO)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomLink(
                  text: "Usar e-mail",
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.emailAuth),
                  align: Alignment.centerLeft,
                ),
                CustomLink(
                  text: "Já possui uma conta?",
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
                  align: Alignment.centerRight,
                ),
              ],
            ),
            SizedBox(height: 60),

            // ✅ Substituído pelo PrimaryButton
            PrimaryButton(
              text: "Confirmar",
              isLoading: _isLoading,
              onPressed: _sendCode,
            ),
          ],
        ),
      ),
    );
  }
}
