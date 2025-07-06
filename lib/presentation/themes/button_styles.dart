import 'package:flutter/material.dart';
import 'package:project_3_kawsay/model/common/button_colors.dart';
import 'package:project_3_kawsay/presentation/themes/colors.dart';
import 'package:project_3_kawsay/presentation/themes/text_styles.dart';

// Enums para las variantes y tamaños
enum ButtonVariant { primary, secondary, success, danger, warning, info }

enum ButtonSize { small, medium, large, extraLarge }

enum ButtonType { elevated, outlined, text }

class AppButtonStyles {
  // Configuración de padding
  static EdgeInsetsGeometry _getPadding(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0);
      case ButtonSize.extraLarge:
        return const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0);
    }
  }

  // Configuración de border radius
  static double _getBorderRadius(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 6.0;
      case ButtonSize.medium:
        return 8.0;
      case ButtonSize.large:
        return 12.0;
      case ButtonSize.extraLarge:
        return 16.0;
    }
  }

  // Configuración de text style
  static TextStyle _getTextStyle(ButtonSize size, bool isDark) {
    switch (size) {
      case ButtonSize.small:
        return isDark
            ? AppTextStyles.labelSmallDark
            : AppTextStyles.labelSmallLight;
      case ButtonSize.medium:
        return isDark
            ? AppTextStyles.labelMediumDark
            : AppTextStyles.labelMediumLight;
      case ButtonSize.large:
        return isDark
            ? AppTextStyles.labelLargeDark
            : AppTextStyles.labelLargeLight;
      case ButtonSize.extraLarge:
        return isDark
            ? AppTextStyles.titleSmallDark
            : AppTextStyles.titleSmallLight;
    }
  }

  // Obtener colores
  static ButtonColors _getColors(ButtonVariant variant, bool isDark) {
    if (isDark) {
      switch (variant) {
        case ButtonVariant.primary:
          return ButtonColors(
            background: AppColors.darkPrimary,
            foreground: Colors.white,
            border: AppColors.darkPrimary,
            disabled: AppColors.darkDisabled,
          );
        case ButtonVariant.secondary:
          return ButtonColors(
            background: AppColors.darkSecondary,
            foreground: Colors.white,
            border: AppColors.darkSecondary,
            disabled: AppColors.darkDisabled,
          );
        case ButtonVariant.success:
          return ButtonColors(
            background: AppColors.darkSuccess,
            foreground: Colors.white,
            border: AppColors.darkSuccess,
            disabled: AppColors.darkDisabled,
          );
        case ButtonVariant.danger:
          return ButtonColors(
            background: AppColors.darkError,
            foreground: Colors.white,
            border: AppColors.darkError,
            disabled: AppColors.darkDisabled,
          );
        case ButtonVariant.warning:
          return ButtonColors(
            background: AppColors.darkWarning,
            foreground: Colors.white,
            border: AppColors.darkWarning,
            disabled: AppColors.darkDisabled,
          );
        case ButtonVariant.info:
          return ButtonColors(
            background: AppColors.darkInfo,
            foreground: Colors.white,
            border: AppColors.darkInfo,
            disabled: AppColors.darkDisabled,
          );
      }
    } else {
      switch (variant) {
        case ButtonVariant.primary:
          return ButtonColors(
            background: AppColors.lightPrimary,
            foreground: Colors.white,
            border: AppColors.lightPrimary,
            disabled: AppColors.lightDisabled,
          );
        case ButtonVariant.secondary:
          return ButtonColors(
            background: AppColors.lightSecondary,
            foreground: Colors.white,
            border: AppColors.lightSecondary,
            disabled: AppColors.lightDisabled,
          );
        case ButtonVariant.success:
          return ButtonColors(
            background: AppColors.lightSuccess,
            foreground: Colors.white,
            border: AppColors.lightSuccess,
            disabled: AppColors.lightDisabled,
          );
        case ButtonVariant.danger:
          return ButtonColors(
            background: AppColors.lightError,
            foreground: Colors.white,
            border: AppColors.lightError,
            disabled: AppColors.lightDisabled,
          );
        case ButtonVariant.warning:
          return ButtonColors(
            background: AppColors.lightWarning,
            foreground: Colors.white,
            border: AppColors.lightWarning,
            disabled: AppColors.lightDisabled,
          );
        case ButtonVariant.info:
          return ButtonColors(
            background: AppColors.lightInfo,
            foreground: Colors.white,
            border: AppColors.lightInfo,
            disabled: AppColors.lightDisabled,
          );
      }
    }
  }

  // Método principal para obtener el estilo
  static ButtonStyle getButtonStyle({
    required ButtonType type,
    required ButtonVariant variant,
    required ButtonSize size,
    required bool isDark,
  }) {
    final colors = _getColors(variant, isDark);
    final padding = _getPadding(size);
    final borderRadius = _getBorderRadius(size);
    final textStyle = _getTextStyle(size, isDark);

    switch (type) {
      case ButtonType.elevated:
        return ElevatedButton.styleFrom(
          padding: padding,
          backgroundColor: colors.background,
          foregroundColor: colors.foreground,
          textStyle: textStyle,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: size == ButtonSize.small
              ? 1
              : (size == ButtonSize.large || size == ButtonSize.extraLarge
                    ? 4
                    : 2),
          disabledBackgroundColor: colors.disabled,
          disabledForegroundColor: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        );

      case ButtonType.outlined:
        return OutlinedButton.styleFrom(
          padding: padding,
          foregroundColor: colors.background,
          textStyle: textStyle,
          side: BorderSide(
            color: colors.border,
            width: size == ButtonSize.small ? 1 : 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.pressed)
                ? colors.background.withValues(alpha: 0.1)
                : null,
          ),
        );

      case ButtonType.text:
        return TextButton.styleFrom(
          padding: padding,
          foregroundColor: colors.background,
          textStyle: textStyle,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.pressed)
                ? colors.background.withValues(alpha: 0.1)
                : null,
          ),
        );
    }
  }

  // Métodos de conveniencia para acceso rápido
  static ButtonStyle elevated({
    ButtonVariant variant = ButtonVariant.primary,
    ButtonSize size = ButtonSize.medium,
    bool isDark = false,
  }) => getButtonStyle(
    type: ButtonType.elevated,
    variant: variant,
    size: size,
    isDark: isDark,
  );

  static ButtonStyle outlined({
    ButtonVariant variant = ButtonVariant.primary,
    ButtonSize size = ButtonSize.medium,
    bool isDark = false,
  }) => getButtonStyle(
    type: ButtonType.outlined,
    variant: variant,
    size: size,
    isDark: isDark,
  );

  static ButtonStyle text({
    ButtonVariant variant = ButtonVariant.primary,
    ButtonSize size = ButtonSize.medium,
    bool isDark = false,
  }) => getButtonStyle(
    type: ButtonType.text,
    variant: variant,
    size: size,
    isDark: isDark,
  );
}
