import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String id;
  final List<String> participants;
  final LastMessage lastMessage;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Chat({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, participants, lastMessage.time];
}

class LastMessage extends Equatable {
  final String text;
  final String senderId;
  final DateTime time;
  final bool read;
  final String type;

  const LastMessage({
    required this.text,
    required this.senderId,
    required this.time,
    required this.read,
    required this.type,
  });

  @override
  List<Object?> get props => [senderId, time, text];
}