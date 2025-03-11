import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String recipientId;
  final String text;
  final String? mediaUrl;
  final String? mediaType;
  final DateTime time;
  final bool read;
  final DateTime? readAt;
  final String status;
  final String? replyTo;
  final bool isDeleted;

  const Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.recipientId,
    required this.text,
    this.mediaUrl,
    this.mediaType,
    required this.time,
    required this.read,
    this.readAt,
    required this.status,
    this.replyTo,
    required this.isDeleted,
  });

  @override
  List<Object?> get props => [id, chatId, senderId, time];
}