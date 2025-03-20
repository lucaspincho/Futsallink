import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:futsallink_core/domain/core/failures.dart';
import 'package:futsallink_core/domain/entities/player.dart';
import 'package:futsallink_core/domain/repositories/player_repository.dart';
import 'package:futsallink_core/domain/usecases/usecase.dart';

class GetPlayer implements UseCase<Player, GetPlayerParams> {
  final PlayerRepository repository;

  GetPlayer(this.repository);

  @override
  Future<Either<Failure, Player>> call(GetPlayerParams params) async {
    return await repository.getPlayer(params.uid);
  }
}

class GetPlayerParams extends Equatable {
  final String uid;

  const GetPlayerParams({required this.uid});

  @override
  List<Object?> get props => [uid];
}