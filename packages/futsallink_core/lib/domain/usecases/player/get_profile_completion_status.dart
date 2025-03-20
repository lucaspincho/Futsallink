import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:futsallink_core/domain/core/failures.dart';
import 'package:futsallink_core/domain/usecases/usecase.dart';
import 'package:futsallink_core/domain/entities/player.dart';
import 'package:futsallink_core/domain/repositories/player_repository.dart';

class GetProfileCompletionStatus implements UseCase<ProfileCompletionStatus, GetProfileCompletionStatusParams> {
  final PlayerRepository repository;

  GetProfileCompletionStatus(this.repository);

  @override
  Future<Either<Failure, ProfileCompletionStatus>> call(GetProfileCompletionStatusParams params) async {
    return await repository.getProfileCompletionStatus(params.uid);
  }
}

class GetProfileCompletionStatusParams extends Equatable {
  final String uid;

  const GetProfileCompletionStatusParams({required this.uid});

  @override
  List<Object?> get props => [uid];
} 