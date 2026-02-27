import 'package:fpdart/fpdart.dart';
import 'package:simple_chat/core/errors/failures.dart';
import 'package:simple_chat/features/chats/domain/entities/conversation_summary.dart';
import 'package:simple_chat/features/chats/domain/entities/message.dart';
import 'package:simple_chat/features/chats/domain/entities/message_page.dart';

abstract class ChatRepository {
  Future<Either<Failure, String>> getDirectConversation(String friendId);
  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String senderId,
    required String body,
    String messageType = 'text',
  });
  Future<Either<Failure, MessagePage>> getMessages(
    String conversationId, {
    int limit = 50,
    int offset = 0,
  });
  Future<Either<Failure, List<ConversationSummary>>> getConversationSummaries();
}
