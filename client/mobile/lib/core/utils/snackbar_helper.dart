import 'package:flutter/material.dart';

enum SnackbarType { success, error, warning, info }

class SnackbarHelper {
  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final colorScheme = _getColorScheme(type);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(colorScheme.icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: colorScheme.backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        duration: duration,
        action: action,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    show(context, message: message, type: SnackbarType.success);
  }

  static void showError(BuildContext context, String message) {
    show(context, message: message, type: SnackbarType.error);
  }

  static void showWarning(BuildContext context, String message) {
    show(context, message: message, type: SnackbarType.warning);
  }

  static void showInfo(BuildContext context, String message) {
    show(context, message: message, type: SnackbarType.info);
  }

  static _SnackbarColorScheme _getColorScheme(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return _SnackbarColorScheme(
          backgroundColor: Colors.green.shade600,
          icon: Icons.check_circle,
        );
      case SnackbarType.error:
        return _SnackbarColorScheme(
          backgroundColor: Colors.red.shade600,
          icon: Icons.error,
        );
      case SnackbarType.warning:
        return _SnackbarColorScheme(
          backgroundColor: Colors.orange.shade600,
          icon: Icons.warning,
        );
      case SnackbarType.info:
        return _SnackbarColorScheme(
          backgroundColor: Colors.blue.shade600,
          icon: Icons.info,
        );
    }
  }
}

class _SnackbarColorScheme {
  final Color backgroundColor;
  final IconData icon;

  _SnackbarColorScheme({required this.backgroundColor, required this.icon});
}
