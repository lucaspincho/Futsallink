import 'package:dartz/dartz.dart';
import '../core/failures.dart';
import '../entities/video.dart';

abstract class VideoRepository {
  Future<Either<Failure, Video>> getVideo(String id);
  Future<Either<Failure, List<Video>>> getPlayerVideos(String playerId);
  Future<Either<Failure, Video>> createVideo(Video video, String filePath);
  Future<Either<Failure, void>> deleteVideo(String id);
  Future<Either<Failure, Video>> updateVideo(Video video);
  Future<Either<Failure, void>> incrementViewCount(String videoId);
  Future<Either<Failure, void>> likeVideo(String videoId, String userId);
  Future<Either<Failure, void>> unlikeVideo(String videoId, String userId);
  Future<Either<Failure, String>> generateThumbnail(String videoPath);
  Future<Either<Failure, int>> getVideoDuration(String videoPath);
}