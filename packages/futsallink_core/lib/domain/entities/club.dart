import 'package:equatable/equatable.dart';

class Club extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String logo;
  final String coverImage;
  final String description;
  final ClubLocation location;
  final ContactInfo contactInfo;
  final List<String> currentTryouts;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Club({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.logo,
    required this.coverImage,
    required this.description,
    required this.location,
    required this.contactInfo,
    required this.currentTryouts,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [uid, name, email];
}

class ClubLocation extends Equatable {
  final String address;
  final String city;
  final String state;
  final String country;

  const ClubLocation({
    required this.address,
    required this.city,
    required this.state,
    required this.country,
  });

  @override
  List<Object?> get props => [address, city, state, country];
}

class ContactInfo extends Equatable {
  final String? website;
  final String? instagram;
  final String? tiktok;
  final String? youtube;

  const ContactInfo({
    this.website,
    this.instagram,
    this.tiktok,
    this.youtube,
  });

  @override
  List<Object?> get props => [website, instagram, tiktok, youtube];
}