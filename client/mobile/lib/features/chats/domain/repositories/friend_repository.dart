import 'package:fpdart/fpdart.dart';
import 'package:simple_chat/core/errors/failures.dart';
import 'package:simple_chat/features/chats/domain/entities/friend.dart';

abstract class FriendRepository {
  Future<Either<Failure, List<Friend>>> getFriends();
}
