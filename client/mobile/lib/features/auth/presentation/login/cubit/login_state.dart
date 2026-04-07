// login/cubit/login_state.dart
import 'package:equatable/equatable.dart';
import '../../../../../core/errors/failures.dart';
import '../../../domain/entities/user.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final String? emailError;
  final User? user;
  final Failure? failure;

  const LoginState({
    this.status = LoginStatus.initial,
    this.emailError,
    this.user,
    this.failure,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? emailError,
    bool clearEmailError = false,
    User? user,
    Failure? failure,
  }) {
    return LoginState(
      status: status ?? this.status,
      emailError: clearEmailError ? null : emailError ?? this.emailError,
      user: user ?? this.user,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, emailError, user, failure];
}
