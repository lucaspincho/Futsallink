import 'package:dartz/dartz.dart';
import '../core/failures.dart';
import '../entities/user.dart';
import '../entities/auth_credential.dart';

abstract class AuthRepository {
  // Métodos para iniciar a verificação
  Future<Either<Failure, AuthCredential>> initiateEmailVerification(String email);
  Future<Either<Failure, AuthCredential>> initiatePhoneVerification(String phoneNumber);
  
  // Métodos para verificar código
  Future<Either<Failure, AuthCredential>> verifyEmailCode(String email, String code);
  Future<Either<Failure, AuthCredential>> verifyPhoneCode(String verificationId, String code);
  
  // Métodos para finalizar o cadastro após verificação
  Future<Either<Failure, User>> completeSignUp(AuthCredential credential, String password, {String? name});
  
  // Métodos de autenticação tradicional
  Future<Either<Failure, AuthCredential>> signInWithEmailAndPassword(String email, String password);
  Future<Either<Failure, AuthCredential>> signInWithPhone(String phoneNumber); 

  // Métodos para criar ou recuperar usuário após autenticação bem-sucedida
  Future<Either<Failure, User>> createUserFromCredential(AuthCredential credential, {String? password, String? name});
  Future<Either<Failure, User>> getUserProfile(String uid);
  
  // Métodos para redefinição de senha
  Future<Either<Failure, bool>> resetPasswordViaEmail(String email);
  Future<Either<Failure, AuthCredential>> resetPasswordViaPhone(String phoneNumber);
  Future<Either<Failure, AuthCredential>> verifyPasswordResetCode(String verificationId, String code);
  Future<Either<Failure, bool>> confirmPasswordReset(String newPassword, {String? verificationCode});
  
  // Outros métodos
  Future<Either<Failure, bool>> isEmailRegistered(String email);
  Future<Either<Failure, bool>> isPhoneRegistered(String phoneNumber);
  Future<Either<Failure, bool>> resetPassword(String email);
  Future<Either<Failure, bool>> updatePassword(String newPassword);
  Future<Either<Failure, bool>> signOut();
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, void>> updateDeviceToken(String token);
  Stream<User?> get authStateChanges;
} 