import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/people_repository.dart';

class SendFriendRequestUsecase {
  final PeopleRepository repository;

  SendFriendRequestUsecase(this.repository);

  Future<Either<Failure, void>> call(String recipientId) {
    return repository.sendFriendRequest(recipientId);
  }
}
