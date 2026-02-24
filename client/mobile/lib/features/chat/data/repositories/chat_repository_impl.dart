import 'package:fpdart/fpdart.dart';
import 'package:simple_chat/core/errors/exceptions.dart';
import 'package:simple_chat/core/errors/failures.dart';
import 'package:simple_chat/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:simple_chat/features/chat/domain/entities/conversation.dart';
import 'package:simple_chat/features/chat/domain/entities/message.dart';
import 'package:simple_chat/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource chatRemoteDatasource;
  ChatRepositoryImpl(this.chatRemoteDatasource);

  @override
  Future<Either<Failure, Conversation>> getDirectConversation(
    String friendId,
  ) async {
    try {
      final conversation = await chatRemoteDatasource.getDirectConversation(
        friendId,
      );
      return Right(conversation);
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
}
