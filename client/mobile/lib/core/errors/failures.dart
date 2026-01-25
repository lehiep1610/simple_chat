abstract class Failure {
  final String message;
  final int? code;
  Failure({required this.message, this.code});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message, super.code});
}

class NetworkFailure extends Failure {
  NetworkFailure([String message = 'No internet connection'])
    : super(message: message);
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure([String message = 'Unauthorized'])
    : super(message: message, code: 401);
}

class ValidationFailure extends Failure {
  ValidationFailure({required super.message}) : super(code: 400);
}

class NotFoundFailure extends Failure {
  NotFoundFailure([String message = 'Resource not found'])
    : super(message: message, code: 404);
}
