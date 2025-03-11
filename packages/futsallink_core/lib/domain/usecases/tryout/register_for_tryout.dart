import 'package:dartz/dartz.dart';
import '../../core/failures.dart';
import '../../repositories/tryout_repository.dart';
import '../usecase.dart';

class RegisterForTryoutParams {
  final String tryoutId;
  final String playerId;

  RegisterForTryoutParams({
    required this.tryoutId,
    required this.playerId,
  });
}

class RegisterForTryout implements UseCase<void, RegisterForTryoutParams> {
  final TryoutRepository repository;

  RegisterForTryout(this.repository);

  @override
  Future<Either<Failure, void>> call(RegisterForTryoutParams params) {
    return repository.registerPlayerForTryout(
      params.tryoutId,
      params.playerId,
    );
  }
}