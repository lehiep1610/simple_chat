import 'package:fpdart/fpdart.dart';
import 'package:simple_chat/core/errors/failures.dart';
import 'package:simple_chat/features/chat/domain/entities/conversation.dart';
import 'package:simple_chat/features/chat/domain/entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, Conversation>> getDirectConversation(String friendId);
  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String senderId,
    required String body,
    String messageType = 'text',
  });
}
