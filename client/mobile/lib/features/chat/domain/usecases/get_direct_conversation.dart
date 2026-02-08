import 'package:fpdart/fpdart.dart';
import 'package:simple_chat/core/errors/failures.dart';
import 'package:simple_chat/features/chat/domain/entities/conversation.dart';
import 'package:simple_chat/features/chat/domain/repositories/chat_repository.dart';

class GetConversationUsecase {
  final ChatRepository chatRepository;
  GetConversationUsecase(this.chatRepository);

  Future<Either<Failure, Conversation>> call(String friendId) {
    return chatRepository.getDirectConversation(friendId);
  }
}
