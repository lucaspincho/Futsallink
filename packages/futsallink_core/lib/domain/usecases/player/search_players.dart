import 'package:dartz/dartz.dart';
import '../../core/failures.dart';
import '../../entities/player.dart';
import '../../repositories/player_repository.dart';
import '../usecase.dart';

class SearchPlayersParams {
  final String? query;
  final String? position;
  final int? minAge;
  final int? maxAge;

  SearchPlayersParams({
    this.query,
    this.position,
    this.minAge,
    this.maxAge,
  });
}

class SearchPlayers implements UseCase<List<Player>, SearchPlayersParams> {
  final PlayerRepository repository;

  SearchPlayers(this.repository);

  @override
  Future<Either<Failure, List<Player>>> call(SearchPlayersParams params) {
    return repository.searchPlayers(
      query: params.query,
      position: params.position,
      minAge: params.minAge,
      maxAge: params.maxAge,
    );
  }
}