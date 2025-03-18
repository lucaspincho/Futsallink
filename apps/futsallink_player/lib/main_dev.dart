// Em apps/futsallink_player/lib/main_dev.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:futsallink_player/app.dart';
import 'package:futsallink_player/core/config/firebase_options_dev.dart';
import 'package:futsallink_player/core/di/injection_container.dart';
import 'package:futsallink_player/core/config/flavors.dart';
import 'package:futsallink_player/core/config/app_config.dart';

void main() async {
  // Garante que o Flutter foi inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Primeiro inicializa o Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
    print("Firebase inicializado com sucesso!");
    
    // DEPOIS configura o FirebaseAuth (esta era a causa do erro)
    FirebaseAuth.instance.setLanguageCode("pt-BR");
    FirebaseAuth.instance.setSettings(
      appVerificationDisabledForTesting: false,
      phoneNumber: null,
      smsCode: null,
      forceRecaptchaFlow: false,
    );
  } catch (e) {
    print("Erro ao inicializar Firebase: $e");
  }

  await initDependencies();
  
  FlavorConfig(flavor: Flavor.development);
  
  runApp(const FutsallinkPlayerApp(flavor: Flavor.development));
}