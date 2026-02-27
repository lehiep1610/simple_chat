import 'package:fpdart/fpdart.dart';
import 'package:simple_chat/core/errors/failures.dart';
import 'package:simple_chat/features/chats/domain/entities/friend.dart';
import 'package:simple_chat/features/chats/domain/repositories/friend_repository.dart';

class GetFriendsUsecase {
  final FriendRepository friendRepository;
  GetFriendsUsecase(this.friendRepository);

  Future<Either<Failure, List<Friend>>> getFriends() {
    return friendRepository.getFriends();
  }
}
