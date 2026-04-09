import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/people_repository.dart';
import '../datasources/people_remote_datasource.dart';

class PeopleRepositoryImpl implements PeopleRepository {
  final PeopleRemoteDatasource remoteDatasource;

  PeopleRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, GetUsersResult>> getUsers({
    required int limit,
    required int offset,
  }) async {
    try {
      final result = await remoteDatasource.getUsers(
        limit: limit,
        offset: offset,
      );
      return Right(
        GetUsersResult(users: result.users, hasMore: result.hasMore),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(NetworkFailure());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> sendFriendRequest(String recipientId) async {
    try {
      await remoteDatasource.sendFriendRequest(recipientId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(NetworkFailure());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    }
  }
}
