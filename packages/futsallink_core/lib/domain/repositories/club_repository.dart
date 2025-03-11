import 'package:dartz/dartz.dart';
import '../core/failures.dart';
import '../entities/club.dart';

abstract class ClubRepository {
  Future<Either<Failure, Club>> getClub(String uid);
  Future<Either<Failure, List<Club>>> searchClubs({String? query, String? location});
  Future<Either<Failure, Club>> createClub(Club club);
  Future<Either<Failure, Club>> updateClub(Club club);
  Future<Either<Failure, void>> updateClubField(String uid, String field, dynamic value);
  Future<Either<Failure, void>> addTryoutToClub(String uid, String tryoutId);
  Future<Either<Failure, void>> removeTryoutFromClub(String uid, String tryoutId);
}