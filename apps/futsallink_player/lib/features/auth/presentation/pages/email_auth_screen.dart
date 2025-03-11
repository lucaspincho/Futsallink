import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import 'package:futsallink_player/core/routes.dart';

class EmailAuthScreen extends StatefulWidget {
  @override
  _EmailAuthScreenState createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _sendVerificationEmail() async {
    if (!_formKey.currentState!.validate()) return;

    String email = _emailController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: "temporaryPassword123");
      User? user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        Navigator.pushNamed(context, AppRoutes.verifyEmail, arguments: email);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar verificação: ${e.toString()}')),
      );
    }

    setState(() {
      _isLoading = false;
    });
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
            ScreenTitle(text: "SEU E-MAIL É"),
            // Subtítulo
            SubtitleText(
              text:
                  "Digite um e-mail válido que será vinculado à sua conta.",
            ),
            SizedBox(height: 50),

            Form(
              key: _formKey,
              child: CustomTextField(
                hintText: "E-mail",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite um e-mail válido";
                  }
                  String emailPattern = r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$';
                  RegExp regex = RegExp(emailPattern);
                  if (!regex.hasMatch(value)) {
                    return "E-mail inválido";
                  }
                  return null;
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
                  text: "Usar telefone",
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.phoneAuth),
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
              onPressed: _isLoading ? null : _sendVerificationEmail,
            ),
          ],
        ),
      ),
    );
  }
}
