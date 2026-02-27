import 'package:fpdart/fpdart.dart';
import 'package:simple_chat/core/errors/failures.dart';
import 'package:simple_chat/features/chats/domain/entities/message_page.dart';

import '../repositories/chat_repository.dart';

class GetMessagesUsecase {
  final ChatRepository chatRepository;
  GetMessagesUsecase(this.chatRepository);

  Future<Either<Failure, MessagePage>> getMessages(String conversationId) {
    return chatRepository.getMessages(conversationId);
  }
}
