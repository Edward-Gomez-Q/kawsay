import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/presentation/themes/button_styles.dart';

class AppButton extends ConsumerWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonVariant variant;
  final ButtonSize size;
  final Widget? icon;
  final bool isLoading;
  final bool fullWidth;
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.elevated,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final style = AppButtonStyles.getButtonStyle(
      type: type,
      variant: variant,
      size: size,
      isDark: isDark,
    );

    Widget button;
    Widget content = isLoading
        ? SizedBox(
            width: _getIconSize(),
            height: _getIconSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                style.foregroundColor?.resolve({}) ?? Colors.white,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 8)],
              Text(text),
            ],
          );

    switch (type) {
      case ButtonType.elevated:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: content,
        );
        break;
      case ButtonType.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: content,
        );
        break;
      case ButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: style,
          child: content,
        );
        break;
    }

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 14.0;
      case ButtonSize.medium:
        return 16.0;
      case ButtonSize.large:
        return 18.0;
      case ButtonSize.extraLarge:
        return 20.0;
    }
  }
}
