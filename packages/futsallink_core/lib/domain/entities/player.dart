// lib/domain/entities/player.dart
import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final String uid;
  final String firstName;
  final String lastName;
  final String? nickname;
  final String position;
  final DateTime birthday;
  final int height;
  final double weight;
  final String dominantFoot;
  final String? bio;
  final String? currentTeam;
  final LocationInfo? location;
  final String? profileImage;
  final List<String>? videos;
  final SocialMedia? socialMedia;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool profileCompleted;
  final int lastCompletedStep;
  final ProfileCompletionStatus completionStatus;

  const Player({
    required this.uid,
    required this.firstName,
    required this.lastName,
    this.nickname,
    required this.position,
    required this.birthday,
    required this.height,
    required this.weight,
    required this.dominantFoot,
    this.bio,
    this.currentTeam,
    this.location,
    this.profileImage,
    this.videos,
    this.socialMedia,
    required this.createdAt,
    required this.updatedAt,
    this.profileCompleted = false,
    this.lastCompletedStep = 0,
    this.completionStatus = ProfileCompletionStatus.none,
  });

  String get fullName => '$firstName $lastName';

  int get age {
    final today = DateTime.now();
    int age = today.year - birthday.year;
    if (today.month < birthday.month || 
        (today.month == birthday.month && today.day < birthday.day)) {
      age--;
    }
    return age;
  }

  @override
  List<Object?> get props => [
        uid,
        firstName,
        lastName,
        nickname,
        position,
        birthday,
        height,
        weight,
        dominantFoot,
        bio,
        currentTeam,
        location,
        profileImage,
        videos,
        socialMedia,
        createdAt,
        updatedAt,
        profileCompleted,
        lastCompletedStep,
        completionStatus,
      ];
}

class LocationInfo extends Equatable {
  final String city;
  final String state;
  final String country;

  const LocationInfo({
    required this.city,
    required this.state,
    required this.country,
  });

  @override
  List<Object?> get props => [city, state, country];
}

class SocialMedia extends Equatable {
  final String? instagram;
  final String? youtube;
  final String? tiktok;

  const SocialMedia({
    this.instagram,
    this.youtube,
    this.tiktok,
  });

  @override
  List<Object?> get props => [instagram, youtube, tiktok];
}

enum ProfileCompletionStatus {
  none,
  partial,
  complete,
}