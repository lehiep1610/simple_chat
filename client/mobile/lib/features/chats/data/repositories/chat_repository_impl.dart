import 'package:fpdart/fpdart.dart';
import 'package:simple_chat/core/errors/exceptions.dart';
import 'package:simple_chat/core/errors/failures.dart';
import 'package:simple_chat/features/chats/data/datasources/chat_remote_datasource.dart';
import 'package:simple_chat/features/chats/domain/entities/conversation_summary.dart';
import 'package:simple_chat/features/chats/domain/entities/message.dart';
import 'package:simple_chat/features/chats/domain/entities/message_page.dart';
import 'package:simple_chat/features/chats/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource chatRemoteDatasource;
  ChatRepositoryImpl(this.chatRemoteDatasource);

  @override
  Future<Either<Failure, String>> getDirectConversation(String friendId) async {
    try {
      final conversationId = await chatRemoteDatasource.getDirectConversation(
        friendId,
      );
      return Right(conversationId);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(NetworkFailure());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage({
    required String conversationId,
    required String senderId,
    required String body,
    String messageType = 'text',
  }) async {
    try {
      final message = await chatRemoteDatasource.sendMessage(
        conversationId: conversationId,
        senderId: senderId,
        body: body,
        messageType: messageType,
      );
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(NetworkFailure());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ConversationSummary>>>
  getConversationSummaries() async {
    try {
      final conversationSummaries = await chatRemoteDatasource
          .getConversationSummaries();
      return Right(conversationSummaries);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, MessagePage>> getMessages(
    String conversationId, {
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final messages = await chatRemoteDatasource.getMessages(
        conversationId,
        limit: limit,
        offset: offset,
      );
      return Right(messages);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
