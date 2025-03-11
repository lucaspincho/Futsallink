import 'package:flutter/material.dart';
import 'package:futsallink_player/core/routes.dart';
import 'package:futsallink_ui/futsallink_ui.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E1A2A), // Cor de fundo do protótipo
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo do app
            Center(
              child: Column(
                children: [
                  Image.asset('assets/logo.svg', height: 40),
                  SizedBox(height: 40),
                ],
              ),
            ),

            // Título "LOGIN"
            ScreenTitle(
                text:
                    "LOGIN"),
            SizedBox(height: 8),

            SubtitleText(
                text:
                    "Para acessar a plataforma, coloque suas informações de login"), // ✅ Usando o widget
            SizedBox(height: 20),

            // Campo de E-mail ou Telefone
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: InputBorder.none,
                  hintText: "E-mail ou telefone",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Campo de Senha
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: InputBorder.none,
                  hintText: "Senha",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  suffixIcon:
                      Icon(Icons.visibility_off, color: Colors.grey[400]),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Link "Esqueceu sua senha?"
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Redirecionar para recuperação de senha
                },
                child: Text(
                  "Esqueceu sua senha?",
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Botão "ENTRAR"
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.phoneAuth);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1877F2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "ENTRAR",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Link "Criar Conta"
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                      context,
                      AppRoutes
                          .phoneAuth); // ✅ Redireciona para phone_auth_screen
                },
                child: RichText(
                  text: TextSpan(
                    text: "Não tem uma conta? ",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Crie aqui",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Botão de Teste
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.profileAge);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "TESTE",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
