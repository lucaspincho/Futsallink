import 'package:dartz/dartz.dart';
import '../core/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithEmailAndPassword(String email, String password);
  Future<Either<Failure, User>> signInWithPhone(String phoneNumber);
  Future<Either<Failure, String>> verifyPhoneOTP(String verificationId, String code);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, void>> updateDeviceToken(String token);
  Stream<User?> get authStateChanges;
}