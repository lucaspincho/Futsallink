import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:futsallink_ui/widgets/widgets.dart';
import 'package:futsallink_player/core/routes.dart'; // ✅ Importa os widgets reutilizáveis

class ProfileNameScreen extends StatefulWidget {
  @override
  _ProfileNameScreenState createState() => _ProfileNameScreenState();
}

class _ProfileNameScreenState extends State<ProfileNameScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final _formKey =
      GlobalKey<FormState>(); // ✅ Adicionando validação ao formulário
  bool _isLoading = false;

  Future<void> _saveProfileData() async {
    if (!_formKey.currentState!.validate())
      return; // ✅ Agora verifica corretamente se os campos obrigatórios estão preenchidos

    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String nickname = _nicknameController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      // Obtém o usuário autenticado
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("Usuário não autenticado!");
      }

      // Referência ao documento do usuário no Firestore
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Salvar dados no Firestore
      await userDoc.set({
        'first_name': firstName,
        'last_name': lastName,
        'nickname': nickname.isEmpty
            ? null
            : nickname, // Salva null se o campo for vazio
        'created_at': FieldValue.serverTimestamp(), // Timestamp do Firestore
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dados salvos com sucesso!')),
      );

      // Redirecionar para a próxima tela (exemplo)
      Navigator.pushNamed(context, AppRoutes.profileAge);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: ${e.toString()}')),
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomLogoHeader(
                showBackButton: true,
              ),

              ScreenTitle(text: "QUEM É VOCÊ?"),
              SizedBox(height: 60),

              // ✅ Campo de Nome (Obrigatório) - Agora validado
              CustomTextField(
                hintText: "Nome*",
                controller: _firstNameController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "O nome é obrigatório";
                  }
                  return null;
                },
              ),

              SizedBox(height: 30),

              // ✅ Campo de Sobrenome (Obrigatório) - Agora validado
              CustomTextField(
                hintText: "Sobrenome*",
                controller: _lastNameController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "O sobrenome é obrigatório";
                  }
                  return null;
                },
              ),

              SizedBox(height: 30),

              // ✅ Campo de Apelido (Opcional) - Sem validação obrigatória
              CustomTextField(
                hintText: "Apelido (Opcional)",
                controller: _nicknameController,
                keyboardType: TextInputType.text,
              ),

              SizedBox(height: 30),

              // ✅ Substituído por PrimaryButton
              PrimaryButton(
                text: "AVANÇAR",
                isLoading: _isLoading,
                onPressed: _saveProfileData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
