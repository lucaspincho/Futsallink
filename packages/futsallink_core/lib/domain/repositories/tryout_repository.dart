import 'package:dartz/dartz.dart';
import '../core/failures.dart';
import '../entities/tryout.dart';

abstract class TryoutRepository {
  Future<Either<Failure, Tryout>> getTryout(String id);
  Future<Either<Failure, List<Tryout>>> getOpenTryouts();
  Future<Either<Failure, List<Tryout>>> getClubTryouts(String clubId);
  Future<Either<Failure, List<Tryout>>> getPlayerRegisteredTryouts(String playerId);
  Future<Either<Failure, Tryout>> createTryout(Tryout tryout);
  Future<Either<Failure, Tryout>> updateTryout(Tryout tryout);
  Future<Either<Failure, void>> updateTryoutStatus(String id, String status);
  Future<Either<Failure, void>> deleteTryout(String id);
  Future<Either<Failure, void>> registerPlayerForTryout(String tryoutId, String playerId);
  Future<Either<Failure, void>> unregisterPlayerFromTryout(String tryoutId, String playerId);
}