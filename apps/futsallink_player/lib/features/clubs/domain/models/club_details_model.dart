import 'package:futsallink_player/features/home/domain/models/tryout_model.dart';

class ClubDetailsModel {
  final String id;
  final String name;
  final String logoUrl;
  final String description;
  final List<String> categories;
  final List<String> positions;
  final List<TryoutModel> tryouts;

  ClubDetailsModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.description,
    required this.categories,
    required this.positions,
    required this.tryouts,
  });

  // De JSON para modelo
  factory ClubDetailsModel.fromJson(Map<String, dynamic> json) {
    return ClubDetailsModel(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String,
      description: json['description'] as String,
      categories: List<String>.from(json['categories'] as List),
      positions: List<String>.from(json['positions'] as List),
      tryouts: (json['tryouts'] as List)
          .map((tryout) => TryoutModel.fromJson(tryout as Map<String, dynamic>))
          .toList(),
    );
  }

  // De modelo para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'description': description,
      'categories': categories,
      'positions': positions,
      'tryouts': tryouts.map((tryout) => tryout.toJson()).toList(),
    };
  }
} 