import 'package:fpdart/fpdart.dart';
import 'package:simple_chat/core/errors/exceptions.dart';
import 'package:simple_chat/features/chats/data/datasources/friend_remote_datasource.dart';
import 'package:simple_chat/features/chats/domain/repositories/friend_repository.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/friend.dart';

class FriendRepositoryImpl implements FriendRepository {
  final FriendRemoteDatasource friendRemoteDatasource;
  FriendRepositoryImpl(this.friendRemoteDatasource);

  @override
  Future<Either<Failure, List<Friend>>> getFriends() async {
    try {
      final friends = await friendRemoteDatasource.getFriends();

      return Right(friends);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(NetworkFailure());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    }
  }
}
