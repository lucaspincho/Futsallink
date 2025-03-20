import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:futsallink_core/futsallink_core.dart';
import 'package:futsallink_player/features/profile/data/datasources/player_remote_data_source.dart';
import 'package:futsallink_player/features/profile/data/models/player_model.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final PlayerRemoteDataSource remoteDataSource;

  PlayerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Player>> createPlayer(Player player) async {
    try {
      final playerModel = player as PlayerModel;
      final result = await remoteDataSource.createPlayer(playerModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Player>> updatePlayer(Player player) async {
    try {
      final playerModel = player as PlayerModel;
      final result = await remoteDataSource.updatePlayer(playerModel);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfileImage(String uid, File imageFile) async {
    try {
      final result = await remoteDataSource.uploadProfileImage(uid, imageFile);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Player>> getPlayer(String uid) async {
    try {
      final result = await remoteDataSource.getPlayer(uid);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileCompletionStatus>> getProfileCompletionStatus(String uid) async {
    print('[PlayerRepository] Iniciando verificação de status do perfil para usuário: $uid');
    try {
      print('[PlayerRepository] Chamando remoteDataSource.getPlayer');
      final player = await remoteDataSource.getPlayer(uid);
      print('[PlayerRepository] Status do perfil recebido: ${player.completionStatus}');
      return Right(player.completionStatus);
    } catch (e) {
      print('[PlayerRepository] Erro ao verificar status do perfil: $e');
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Player>> savePartialProfile(Player player) async {
    try {
      final playerModel = player as PlayerModel;
      final updatedPlayer = playerModel.copyWith(
        updatedAt: DateTime.now(),
        completionStatus: ProfileCompletionStatus.partial,
      );
      final result = await remoteDataSource.updatePlayer(updatedPlayer);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getLastCompletedStep(String uid) async {
    try {
      final player = await remoteDataSource.getPlayer(uid);
      return Right(player.lastCompletedStep);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> checkProfileExists(String uid) async {
    try {
      final result = await remoteDataSource.checkProfileExists(uid);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> completePlayerProfile(String uid) async {
    try {
      final result = await remoteDataSource.completePlayerProfile(uid);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Player>> createPlayerProfile(Player player) async {
    // Reutiliza o método existente
    return createPlayer(player);
  }

  @override
  Future<Either<Failure, Player>> updatePlayerProfile(Player player) async {
    // Reutiliza o método existente
    return updatePlayer(player);
  }

  @override
  Future<Either<Failure, List<Player>>> searchPlayers({
    String? query,
    String? position,
    String? location,
    int? minAge,
    int? maxAge,
  }) {
    // Não implementado pois não é necessário para o fluxo de criação de perfil
    return Future.value(Left(ServerFailure(message: 'Método não implementado')));
  }

  @override
  Future<Either<Failure, void>> updatePlayerField(String uid, String field, dynamic value) {
    // Não implementado pois não é necessário para o fluxo de criação de perfil
    return Future.value(Left(ServerFailure(message: 'Método não implementado')));
  }

  @override
  Future<Either<Failure, void>> addVideoToPlayer(String uid, String videoId) {
    // Não implementado pois não é necessário para o fluxo de criação de perfil
    return Future.value(Left(ServerFailure(message: 'Método não implementado')));
  }

  @override
  Future<Either<Failure, void>> removeVideoFromPlayer(String uid, String videoId) {
    // Não implementado pois não é necessário para o fluxo de criação de perfil
    return Future.value(Left(ServerFailure(message: 'Método não implementado')));
  }

  @override
  Future<Either<Failure, List<Player>>> getTryoutParticipants(String tryoutId) {
    // Não implementado pois não é necessário para o fluxo de criação de perfil
    return Future.value(Left(ServerFailure(message: 'Método não implementado')));
  }
} 