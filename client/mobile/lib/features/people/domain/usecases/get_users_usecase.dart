import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/people_repository.dart';

class GetUsersUsecase {
  final PeopleRepository repository;

  GetUsersUsecase(this.repository);

  Future<Either<Failure, GetUsersResult>> call({
    required int limit,
    required int offset,
  }) {
    return repository.getUsers(limit: limit, offset: offset);
  }
}
