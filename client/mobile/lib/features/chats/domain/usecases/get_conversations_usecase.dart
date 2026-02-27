import 'package:fpdart/fpdart.dart';
import 'package:simple_chat/core/errors/failures.dart';
import 'package:simple_chat/features/chats/domain/entities/conversation_summary.dart';
import 'package:simple_chat/features/chats/domain/repositories/chat_repository.dart';

class GetConversationsUsecase {
  final ChatRepository _repository;

  const GetConversationsUsecase(this._repository);

  Future<Either<Failure, List<ConversationSummary>>> call() {
    return _repository.getConversationSummaries();
  }
}
