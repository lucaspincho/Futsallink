import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:futsallink_core/domain/core/failures.dart';
import 'package:futsallink_core/domain/usecases/usecase.dart';
import 'package:futsallink_core/domain/repositories/player_repository.dart';

class GetLastCompletedStep implements UseCase<int, GetLastCompletedStepParams> {
  final PlayerRepository repository;

  GetLastCompletedStep(this.repository);

  @override
  Future<Either<Failure, int>> call(GetLastCompletedStepParams params) async {
    return await repository.getLastCompletedStep(params.uid);
  }
}

class GetLastCompletedStepParams extends Equatable {
  final String uid;

  const GetLastCompletedStepParams({required this.uid});

  @override
  List<Object?> get props => [uid];
} 