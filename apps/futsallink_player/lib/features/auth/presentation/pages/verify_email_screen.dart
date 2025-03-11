import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:futsallink_player/core/routes.dart'; // ✅ Import
import 'package:futsallink_ui/futsallink_ui.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({Key? key, required this.email}) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isEmailVerified = false;
  bool _canResendEmail = false;
  bool _isLoading = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startEmailCheck();
  }

  void _startEmailCheck() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await _auth.currentUser?.reload();
      User? user = _auth.currentUser;
      if (user != null && user.emailVerified) {
        setState(() {
          _isEmailVerified = true;
        });
        _timer?.cancel();
        Navigator.pushNamed(
          context, 
          AppRoutes.createPassword, 
          arguments: widget.email, // ✅ Passa corretamente o e-mail
        );
      }
    });

    Future.delayed(Duration(seconds: 30), () {
      setState(() {
        _canResendEmail = true;
      });
    });
  }

  Future<void> _resendVerificationEmail() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _auth.currentUser?.sendEmailVerification();

      setState(() {
        _canResendEmail = false;
      });

      Future.delayed(Duration(seconds: 30), () {
        setState(() {
          _canResendEmail = true;
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('E-mail de verificação reenviado!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao reenviar e-mail: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
            
            ScreenTitle(text: "VERIFIQUE SEU E-MAIL"),

            SubtitleText(
              text:
                "Enviamos um e-mail de verificação para ${widget.email}. Acesse seu e-mail e clique no link para continuar."
            ),
            SizedBox(height: 50),

            // ✅ Substituído pelo PrimaryButton
            PrimaryButton(
              text: "Já verifiquei",
              isLoading: _isLoading,
              onPressed: () async {
                await _auth.currentUser?.reload();
                User? user = _auth.currentUser;
                if (user != null && user.emailVerified) {
                  Navigator.pushNamed(
                    context, 
                    AppRoutes.createPassword, 
                    arguments: widget.email, // ✅ Passando o e-mail corretamente
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Seu e-mail ainda não foi verificado!')),
                  );
                }
              },
            ),

            SizedBox(height: 20),

            // Botão para reenviar o e-mail de verificação
            Center(
              child: TextButton(
                onPressed: _canResendEmail ? _resendVerificationEmail : null,
                child: Text(
                  _canResendEmail ? "Reenviar e-mail de verificação" : "Aguarde para reenviar...",
                  style: TextStyle(
                    color: _canResendEmail ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.w500,
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
