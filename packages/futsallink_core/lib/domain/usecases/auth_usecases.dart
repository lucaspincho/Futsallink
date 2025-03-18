import 'package:dartz/dartz.dart';
import '../core/failures.dart';
import '../entities/entities.dart';
import '../repositories/auth_repository.dart';

// UseCase para login com email e senha
class SignInWithEmailUseCase {
  final AuthRepository repository;

  SignInWithEmailUseCase(this.repository);

  Future<Either<Failure, User>> call(String email, String password) async {
    // Primeiro obtém as credenciais
    final credentialResult = await repository.signInWithEmailAndPassword(email, password);
    
    // Retorna falha se não conseguir obter as credenciais
    if (credentialResult.isLeft()) {
      return credentialResult.fold(
        (failure) => Left(failure),
        (_) => Left(const AuthFailure(message: 'Erro desconhecido no login')), // Não deve acontecer
      );
    }
    
    // Obtém o perfil completo do usuário com as credenciais
    return credentialResult.fold(
      (_) => Left(const AuthFailure(message: 'Erro desconhecido no login')), // Não deve acontecer
      (credential) async {
        if (credential.uid == null) {
          return Left(const AuthFailure(message: 'Credenciais inválidas'));
        }
        
        final userResult = await repository.getUserProfile(credential.uid!);
        return userResult;
      },
    );
  }
}

// UseCase para cadastro com email e senha
class SignUpWithEmailUseCase {
  final AuthRepository repository;

  SignUpWithEmailUseCase(this.repository);

  Future<Either<Failure, User>> call(String email, String password, String name) async {
    // Primeiro obtém as credenciais
    final credentialResult = await repository.signInWithEmailAndPassword(email, password);
    
    // Se não conseguir obter as credenciais (usuário não existe), tenta criar
    return credentialResult.fold(
      (failure) async {
        // Cria uma credencial temporária
        final tempCredential = AuthCredential(email: email);
        
        // Cria um usuário com a credencial
        final userResult = await repository.createUserFromCredential(
          tempCredential,
          password: password,
          name: name,
        );
        
        return userResult;
      },
      (credential) async {
        // Se já existir um usuário com este email, retorna erro
        return Left(const AuthFailure(message: 'Este email já está em uso'));
      },
    );
  }
}

// NOVOS USE CASES

// UseCase para verificar se email já está registrado
class CheckEmailRegistrationUseCase {
  final AuthRepository repository;

  CheckEmailRegistrationUseCase(this.repository);

  Future<Either<Failure, bool>> call(String email) {
    return repository.isEmailRegistered(email);
  }
}

// UseCase para verificar se telefone já está registrado
class CheckPhoneRegistrationUseCase {
  final AuthRepository repository;

  CheckPhoneRegistrationUseCase(this.repository);

  Future<Either<Failure, bool>> call(String phoneNumber) {
    return repository.isPhoneRegistered(phoneNumber);
  }
}

// UseCase para iniciar verificação por email
class InitiateEmailVerificationUseCase {
  final AuthRepository repository;

  InitiateEmailVerificationUseCase(this.repository);

  Future<Either<Failure, AuthCredential>> call(String email) {
    return repository.initiateEmailVerification(email);
  }
}

// UseCase para iniciar verificação por telefone
class InitiatePhoneVerificationUseCase {
  final AuthRepository repository;

  InitiatePhoneVerificationUseCase(this.repository);

  Future<Either<Failure, AuthCredential>> call(String phoneNumber) {
    return repository.initiatePhoneVerification(phoneNumber);
  }
}

// UseCase para verificar código enviado por email
class VerifyEmailCodeUseCase {
  final AuthRepository repository;

  VerifyEmailCodeUseCase(this.repository);

  Future<Either<Failure, AuthCredential>> call(String email, String code) {
    return repository.verifyEmailCode(email, code);
  }
}

// UseCase para verificar código de SMS
class VerifyPhoneCodeUseCase {
  final AuthRepository repository;

  VerifyPhoneCodeUseCase(this.repository);

  Future<Either<Failure, AuthCredential>> call(String verificationId, String code) {
    return repository.verifyPhoneCode(verificationId, code);
  }
}

// UseCase para completar cadastro após a verificação
class CompleteSignUpUseCase {
  final AuthRepository repository;

  CompleteSignUpUseCase(this.repository);

  Future<Either<Failure, User>> call(AuthCredential credential, String password, {String? name}) {
    return repository.completeSignUp(credential, password, name: name);
  }
}

// UseCase para criar usuário após verificação do telefone (LEGADO)
class CreateUserFromPhoneUseCase {
  final AuthRepository repository;

  CreateUserFromPhoneUseCase(this.repository);

  Future<Either<Failure, User>> call(AuthCredential credential, String name) async {
    return repository.createUserFromCredential(credential, name: name);
  }
}

// UseCase para enviar email de redefinição de senha
class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, bool>> call(String email) {
    return repository.resetPassword(email);
  }
}

// UseCase para redefinição de senha via email
class ResetPasswordViaEmailUseCase {
  final AuthRepository repository;

  ResetPasswordViaEmailUseCase(this.repository);

  Future<Either<Failure, bool>> call(String email) {
    return repository.resetPasswordViaEmail(email);
  }
}

// UseCase para enviar código de redefinição de senha via telefone
class ResetPasswordViaPhoneUseCase {
  final AuthRepository repository;

  ResetPasswordViaPhoneUseCase(this.repository);

  Future<Either<Failure, AuthCredential>> call(String phoneNumber) {
    return repository.resetPasswordViaPhone(phoneNumber);
  }
}

// UseCase para verificar código de redefinição de senha via telefone
class VerifyPasswordResetCodeUseCase {
  final AuthRepository repository;

  VerifyPasswordResetCodeUseCase(this.repository);

  Future<Either<Failure, AuthCredential>> call(String verificationId, String code) {
    return repository.verifyPasswordResetCode(verificationId, code);
  }
}

// UseCase para confirmar a redefinição de senha (definir nova senha)
class ConfirmPasswordResetUseCase {
  final AuthRepository repository;

  ConfirmPasswordResetUseCase(this.repository);

  Future<Either<Failure, bool>> call(String newPassword, {String? verificationCode}) {
    return repository.confirmPasswordReset(newPassword, verificationCode: verificationCode);
  }
}

class UpdatePasswordUseCase {
  final AuthRepository _repository;

  UpdatePasswordUseCase(this._repository);

  Future<Either<Failure, bool>> call(String newPassword) async {
    return await _repository.updatePassword(newPassword);
  }
}

// UseCase para obter o usuário atual
class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, User?>> call() {
    return repository.getCurrentUser();
  }
}

// UseCase para logout
class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<Either<Failure, bool>> call() {
    return repository.signOut();
  }
}

// UseCase para atualizar token do dispositivo
class UpdateDeviceTokenUseCase {
  final AuthRepository repository;

  UpdateDeviceTokenUseCase(this.repository);

  Future<Either<Failure, void>> call(String token) {
    return repository.updateDeviceToken(token);
  }
}

// Classe para acessar o stream de mudanças de estado de autenticação
class AuthStateChangesUseCase {
  final AuthRepository repository;

  AuthStateChangesUseCase(this.repository);

  Stream<User?> get stream => repository.authStateChanges;
}