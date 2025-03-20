import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:futsallink_core/domain/core/failures.dart';
import 'package:futsallink_core/domain/usecases/usecase.dart';
import 'package:futsallink_core/domain/entities/player.dart';
import 'package:futsallink_core/domain/repositories/player_repository.dart';

class SavePartialProfile implements UseCase<Player, SavePartialProfileParams> {
  final PlayerRepository repository;

  SavePartialProfile(this.repository);

  @override
  Future<Either<Failure, Player>> call(SavePartialProfileParams params) async {
    // Atualizamos o campo lastCompletedStep antes de salvar
    final playerWithStep = params.player;
    
    return await repository.savePartialProfile(playerWithStep);
  }
}

class SavePartialProfileParams extends Equatable {
  final Player player;
  final int lastCompletedStep;

  SavePartialProfileParams({
    required this.player,
    required this.lastCompletedStep,
  });

  @override
  List<Object?> get props => [player, lastCompletedStep];
} 