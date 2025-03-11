import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class FirebaseInitialization {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      
      // Configurar Crashlytics apenas em modo release
      if (!kDebugMode) {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
        
        // Capturar erros Flutter não tratados
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      }
      
      print('Firebase inicializado com sucesso');
    } catch (e) {
      print('Erro ao inicializar Firebase: $e');
      rethrow;
    }
  }
}