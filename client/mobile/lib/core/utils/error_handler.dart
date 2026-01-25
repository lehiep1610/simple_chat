import 'package:flutter/material.dart';
import '../errors/failures.dart';
import 'snackbar_helper.dart';

class ErrorHandler {
  /// Handle Failure and show snackbar
  static void handleFailure(BuildContext context, Failure failure) {
    final message = _getMessageFromFailure(failure);
    SnackbarHelper.showError(context, message);
  }

  /// Get message from Failure with fallback message
  static String _getMessageFromFailure(Failure failure) {
    // Customize message based on failure type
    if (failure is NetworkFailure) {
      return failure.message.isNotEmpty
          ? failure.message
          : 'No internet connection. Please check your network.';
    }

    if (failure is UnauthorizedFailure) {
      return failure.message.isNotEmpty
          ? failure.message
          : 'Session expired. Please login again.';
    }

    if (failure is ServerFailure) {
      return failure.message.isNotEmpty
          ? failure.message
          : 'Something went wrong. Please try again later.';
    }

    return failure.message.isNotEmpty
        ? failure.message
        : 'An unknown error occurred.';
  }

  /// Handle Failure with custom callbacks
  static void handleFailureWithCallback(
    BuildContext context,
    Failure failure, {
    VoidCallback? onUnauthorized,
    VoidCallback? onNetworkError,
  }) {
    if (failure is UnauthorizedFailure && onUnauthorized != null) {
      onUnauthorized();
    } else if (failure is NetworkFailure && onNetworkError != null) {
      onNetworkError();
    }

    handleFailure(context, failure);
  }
}
