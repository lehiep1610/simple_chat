import 'package:dartz/dartz.dart';
import 'package:simple_chat/core/errors/failures.dart';
import 'package:simple_chat/features/home/domain/entities/friend.dart';

abstract class FriendRepository {
  Future<Either<Failure, List<Friend>>> getFriends();
}
