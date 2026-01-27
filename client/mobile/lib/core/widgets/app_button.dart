import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, outline, text }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.prefixIcon,
    this.suffixIcon,
  });

  // Factory constructors for convenience
  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.prefixIcon,
    this.suffixIcon,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.prefixIcon,
    this.suffixIcon,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.prefixIcon,
    this.suffixIcon,
  }) : variant = AppButtonVariant.outline;

  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.prefixIcon,
    this.suffixIcon,
  }) : variant = AppButtonVariant.text;

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle(context);
    final child = _buildChild(context);

    Widget button;
    switch (variant) {
      case AppButtonVariant.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: child,
        );
        break;
      case AppButtonVariant.secondary:
        button = FilledButton.tonal(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: child,
        );
        break;
      case AppButtonVariant.outline:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: child,
        );
        break;
      case AppButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: buttonStyle,
          child: child,
        );
        break;
    }

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: _getLoadingSize(),
        width: _getLoadingSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: variant == AppButtonVariant.primary
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
        ),
      );
    }

    final textWidget = Text(text);

    if (prefixIcon == null && suffixIcon == null) {
      return textWidget;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixIcon != null) ...[
          Icon(prefixIcon, size: _getIconSize()),
          const SizedBox(width: 8),
        ],
        textWidget,
        if (suffixIcon != null) ...[
          const SizedBox(width: 8),
          Icon(suffixIcon, size: _getIconSize()),
        ],
      ],
    );
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    return ButtonStyle(
      padding: WidgetStatePropertyAll(_getPadding()),
      textStyle: WidgetStatePropertyAll(_getTextStyle()),
      minimumSize: WidgetStatePropertyAll(_getMinimumSize()),
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  Size _getMinimumSize() {
    switch (size) {
      case AppButtonSize.small:
        return const Size(64, 36);
      case AppButtonSize.medium:
        return const Size(88, 44);
      case AppButtonSize.large:
        return const Size(120, 52);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppButtonSize.small:
        return const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
      case AppButtonSize.medium:
        return const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
      case AppButtonSize.large:
        return const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }

  double _getLoadingSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }
}
