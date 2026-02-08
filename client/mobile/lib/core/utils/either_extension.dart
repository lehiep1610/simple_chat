import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import '../errors/failures.dart';
import 'error_handler.dart';
import 'snackbar_helper.dart';

extension EitherExtensions<L extends Failure, R> on Either<L, R> {
  /// Handle result với auto error snackbar
  void handleResult(
    BuildContext context, {
    required void Function(R data) onSuccess,
    void Function(L failure)? onError,
    String? successMessage,
  }) {
    fold(
      (failure) {
        ErrorHandler.handleFailure(context, failure);
        onError?.call(failure);
      },
      (data) {
        if (successMessage != null) {
          SnackbarHelper.showSuccess(context, successMessage);
        }
        onSuccess(data);
      },
    );
  }
}
