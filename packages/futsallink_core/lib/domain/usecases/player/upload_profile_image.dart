import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:futsallink_core/domain/core/failures.dart';
import 'package:futsallink_core/domain/repositories/player_repository.dart';
import 'package:futsallink_core/domain/usecases/usecase.dart';

class UploadProfileImage implements UseCase<String, UploadProfileImageParams> {
  final PlayerRepository repository;

  UploadProfileImage(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadProfileImageParams params) async {
    return await repository.uploadProfileImage(params.uid, params.imageFile);
  }
}

class UploadProfileImageParams extends Equatable {
  final String uid;
  final File imageFile;

  const UploadProfileImageParams({
    required this.uid, 
    required this.imageFile,
  });

  @override
  List<Object?> get props => [uid, imageFile];
} 