import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../firebase_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseService().auth;
  
  // Método de login com email e senha
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Tratar erros específicos do Firebase Auth
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      // Erros genéricos
      throw FirebaseAuthException(
        code: 'unknown-error',
        message: 'Ocorreu um erro inesperado: ${e.toString()}',
      );
    }
  }
  
  // Método de registro com email e senha
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown-error',
        message: 'Ocorreu um erro inesperado: ${e.toString()}',
      );
    }
  }
  
  // Método para enviar verificação de email
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
      } else {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Usuário não encontrado. Não foi possível enviar email de verificação.',
        );
      }
    } catch (e) {
      if (e is! FirebaseAuthException) {
        throw FirebaseAuthException(
          code: 'email-verification-failed',
          message: 'Falha ao enviar email de verificação: ${e.toString()}',
        );
      }
      rethrow;
    }
  }
  
  // Método para verificar se um email já está registrado
  Future<bool> isEmailRegistered(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'O email fornecido não é válido.',
        );
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  // Método para verificar se um telefone já está registrado
  // Nota: Firebase não tem método direto para isso, logo vamos usar Firestore
  Future<bool> isPhoneRegistered(String phoneNumber) async {
    try {
      final firestore = FirebaseService().firestore;
      final snapshot = await firestore
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();
          
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  // Método de login com telefone - primeira etapa
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) verificationCompleted,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
  }) async {
    try {
      return await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: (e) {
          // Tratar erros específicos de verificação de telefone
          verificationFailed(_handleFirebaseAuthException(e));
        },
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      if (e is! FirebaseAuthException) {
        throw FirebaseAuthException(
          code: 'phone-verification-failed',
          message: 'Falha na verificação do telefone: ${e.toString()}',
        );
      }
      rethrow;
    }
  }
  
  // Método para iniciar verificação com telefone (método melhorado para uso com repository)
  Future<Map<String, dynamic>> initiatePhoneVerificationFlow(String phoneNumber) async {
    try {
      // Verificar se o número já está registrado antes
      final isRegistered = await isPhoneRegistered(phoneNumber);
      if (isRegistered) {
        throw FirebaseAuthException(
          code: 'phone-already-in-use',
          message: 'Este número de telefone já está registrado. Por favor, faça login.',
        );
      }
      
      // Criar um completer para usar com o verifyPhoneNumber que é assíncrono
      final Completer<Map<String, dynamic>> completer = Completer<Map<String, dynamic>>();
      String? verificationId;
      int? resendToken;
      
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto verificação completada (em alguns dispositivos Android)
          if (!completer.isCompleted) {
            completer.complete({
              'credential': credential, 
              'verificationId': verificationId,
              'autoVerified': true,
            });
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          // Falha na verificação
          if (!completer.isCompleted) {
            completer.completeError(_handleFirebaseAuthException(e));
          }
        },
        codeSent: (String vId, int? token) {
          // Código enviado para o telefone do usuário
          verificationId = vId;
          resendToken = token;
          if (!completer.isCompleted) {
            completer.complete({
              'verificationId': vId,
              'resendToken': token,
              'autoVerified': false,
            });
          }
        },
        codeAutoRetrievalTimeout: (String vId) {
          verificationId = vId;
        },
        timeout: const Duration(seconds: 60),
      );
      
      // Retornar o resultado
      return completer.future;
    } catch (e) {
      if (e is FirebaseAuthException) {
        rethrow;
      }
      throw FirebaseAuthException(
        code: 'phone-verification-failed',
        message: 'Falha na verificação do telefone: ${e.toString()}',
      );
    }
  }
  
  // Método para verificar código OTP
  Future<UserCredential> signInWithPhoneAuthCredential(PhoneAuthCredential credential) async {
    try {
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'unknown-error',
        message: 'Ocorreu um erro inesperado: ${e.toString()}',
      );
    }
  }
  
  // Método para definir senha para um usuário verificado
  Future<void> updatePasswordForCurrentUser(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      } else {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Usuário não encontrado. Não foi possível atualizar a senha.',
        );
      }
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'update-password-failed',
        message: 'Falha ao atualizar senha: ${e.toString()}',
      );
    }
  }
  
  // Método de logout
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      throw FirebaseAuthException(
        code: 'sign-out-failed',
        message: 'Falha ao sair: ${e.toString()}',
      );
    }
  }
  
  // Stream para status de autenticação
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Obter usuário atual
  User? get currentUser => _auth.currentUser;
  
  // Método para gerar uma senha aleatória
  String _generateRandomPassword() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()';
    return String.fromCharCodes(
      List.generate(12, (_) => chars.codeUnitAt(Random().nextInt(chars.length))),
    );
  }
  
  // Método privado para padronizar o tratamento de erros do Firebase Auth
  FirebaseAuthException _handleFirebaseAuthException(FirebaseAuthException e) {
    String message;
    
    switch (e.code) {
      // Erros de autenticação por email/senha
      case 'user-not-found':
        message = 'Usuário não encontrado. Verifique seu email ou crie uma nova conta.';
        break;
      case 'wrong-password':
        message = 'Senha incorreta. Por favor, verifique e tente novamente.';
        break;
      case 'invalid-email':
        message = 'O email fornecido não é válido.';
        break;
      case 'user-disabled':
        message = 'Esta conta foi desativada. Contate o suporte para mais informações.';
        break;
      case 'email-already-in-use':
        message = 'Este email já está sendo usado por outra conta.';
        break;
      case 'weak-password':
        message = 'A senha é muito fraca. Use uma senha mais forte.';
        break;
      case 'operation-not-allowed':
        message = 'Esta operação não é permitida. Contate o suporte.';
        break;
        
      // Erros de autenticação por telefone
      case 'invalid-phone-number':
        message = 'O número de telefone fornecido não é válido.';
        break;
      case 'invalid-verification-code':
        message = 'O código de verificação é inválido. Tente novamente.';
        break;
      case 'invalid-verification-id':
        message = 'O ID de verificação é inválido. Reinicie o processo.';
        break;
      case 'quota-exceeded':
        message = 'Limite de tentativas excedido. Tente novamente mais tarde.';
        break;
      case 'credential-already-in-use':
        message = 'Esta credencial já está associada a uma conta diferente.';
        break;
        
      // Outros erros
      case 'network-request-failed':
        message = 'Falha na conexão de rede. Verifique sua internet e tente novamente.';
        break;
      case 'too-many-requests':
        message = 'Muitas tentativas. Tente novamente mais tarde.';
        break;
      default:
        message = e.message ?? 'Ocorreu um erro durante a autenticação.';
        break;
    }
    
    return FirebaseAuthException(
      code: e.code,
      message: message,
      email: e.email,
      credential: e.credential,
      tenantId: e.tenantId,
    );
  }
  
  // Método para iniciar verificação por email (cria usuário temporário)
  Future<void> initiateEmailVerification(String email) async {
    try {
      // Criar uma senha temporária aleatória
      final tempPassword = _generateRandomPassword();
      
      // Tentar criar usuário com senha temporária
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: tempPassword,
      );
      
      // Enviar email de verificação
      if (credential.user != null) {
        await credential.user!.sendEmailVerification();
      } else {
        throw FirebaseAuthException(
          code: 'user-creation-failed',
          message: 'Falha ao criar usuário temporário.',
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Se o email já está em uso, verificar se é verificado
        final methods = await _auth.fetchSignInMethodsForEmail(email);
        if (methods.isEmpty) {
          throw FirebaseAuthException(
            code: 'email-already-in-use',
            message: 'Este email já está em uso e não foi verificado. Tente outro email.',
          );
        } else {
          throw FirebaseAuthException(
            code: 'email-already-in-use',
            message: 'Este email já está registrado. Por favor, faça login.',
          );
        }
      }
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'verification-failed',
        message: 'Falha ao iniciar verificação: ${e.toString()}',
      );
    }
  }
  
  // Método para verificar status de verificação de email
  Future<bool> checkEmailVerified() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.reload(); // Recarrega os dados do usuário
        return user.emailVerified;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  // Método para enviar email de redefinição de senha
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'reset-password-failed',
        message: 'Falha ao enviar email de redefinição de senha: ${e.toString()}',
      );
    }
  }
  
  // Método para iniciar redefinição de senha por telefone
  Future<PhoneAuthCredential?> initiatePasswordResetByPhone(String phoneNumber) async {
    try {
      // Verificar se o telefone está registrado
      final userRecord = await _getUserByPhoneNumber(phoneNumber);
      if (userRecord == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Não existe conta associada a este número de telefone.',
        );
      }
      
      // Iniciar a verificação por telefone
      Completer<PhoneAuthCredential?> completer = Completer<PhoneAuthCredential?>();
      String? verificationId;
      
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-verificação completa (Android)
          if (!completer.isCompleted) {
            completer.complete(credential);
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (!completer.isCompleted) {
            completer.completeError(_handleFirebaseAuthException(e));
          }
        },
        codeSent: (String vId, int? resendToken) {
          verificationId = vId;
          if (!completer.isCompleted) {
            // Retorna null quando o código é enviado com sucesso para o usuário
            // O ID de verificação é necessário para verificar o código posteriormente
            completer.complete(null);
          }
        },
        codeAutoRetrievalTimeout: (String vId) {
          // Timeout para recuperação automática de código (Android)
        },
        timeout: const Duration(seconds: 60),
      );
      
      final result = await completer.future;
      
      // Se chegarmos aqui com sucesso, retornamos o credential ou null (código enviado)
      return result;
    } catch (e) {
      if (e is FirebaseAuthException) {
        throw e;
      }
      throw FirebaseAuthException(
        code: 'phone-verification-failed',
        message: 'Falha ao iniciar a verificação por telefone: ${e.toString()}',
      );
    }
  }
  
  // Método para verificar o código de redefinição de senha
  Future<void> verifyPasswordResetCode(String code) async {
    try {
      await _auth.verifyPasswordResetCode(code);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'verify-reset-code-failed',
        message: 'Falha ao verificar código de redefinição de senha: ${e.toString()}',
      );
    }
  }
  
  // Método para confirmar a redefinição de senha
  Future<void> confirmPasswordReset(String code, String newPassword) async {
    try {
      await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'confirm-reset-failed',
        message: 'Falha ao confirmar redefinição de senha: ${e.toString()}',
      );
    }
  }
  
  // Método privado para encontrar usuário pelo número de telefone
  Future<User?> _getUserByPhoneNumber(String phoneNumber) async {
    try {
      // Verificar se há métodos de login para este número
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();
      
      if (querySnapshot.docs.isEmpty) {
        return null;
      }
      
      // Obter o ID do usuário a partir do Firestore
      final uid = querySnapshot.docs.first.id;
      
      // Em um cenário real, você precisaria verificar no Firebase Auth também
      // aqui estamos simplificando e retornando o usuário atual ou null
      return _auth.currentUser;
    } catch (e) {
      return null;
    }
  }
}