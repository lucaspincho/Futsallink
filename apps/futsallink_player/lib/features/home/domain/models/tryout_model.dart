class TryoutModel {
  final String id;
  final String clubId;
  final String clubName;
  final String clubLogoUrl;
  final String category;
  final String position;
  final bool isOpen;

  TryoutModel({
    required this.id,
    required this.clubId,
    required this.clubName,
    required this.clubLogoUrl,
    required this.category,
    required this.position,
    this.isOpen = true,
  });

  // De JSON para modelo
  factory TryoutModel.fromJson(Map<String, dynamic> json) {
    return TryoutModel(
      id: json['id'] as String,
      clubId: json['clubId'] as String,
      clubName: json['clubName'] as String,
      clubLogoUrl: json['clubLogoUrl'] as String,
      category: json['category'] as String,
      position: json['position'] as String,
      isOpen: json['isOpen'] as bool? ?? true,
    );
  }

  // De modelo para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clubId': clubId,
      'clubName': clubName,
      'clubLogoUrl': clubLogoUrl,
      'category': category,
      'position': position,
      'isOpen': isOpen,
    };
  }
} 