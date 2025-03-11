// Em packages/futsallink_firebase/lib/auth/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseService().auth;
  
  // Método de login com email e senha
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  
  // Método de registro com email e senha
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  
  // Método de login com telefone - primeira etapa
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) verificationCompleted,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
  }) {
    return _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }
  
  // Método para verificar código OTP
  Future<UserCredential> signInWithPhoneAuthCredential(PhoneAuthCredential credential) {
    return _auth.signInWithCredential(credential);
  }
  
  // Método de logout
  Future<void> signOut() {
    return _auth.signOut();
  }
  
  // Stream para status de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Obter usuário atual
  User? get currentUser => _auth.currentUser;
}