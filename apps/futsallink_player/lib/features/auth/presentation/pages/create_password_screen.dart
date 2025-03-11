import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futsallink_ui/futsallink_ui.dart';
import 'package:futsallink_player/core/routes.dart';

class CreatePasswordScreen extends StatefulWidget {
  final String email; // ✅ Recebe o e-mail como parâmetro

  const CreatePasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  _CreatePasswordScreenState createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _setPassword() async {
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('As senhas não coincidem!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(password);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Senha definida com sucesso!')),
        );

        // ✅ Redireciona para a tela de nome do perfil
        Navigator.pushNamed(context, AppRoutes.profileName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: Nenhum usuário autenticado!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E1A2A),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomLogoHeader(
              showBackButton: true,
            ),
            ScreenTitle(text: "CRIAR SENHA"),
            SizedBox(height: 60), // 🔹 Ajuste de espaçamento

            // ✅ Campo de Senha (usando widget reutilizável)
            CustomTextField(
              hintText: "Senha",
              controller: _passwordController,
              obscureText: _obscurePassword,
              keyboardType: TextInputType.text,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.blue,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),

            SizedBox(height: 40), // 🔹 Ajuste de espaçamento

            // ✅ Campo de Confirmar Senha (usando widget reutilizável)
            CustomTextField(
              hintText: "Confirmar senha",
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              keyboardType: TextInputType.text,
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

            SizedBox(height: 40), // 🔹 Ajuste de espaçamento

            // ✅ Botão CRIAR SENHA com estado de carregamento
            PrimaryButton(
              text: "Criar",
              isLoading: _isLoading,
              onPressed: _setPassword,
            ),
          ],
        ),
      ),
    );
  }
}
