// Em apps/futsallink_player/lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:futsallink_core/futsallink_core.dart';
import 'package:futsallink_firebase/futsallink_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final FirestoreService _firestoreService;
  
  AuthRepositoryImpl(this._authService, this._firestoreService);
  
  User _mapFirestoreToUser(String uid, Map<String, dynamic> userData) {
    return User(
      uid: uid,
      name: userData['name'] ?? '',
      email: userData['email'] ?? '',
      phoneNumber: userData['phoneNumber'] ?? '',
      profileType: userData['profileType'] ?? 'player',
      createdAt: (userData['createdAt'] as Timestamp).toDate(),
      updatedAt: (userData['updatedAt'] as Timestamp).toDate(),
      isActive: userData['isActive'] ?? true,
      lastLoginAt: userData['lastLoginAt'] != null 
          ? (userData['lastLoginAt'] as Timestamp).toDate() 
          : DateTime.now(),
      deviceTokens: List<String>.from(userData['deviceTokens'] ?? []),
    );
  }
  
  @override
  Future<Either<Failure, AuthCredential>> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _authService.signInWithEmailAndPassword(email, password);
      return Right(AuthCredential(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        phoneNumber: userCredential.user!.phoneNumber,
        isVerified: true,
        authMethod: AuthMethod.email,
        verificationStatus: VerificationStatus.completed,
      ));
    } on FirebaseAuthException catch (e) {
      // Mapear FirebaseAuthException para Failure do domínio
      return Left(AuthFailure(message: e.message ?? 'Erro de autenticação'));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> isEmailRegistered(String email) async {
    try {
      final isRegistered = await _authService.isEmailRegistered(email);
      return Right(isRegistered);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> isPhoneRegistered(String phoneNumber) async {
    try {
      final isRegistered = await _authService.isPhoneRegistered(phoneNumber);
      return Right(isRegistered);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, AuthCredential>> initiateEmailVerification(String email) async {
    try {
      // Verificar formato de email
      final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegExp.hasMatch(email)) {
        return Left(ValidationFailure(message: 'Formato de email inválido'));
      }
      
      // Verificar se email já está registrado
      final isRegistered = await _authService.isEmailRegistered(email);
      if (isRegistered) {
        return Left(AuthFailure(message: 'Este email já está registrado. Tente fazer login.'));
      }
      
      // Iniciar verificação de email
      await _authService.initiateEmailVerification(email);
      
      return Right(AuthCredential(
        email: email,
        authMethod: AuthMethod.email,
        verificationStatus: VerificationStatus.pendingCodeVerification,
      ));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Falha ao iniciar verificação de email'));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, AuthCredential>> verifyEmailCode(String email, String code) async {
    try {
      // Este método simula a verificação do email, já que na prática
      // isso ocorre quando o usuário clica no link enviado por email
      
      // Verificar se o usuário atual está com o email verificado
      final isVerified = await _authService.checkEmailVerified();
      
      if (isVerified) {
        final user = _authService.currentUser;
        return Right(AuthCredential(
          uid: user?.uid,
          email: email,
          authMethod: AuthMethod.email,
          isVerified: true,
          verificationStatus: VerificationStatus.codeVerified,
        ));
      } else {
        return Left(AuthFailure(
          message: 'Email ainda não verificado. Por favor, clique no link enviado ao seu email.'
        ));
      }
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, AuthCredential>> initiatePhoneVerification(String phoneNumber) async {
    try {
      // Verificar formato de telefone
      final phoneRegExp = RegExp(r'^\+[0-9]{10,15}$');
      if (!phoneRegExp.hasMatch(phoneNumber)) {
        return Left(ValidationFailure(
          message: 'Formato de telefone inválido. Use o formato internacional (ex: +5511999999999)'
        ));
      }
      
      // Usar o novo método de fluxo completo para iniciar a verificação de telefone
      final verificationResult = await _authService.initiatePhoneVerificationFlow(phoneNumber);
      
      // Definir um timeout de 2 minutos para o código (120 segundos)
      final codeExpiration = DateTime.now().add(const Duration(minutes: 2));
      
      // Se foi auto-verificado (raro, acontece em alguns dispositivos Android)
      if (verificationResult['autoVerified'] == true) {
        final credential = verificationResult['credential'] as firebase_auth.PhoneAuthCredential;
        
        // Fazer login com a credencial
        final userCredential = await _authService.signInWithPhoneAuthCredential(credential);
        
        return Right(AuthCredential(
          uid: userCredential.user?.uid,
          phoneNumber: userCredential.user?.phoneNumber,
          isVerified: true,
          authMethod: AuthMethod.phone,
          verificationStatus: VerificationStatus.codeVerified,
        ));
      }
      
      // Caso normal - código SMS enviado para o usuário
      final verificationId = verificationResult['verificationId'] as String?;
      
      if (verificationId == null) {
        return Left(AuthFailure(message: 'Falha ao enviar código de verificação'));
      }
      
      return Right(AuthCredential(
        phoneNumber: phoneNumber,
        verificationId: verificationId,
        authMethod: AuthMethod.phone,
        codeExpiration: codeExpiration,
        verificationStatus: VerificationStatus.pendingCodeVerification,
      ));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Falha ao iniciar verificação de telefone'));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, AuthCredential>> verifyPhoneCode(String verificationId, String code) async {
    try {
      final credential = await _authService.signInWithPhoneAuthCredential(
        firebase_auth.PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: code,
        )
      );
      
      return Right(AuthCredential(
        uid: credential.user?.uid,
        phoneNumber: credential.user?.phoneNumber,
        verificationId: verificationId,
        verificationCode: code,
        isVerified: true,
        authMethod: AuthMethod.phone,
        verificationStatus: VerificationStatus.codeVerified,
      ));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Código de verificação inválido'));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> completeSignUp(
    AuthCredential credential, 
    String password,
    {String? name}
  ) async {
    try {
      // Verificar se a credencial está verificada
      if (!credential.isVerified) {
        return Left(AuthFailure(
          message: 'As credenciais não foram verificadas. Complete a verificação primeiro.'
        ));
      }
      
      // Se já temos um UID, atualizar senha do usuário existente
      if (credential.uid != null) {
        await _authService.updatePasswordForCurrentUser(password);
      } else {
        // Caso contrário, criar um novo usuário (não deve acontecer com o fluxo normal)
        final userCredential = await _authService.createUserWithEmailAndPassword(
          credential.email ?? credential.phoneNumber ?? '',
          password,
        );
        credential = credential.copyWith(uid: userCredential.user!.uid);
      }
      
      // Criar ou atualizar o perfil do usuário no Firestore
      final now = DateTime.now();
      final userData = {
        'name': name ?? '',
        'email': credential.email ?? '',
        'phoneNumber': credential.phoneNumber ?? '',
        'profileType': 'player', // Valor padrão para o app Player
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
        'isActive': true,
        'lastLoginAt': Timestamp.fromDate(now),
        'deviceTokens': [],
      };
      
      // Salvar no Firestore
      final document = _firestoreService.document('users/${credential.uid}');
      await document.set(userData);
      
      return Right(_mapFirestoreToUser(credential.uid!, userData));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Falha ao completar cadastro'));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> createUserFromCredential(
    AuthCredential credential, 
    {String? password, String? name}
  ) async {
    try {
      // Se já temos um UID, o usuário já existe no Firebase Auth
      String uid;
      
      if (credential.uid == null) {
        // Criar novo usuário no Firebase Auth
        final userCredential = await _authService.createUserWithEmailAndPassword(
          credential.email ?? credential.phoneNumber ?? '',
          password ?? '',
        );
        uid = userCredential.user!.uid;
      } else {
        uid = credential.uid!;
      }
      
      // Criar ou atualizar o perfil do usuário no Firestore
      final now = DateTime.now();
      final userData = {
        'name': name ?? '',
        'email': credential.email ?? '',
        'phoneNumber': credential.phoneNumber ?? '',
        'profileType': 'player', // Valor padrão para o app Player
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
        'isActive': true,
        'lastLoginAt': Timestamp.fromDate(now),
        'deviceTokens': [],
      };
      
      // Salvar no Firestore
      final document = _firestoreService.document('users/$uid');
      await document.set(userData);
      
      return Right(_mapFirestoreToUser(uid, userData));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> getUserProfile(String uid) async {
    try {
      final docRef = _firestoreService.document('users/$uid');
      final docSnapshot = await docRef.get();
      final userData = docSnapshot.data() as Map<String, dynamic>;
      
      if (userData == null) {
        return Left(AuthFailure(message: 'Usuário não encontrado'));
      }
      
      return Right(_mapFirestoreToUser(uid, userData));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, AuthCredential>> signInWithPhone(String phoneNumber) async {
    // Reutilizar o método existente de initiatePhoneVerification
    return initiatePhoneVerification(phoneNumber);
  }
  
  @override
  Future<Either<Failure, bool>> resetPassword(String email) async {
    try {
      await firebase_auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return const Right(true);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> updatePassword(String newPassword) async {
    try {
      await firebase_auth.FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
      return const Right(true);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> signOut() async {
    try {
      await _authService.signOut();
      return const Right(true);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        return const Right(null);
      }
      
      return getUserProfile(currentUser.uid);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> updateDeviceToken(String token) async {
    try {
      final user = _authService.currentUser;
      if (user == null) {
        return Left(AuthFailure(message: 'Usuário não autenticado'));
      }
      
      // Atualizar token no Firestore
      final docRef = _firestoreService.document('users/${user.uid}');
      await docRef.update({
        'deviceTokens': FieldValue.arrayUnion([token]),
      });
      
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
  
  @override
  Stream<User?> get authStateChanges => 
    _authService.authStateChanges.asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      
      final result = await getUserProfile(firebaseUser.uid);
      return result.fold(
        (failure) => null,
        (user) => user,
      );
    });
  
  @override
  Future<Either<Failure, bool>> resetPasswordViaEmail(String email) async {
    try {
      // Verificar se o email está registrado
      final isRegisteredResult = await isEmailRegistered(email);
      final isRegistered = isRegisteredResult.getOrElse(() => false);
      
      if (!isRegistered) {
        return Left(AuthFailure(message: 'Este email não está cadastrado em nossa plataforma.'));
      }
      
      // Enviar email de redefinição de senha
      await _authService.sendPasswordResetEmail(email);
      return const Right(true);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Falha ao enviar email de redefinição'));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, AuthCredential>> resetPasswordViaPhone(String phoneNumber) async {
    try {
      // Verificar se o telefone está registrado
      final isRegisteredResult = await isPhoneRegistered(phoneNumber);
      final isRegistered = isRegisteredResult.getOrElse(() => false);
      
      if (!isRegistered) {
        return Left(AuthFailure(message: 'Este número de telefone não está cadastrado em nossa plataforma.'));
      }
      
      // Iniciar processo de verificação de telefone para redefinição de senha
      final credential = await _authService.initiatePasswordResetByPhone(phoneNumber);
      
      // Se o credential for null, o código foi enviado para o usuário
      if (credential == null) {
        return Right(AuthCredential(
          phoneNumber: phoneNumber,
          isVerified: false,
        ));
      }
      
      // Se chegamos aqui, a verificação foi concluída automaticamente (Android)
      return Right(AuthCredential(
        phoneNumber: phoneNumber,
        isVerified: true,
      ));
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Falha ao iniciar redefinição de senha via telefone'));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, AuthCredential>> verifyPasswordResetCode(String verificationId, String code) async {
    try {
      // Criar credencial de autenticação por telefone
      final credential = firebase_auth.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: code,
      );
      
      // Utilizar o SignInWithCredential para verificar o código
      await _authService.signInWithPhoneAuthCredential(credential);
      
      // Se chegamos aqui, o código é válido
      return Right(AuthCredential(
        isVerified: true,
        verificationId: verificationId,
      ));
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Falha ao verificar código'));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> confirmPasswordReset(String newPassword, {String? verificationCode}) async {
    try {
      // Se temos um código de verificação, é uma redefinição via email
      if (verificationCode != null) {
        await _authService.confirmPasswordReset(verificationCode, newPassword);
      } else {
        // Se não temos um código, é uma redefinição via telefone (já autenticado)
        await _authService.updatePasswordForCurrentUser(newPassword);
      }
      
      return const Right(true);
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Falha ao redefinir senha'));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
}