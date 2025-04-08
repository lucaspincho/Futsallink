class ClubModel {
  final String id;
  final String name;
  final String logoUrl;
  final List<String> categories;
  final List<String> positions;
  final bool hasTryouts;

  ClubModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.categories,
    required this.positions,
    this.hasTryouts = false,
  });

  // De JSON para modelo
  factory ClubModel.fromJson(Map<String, dynamic> json) {
    return ClubModel(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String,
      categories: List<String>.from(json['categories'] as List),
      positions: List<String>.from(json['positions'] as List),
      hasTryouts: json['hasTryouts'] as bool? ?? false,
    );
  }

  // De modelo para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'categories': categories,
      'positions': positions,
      'hasTryouts': hasTryouts,
    };
  }
} 