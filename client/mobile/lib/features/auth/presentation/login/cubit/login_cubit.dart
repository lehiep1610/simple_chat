// login/cubit/login_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/validators.dart';
import '../../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUsecase _loginUsecase;

  LoginCubit(this._loginUsecase) : super(const LoginState());

  Future<void> login({required String email, required String password}) async {
    final emailError = Validators.validateEmail(email);
    final passwordValid =
        Validators.hasValidLength(password) &&
        Validators.hasDigit(password) &&
        Validators.hasSpecialChar(password);

    if (emailError != null || !passwordValid) {
      emit(state.copyWith(emailError: emailError));
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading, clearEmailError: true));

    final result = await _loginUsecase.call(email: email, password: password);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: LoginStatus.failure, failure: failure)),
      (user) => emit(state.copyWith(status: LoginStatus.success, user: user)),
    );
  }

  void resetStatus() {
    emit(state.copyWith(status: LoginStatus.initial));
  }
}
