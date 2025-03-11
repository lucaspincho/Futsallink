import 'package:dartz/dartz.dart';
import '../../core/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';
import '../usecase.dart';

class SignInWithEmailParams {
  final String email;
  final String password;

  SignInWithEmailParams({required this.email, required this.password});
}

class SignInWithEmail implements UseCase<User, SignInWithEmailParams> {
  final AuthRepository repository;

  SignInWithEmail(this.repository);

  @override
  Future<Either<Failure, User>> call(SignInWithEmailParams params) {
    return repository.signInWithEmailAndPassword(params.email, params.password);
  }
}