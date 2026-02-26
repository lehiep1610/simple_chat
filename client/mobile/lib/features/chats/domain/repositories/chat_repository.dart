import 'package:fpdart/fpdart.dart';
import 'package:simple_chat/core/errors/failures.dart';
import 'package:simple_chat/features/chats/domain/entities/conversation.dart';
import 'package:simple_chat/features/chats/domain/entities/conversation_summary.dart';
import 'package:simple_chat/features/chats/domain/entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, Conversation>> getDirectConversation(String friendId);
  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String senderId,
    required String body,
    String messageType = 'text',
  });
  Future<Either<Failure, List<ConversationSummary>>> getConversationSummaries();
}
