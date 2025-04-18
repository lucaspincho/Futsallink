import 'dart:io';
import 'package:dartz/dartz.dart';
import '../core/failures.dart';
import '../entities/player.dart';

abstract class PlayerRepository {
  Future<Either<Failure, Player>> getPlayer(String uid);
  Future<Either<Failure, List<Player>>> searchPlayers({
    String? query,
    String? position,
    String? location,
    int? minAge,
    int? maxAge,
  });
  Future<Either<Failure, Player>> createPlayer(Player player);
  Future<Either<Failure, Player>> updatePlayer(Player player);
  Future<Either<Failure, void>> updatePlayerField(String uid, String field, dynamic value);
  Future<Either<Failure, void>> addVideoToPlayer(String uid, String videoId);
  Future<Either<Failure, void>> removeVideoFromPlayer(String uid, String videoId);
  Future<Either<Failure, List<Player>>> getTryoutParticipants(String tryoutId);
  Future<Either<Failure, String>> uploadProfileImage(String uid, File imageFile);
  Future<Either<Failure, bool>> checkProfileExists(String uid);
  Future<Either<Failure, bool>> completePlayerProfile(String uid);
  Future<Either<Failure, Player>> createPlayerProfile(Player player);
  Future<Either<Failure, Player>> updatePlayerProfile(Player player);
  Future<Either<Failure, ProfileCompletionStatus>> getProfileCompletionStatus(String uid);
  Future<Either<Failure, Player>> savePartialProfile(Player player);
  Future<Either<Failure, int>> getLastCompletedStep(String uid);
}