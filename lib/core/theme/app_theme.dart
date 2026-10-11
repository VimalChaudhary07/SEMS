// Implements Figma Design System light and dark application themes.
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_spacing.dart';
import 'app_text.dart';

export 'app_colors.dart';
export 'app_radii.dart';
export 'app_shadows.dart';
export 'app_spacing.dart';
export 'app_text.dart';

abstract final class SemsColors {
  static const forest = AppColorTokens.lightBrandPrimary;
  static const green = AppColorTokens.lightStatusOk;
  static const mint = AppColorTokens.lightBrandTint;
  static const ink = AppColorTokens.lightTextPrimary;
  static const muted = AppColorTokens.lightTextSecondary;
  static const canvas = AppColorTokens.lightBackground;
  static const line = AppColorTokens.lightBorder;
  static const amber = AppColorTokens.lightStatusWarning;
  static const red = AppColorTokens.lightStatusFault;
}

abstract final class SemsSpace {
  static const double page = AppSpacing.screen;
  static const double card = AppRadii.card;
}

abstract final class AppTheme {
  static ThemeData get light => _build(AppColors.light, Brightness.light);
  static ThemeData get dark => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors colors, Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: colors.brandPrimary,
      primary: colors.brandPrimary,
      onPrimary: colors.onBrandPrimary,
      surface: colors.card,
      error: colors.statusFault,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      extensions: [colors],
      fontFamily: AppText.family,
      scaffoldBackgroundColor: colors.background,
      textTheme: TextTheme(
        displayMedium: AppText.display.copyWith(color: colors.textPrimary),
        headlineMedium: AppText.headline.copyWith(color: colors.textPrimary),
        titleLarge: AppText.title.copyWith(color: colors.textPrimary),
        titleMedium: AppText.title.copyWith(
          fontSize: 15,
          height: 20 / 15,
          color: colors.textPrimary,
        ),
        bodyMedium: AppText.body.copyWith(color: colors.textPrimary),
        bodySmall: AppText.label.copyWith(
          fontSize: 12,
          height: 16 / 12,
          color: colors.textSecondary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: colors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(color: colors.border),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: colors.card,
        indicatorColor: colors.brandTint,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontFamily: AppText.family,
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? colors.brandPrimary
                : colors.textSecondary,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: BorderSide(color: colors.brandPrimary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
    );
  }
}
