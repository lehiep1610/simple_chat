import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_preview.dart';

/// Domain-level result for the paginated users query.
class GetUsersResult {
  final List<UserPreview> users;
  final bool hasMore;

  const GetUsersResult({required this.users, required this.hasMore});
}

abstract class PeopleRepository {
  Future<Either<Failure, GetUsersResult>> getUsers({
    required int limit,
    required int offset,
  });

  Future<Either<Failure, void>> sendFriendRequest(String recipientId);
}
