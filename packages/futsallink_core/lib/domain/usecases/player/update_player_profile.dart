import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:futsallink_core/domain/core/failures.dart';
import 'package:futsallink_core/domain/entities/player.dart';
import 'package:futsallink_core/domain/repositories/player_repository.dart';
import 'package:futsallink_core/domain/usecases/usecase.dart';

class UpdatePlayerProfile implements UseCase<Player, UpdatePlayerProfileParams> {
  final PlayerRepository repository;

  UpdatePlayerProfile(this.repository);

  @override
  Future<Either<Failure, Player>> call(UpdatePlayerProfileParams params) async {
    return await repository.updatePlayer(params.player);
  }
}

class UpdatePlayerProfileParams extends Equatable {
  final Player player;

  const UpdatePlayerProfileParams({required this.player});

  @override
  List<Object?> get props => [player];
} 