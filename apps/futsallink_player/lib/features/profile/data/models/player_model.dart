import 'package:futsallink_core/futsallink_core.dart';

class PlayerModel extends Player {
  const PlayerModel({
    required String uid,
    required String firstName,
    required String lastName,
    String? nickname,
    required String position,
    required DateTime birthday,
    required int height,
    required double weight,
    required String dominantFoot,
    String? bio,
    String? currentTeam,
    LocationInfo? location,
    String? profileImage,
    List<String>? videos,
    SocialMedia? socialMedia,
    required DateTime createdAt,
    required DateTime updatedAt,
    bool profileCompleted = false,
    int lastCompletedStep = 0,
    ProfileCompletionStatus completionStatus = ProfileCompletionStatus.none,
  }) : super(
          uid: uid,
          firstName: firstName,
          lastName: lastName,
          nickname: nickname,
          position: position,
          birthday: birthday,
          height: height,
          weight: weight,
          dominantFoot: dominantFoot,
          bio: bio,
          currentTeam: currentTeam,
          location: location,
          profileImage: profileImage,
          videos: videos,
          socialMedia: socialMedia,
          createdAt: createdAt,
          updatedAt: updatedAt,
          profileCompleted: profileCompleted,
          lastCompletedStep: lastCompletedStep,
          completionStatus: completionStatus,
        );

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    final bool profileCompleted = json['profileCompleted'] as bool? ?? false;
    final int lastCompletedStep = json['lastCompletedStep'] as int? ?? 0;
    
    ProfileCompletionStatus completionStatus;
    if (json['completionStatus'] != null) {
      final int statusIndex = json['completionStatus'] as int;
      completionStatus = ProfileCompletionStatus.values[statusIndex];
    } else if (profileCompleted) {
      completionStatus = ProfileCompletionStatus.complete;
    } else if (lastCompletedStep > 0) {
      completionStatus = ProfileCompletionStatus.partial;
    } else {
      completionStatus = ProfileCompletionStatus.none;
    }

    return PlayerModel(
      uid: json['uid'] as String,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      nickname: json['nickname'] as String?,
      position: json['position'] as String? ?? '',
      birthday: json['birthday'] != null 
          ? DateTime.parse(json['birthday'] as String) 
          : DateTime.now().subtract(const Duration(days: 365 * 18)),
      height: json['height'] as int? ?? 0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      dominantFoot: json['dominantFoot'] as String? ?? '',
      bio: json['bio'] as String?,
      currentTeam: json['currentTeam'] as String?,
      location: json['location'] != null
          ? LocationInfoModel.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      profileImage: json['profileImage'] as String?,
      videos: json['videos'] != null
          ? List<String>.from(json['videos'] as List)
          : null,
      socialMedia: json['socialMedia'] != null
          ? SocialMediaModel.fromJson(
              json['socialMedia'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String) 
          : DateTime.now(),
      profileCompleted: profileCompleted,
      lastCompletedStep: lastCompletedStep,
      completionStatus: completionStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'nickname': nickname,
      'position': position,
      'birthday': birthday.toIso8601String(),
      'height': height,
      'weight': weight,
      'dominantFoot': dominantFoot,
      'bio': bio,
      'currentTeam': currentTeam,
      'location': location != null
          ? (location as LocationInfoModel).toJson()
          : null,
      'profileImage': profileImage,
      'videos': videos,
      'socialMedia': socialMedia != null
          ? (socialMedia as SocialMediaModel).toJson()
          : null,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'profileCompleted': profileCompleted,
      'lastCompletedStep': lastCompletedStep,
      'completionStatus': completionStatus.index,
    };
  }

  factory PlayerModel.empty(String uid) {
    final now = DateTime.now();
    return PlayerModel(
      uid: uid,
      firstName: '',
      lastName: '',
      position: '',
      birthday: DateTime(now.year - 18, 1, 1),
      height: 0,
      weight: 0.0,
      dominantFoot: '',
      createdAt: now,
      updatedAt: now,
      lastCompletedStep: 0,
      completionStatus: ProfileCompletionStatus.none,
    );
  }

  PlayerModel copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? nickname,
    String? position,
    DateTime? birthday,
    int? height,
    double? weight,
    String? dominantFoot,
    String? bio,
    String? currentTeam,
    LocationInfo? location,
    String? profileImage,
    List<String>? videos,
    SocialMedia? socialMedia,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? profileCompleted,
    int? lastCompletedStep,
    ProfileCompletionStatus? completionStatus,
  }) {
    return PlayerModel(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickname: nickname ?? this.nickname,
      position: position ?? this.position,
      birthday: birthday ?? this.birthday,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      dominantFoot: dominantFoot ?? this.dominantFoot,
      bio: bio ?? this.bio,
      currentTeam: currentTeam ?? this.currentTeam,
      location: location ?? this.location,
      profileImage: profileImage ?? this.profileImage,
      videos: videos ?? this.videos,
      socialMedia: socialMedia ?? this.socialMedia,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profileCompleted: profileCompleted ?? this.profileCompleted,
      lastCompletedStep: lastCompletedStep ?? this.lastCompletedStep,
      completionStatus: completionStatus ?? this.completionStatus,
    );
  }
}

class LocationInfoModel extends LocationInfo {
  const LocationInfoModel({
    required String city,
    required String state,
    required String country,
  }) : super(
          city: city,
          state: state,
          country: country,
        );

  factory LocationInfoModel.fromJson(Map<String, dynamic> json) {
    return LocationInfoModel(
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'state': state,
      'country': country,
    };
  }
}

class SocialMediaModel extends SocialMedia {
  const SocialMediaModel({
    String? instagram,
    String? youtube,
    String? tiktok,
  }) : super(
          instagram: instagram,
          youtube: youtube,
          tiktok: tiktok,
        );

  factory SocialMediaModel.fromJson(Map<String, dynamic> json) {
    return SocialMediaModel(
      instagram: json['instagram'] as String?,
      youtube: json['youtube'] as String?,
      tiktok: json['tiktok'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'instagram': instagram,
      'youtube': youtube,
      'tiktok': tiktok,
    };
  }
} 