import 'package:fpdart/fpdart.dart';
import 'package:simple_chat/core/errors/failures.dart';
import 'package:simple_chat/features/chat/domain/entities/conversation.dart';

abstract class ChatRepository {
  Future<Either<Failure, Conversation>> getDirectConversation(String friendId);
}
