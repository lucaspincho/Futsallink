import 'package:equatable/equatable.dart';

class Tryout extends Equatable {
  final String id;
  final String clubId;
  final String title;
  final String description;
  final List<String> positions;
  final String status; // "open", "closed", "completed"
  final DateTime applicationDeadline;
  final List<Participant> participants;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Tryout({
    required this.id,
    required this.clubId,
    required this.title,
    required this.description,
    required this.positions,
    required this.status,
    required this.applicationDeadline,
    required this.participants,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isOpen => status == 'open';
  bool get isClosed => status == 'closed' || status == 'completed';

  @override
  List<Object?> get props => [id, clubId, title, status];
}

class Participant extends Equatable {
  final String playerId;
  final DateTime registeredAt;

  const Participant({
    required this.playerId,
    required this.registeredAt,
  });

  @override
  List<Object?> get props => [playerId, registeredAt];
}