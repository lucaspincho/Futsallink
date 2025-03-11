import 'package:dartz/dartz.dart';
import '../core/failures.dart';
import '../entities/chat.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, Chat>> getChat(String id);
  Future<Either<Failure, Chat?>> getChatByParticipants(List<String> participantIds);
  Future<Either<Failure, List<Chat>>> getUserChats(String userId);
  Future<Either<Failure, Chat>> createChat(List<String> participantIds);
  
  Future<Either<Failure, Message>> sendMessage(Message message);
  Future<Either<Failure, List<Message>>> getChatMessages(
    String chatId, {int limit = 20, DateTime? before}
  );
  Future<Either<Failure, void>> markMessageAsRead(String messageId);
  Future<Either<Failure, void>> markAllChatMessagesAsRead(String chatId, String userId);
  Future<Either<Failure, void>> deleteMessage(String messageId);
  
  Stream<List<Chat>> userChatsStream(String userId);
  Stream<List<Message>> chatMessagesStream(String chatId);
}