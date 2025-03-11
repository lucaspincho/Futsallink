import 'package:equatable/equatable.dart';

class Video extends Equatable {
  final String id;
  final String playerId;
  final String title;
  final String description;
  final String url;
  final String thumbnailUrl;
  final int duration;
  final int views;
  final int likes;
  final int fileSize;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Video({
    required this.id,
    required this.playerId,
    required this.title,
    required this.description,
    required this.url,
    required this.thumbnailUrl,
    required this.duration,
    required this.views,
    required this.likes,
    required this.fileSize,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, playerId, url];
}