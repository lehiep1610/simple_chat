import 'package:fpdart/fpdart.dart';
import 'package:simple_chat/core/errors/failures.dart';
import 'package:simple_chat/features/chat/domain/entities/conversation.dart';
import 'package:simple_chat/features/chat/domain/entities/message.dart';
import 'package:simple_chat/features/chat/domain/repositories/chat_repository.dart';

class GetConversationUsecase {
  final ChatRepository chatRepository;
  GetConversationUsecase(this.chatRepository);

  Future<Either<Failure, Conversation>> getDirectConversation(String friendId) {
    return chatRepository.getDirectConversation(friendId);
  }

  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String senderId,
    required String body,
    String messageType = 'text',
  }) {
    return chatRepository.sendMessage(
      conversationId: conversationId,
      senderId: senderId,
      body: body,
      messageType: messageType,
    );
  }
}
