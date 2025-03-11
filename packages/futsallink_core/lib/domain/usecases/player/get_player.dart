import 'package:dartz/dartz.dart';
import '../../core/failures.dart';
import '../../entities/player.dart';
import '../../repositories/player_repository.dart';
import '../usecase.dart';

class GetPlayerParams {
  final String id;

  GetPlayerParams({required this.id});
}

class GetPlayer implements UseCase<Player, GetPlayerParams> {
  final PlayerRepository repository;

  GetPlayer(this.repository);

  @override
  Future<Either<Failure, Player>> call(GetPlayerParams params) {
    return repository.getPlayer(params.id);
  }
}