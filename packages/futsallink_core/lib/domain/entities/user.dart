import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String profileType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final DateTime lastLoginAt;
  final List<String> deviceTokens;

  const User({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profileType,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.lastLoginAt,
    required this.deviceTokens,
  });

  @override
  List<Object?> get props => [uid, email, profileType];
}