import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light {
    return _buildTheme(
      brightness: Brightness.light,
      backgroundColor: AppColors.background,
      surfaceColor: AppColors.surface,
      textPrimaryColor: AppColors.textPrimary,
      textSecondaryColor: AppColors.textSecondary,
      fieldFillColor: AppColors.fieldFill,
      fieldBorderColor: AppColors.fieldBorder,
    );
  }

  static ThemeData get dark {
    return _buildTheme(
      brightness: Brightness.dark,
      backgroundColor: AppColors.darkBackground,
      surfaceColor: AppColors.darkSurface,
      textPrimaryColor: AppColors.darkTextPrimary,
      textSecondaryColor: AppColors.darkTextSecondary,
      fieldFillColor: AppColors.darkFieldFill,
      fieldBorderColor: AppColors.darkFieldBorder,
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color backgroundColor,
    required Color surfaceColor,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
    required Color fieldFillColor,
    required Color fieldBorderColor,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
      primary: AppColors.primary,
      surface: surfaceColor,
      error: AppColors.danger,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: _textTheme(
        primaryColor: textPrimaryColor,
        secondaryColor: textSecondaryColor,
      ),
      inputDecorationTheme: _inputDecorationTheme(
        fillColor: fieldFillColor,
        borderColor: fieldBorderColor,
        textColor: textPrimaryColor,
        hintColor: textSecondaryColor,
      ),
      filledButtonTheme: _filledButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textPrimaryColor,
        borderColor: fieldBorderColor,
      ),
      textButtonTheme: _textButtonTheme,
      iconTheme: IconThemeData(
        color: textPrimaryColor,
        size: AppSizes.iconSize,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: textPrimaryColor,
        contentTextStyle: TextStyle(
          color: backgroundColor,
          fontSize: AppSizes.bodyFontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static TextTheme _textTheme({
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    return TextTheme(
      headlineMedium: TextStyle(
        color: primaryColor,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      titleLarge: TextStyle(
        color: primaryColor,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      titleMedium: TextStyle(
        color: primaryColor,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
      bodyLarge: TextStyle(
        color: primaryColor,
        fontSize: AppSizes.bodyFontSize,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      bodyMedium: TextStyle(
        color: secondaryColor,
        fontSize: AppSizes.bodyFontSize,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      labelLarge: TextStyle(
        color: primaryColor,
        fontSize: AppSizes.bodyFontSize,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      labelMedium: TextStyle(
        color: secondaryColor,
        fontSize: AppSizes.biometricLabelFontSize,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme({
    required Color fillColor,
    required Color borderColor,
    required Color textColor,
    required Color hintColor,
  }) {
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSizes.fieldHorizontalPadding,
        vertical: AppSizes.fieldVerticalPadding,
      ),
      hintStyle: TextStyle(
        color: hintColor,
        fontSize: AppSizes.bodyFontSize,
        fontWeight: FontWeight.w500,
      ),
      labelStyle: TextStyle(
        color: textColor,
        fontSize: AppSizes.bodyFontSize,
        fontWeight: FontWeight.w700,
      ),
      floatingLabelStyle: const TextStyle(
        color: AppColors.primary,
        fontSize: AppSizes.bodyFontSize,
        fontWeight: FontWeight.w700,
      ),
      errorStyle: const TextStyle(
        color: AppColors.danger,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      border: _inputBorder(color: borderColor, width: AppSizes.borderWidth),
      enabledBorder: _inputBorder(
        color: borderColor,
        width: AppSizes.borderWidth,
      ),
      focusedBorder: _inputBorder(
        color: AppColors.primary,
        width: AppSizes.focusedBorderWidth,
      ),
      errorBorder: _inputBorder(
        color: AppColors.danger,
        width: AppSizes.borderWidth,
      ),
      focusedErrorBorder: _inputBorder(
        color: AppColors.danger,
        width: AppSizes.focusedBorderWidth,
      ),
      disabledBorder: _inputBorder(
        color: AppColors.disabled,
        width: AppSizes.borderWidth,
      ),
    );
  }

  static OutlineInputBorder _inputBorder({
    required Color color,
    required double width,
  }) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(AppSizes.pillBorderRadius),
      ),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static final FilledButtonThemeData _filledButtonTheme = FilledButtonThemeData(
    style: ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(
        Size(double.infinity, AppSizes.loginButtonHeight),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: AppSizes.spacing24,
          vertical: AppSizes.spacing16,
        ),
      ),
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.disabled;
        }

        if (states.contains(WidgetState.pressed)) {
          return AppColors.primaryPressed;
        }

        return AppColors.primary;
      }),
      foregroundColor: const WidgetStatePropertyAll(AppColors.textOnPrimary),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(
          fontSize: AppSizes.loginButtonFontSize,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(AppSizes.pillBorderRadius),
          ),
        ),
      ),
      elevation: const WidgetStatePropertyAll(AppSizes.zero),
    ),
  );

  static OutlinedButtonThemeData _outlinedButtonTheme({
    required Color backgroundColor,
    required Color foregroundColor,
    required Color borderColor,
  }) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(
          Size(AppSizes.minimumTouchTarget, AppSizes.secondaryButtonHeight),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: AppSizes.spacing20,
            vertical: AppSizes.spacing12,
          ),
        ),
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return AppColors.disabled;
          }

          return foregroundColor;
        }),
        side: WidgetStateProperty.resolveWith<BorderSide>((states) {
          return BorderSide(
            width: AppSizes.borderWidth,
            color: states.contains(WidgetState.disabled)
                ? AppColors.disabled
                : borderColor,
          );
        }),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontSize: AppSizes.bodyFontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppSizes.pillBorderRadius),
            ),
          ),
        ),
        elevation: const WidgetStatePropertyAll(AppSizes.zero),
      ),
    );
  }

  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.disabled;
        }

        if (states.contains(WidgetState.pressed)) {
          return AppColors.primaryPressed;
        }

        return AppColors.primary;
      }),
      textStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: AppSizes.bodyFontSize, fontWeight: FontWeight.w700),
      ),
    ),
  );
}
