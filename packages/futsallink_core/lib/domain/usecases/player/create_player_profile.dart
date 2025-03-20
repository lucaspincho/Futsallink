import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:futsallink_core/domain/core/failures.dart';
import 'package:futsallink_core/domain/entities/player.dart';
import 'package:futsallink_core/domain/repositories/player_repository.dart';
import 'package:futsallink_core/domain/usecases/usecase.dart';

class CreatePlayerProfile implements UseCase<Player, CreatePlayerProfileParams> {
  final PlayerRepository repository;

  CreatePlayerProfile(this.repository);

  @override
  Future<Either<Failure, Player>> call(CreatePlayerProfileParams params) async {
    return await repository.createPlayer(params.player);
  }
}

class CreatePlayerProfileParams extends Equatable {
  final Player player;

  const CreatePlayerProfileParams({required this.player});

  @override
  List<Object?> get props => [player];
} 