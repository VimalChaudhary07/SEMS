// Implements Figma Design System color variables in light and dark modes.
import 'package:flutter/material.dart';

abstract final class AppColorTokens {
  static const lightBackground = Color(0xFFF4F7F6);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightRaised = Color(0xFFEAF1EE);
  static const lightTextPrimary = Color(0xFF0F1714);
  static const lightTextSecondary = Color(0xFF55625D);
  static const lightBorder = Color(0xFFE1E9E5);
  static const lightBrandPrimary = Color(0xFF0E9F6E);
  static const lightOnBrandPrimary = Color(0xFFFFFFFF);
  static const lightBrandTint = Color(0xFFDDF4EA);
  static const lightStatusOk = Color(0xFF2E9E5B);
  static const lightStatusWarning = Color(0xFFD98A00);
  static const lightStatusFault = Color(0xFFD64545);
  static const lightStatusOffline = Color(0xFF7A8594);
  static const lightStatusPending = Color(0xFF2F6FED);
  static const lightStatusAi = Color(0xFF7C5CE0);
  static const lightStatusWarningTint = Color(0xFFFCF0D9);
  static const lightStatusFaultTint = Color(0xFFFBE6E6);
  static const lightStatusPendingTint = Color(0xFFE3ECFD);
  static const lightStatusAiTint = Color(0xFFECE6FB);
  static const lightStatusOkTint = Color(0xFFDEF7EC);
  static const lightStatusOfflineTint = Color(0xFFEFF1F4);
}

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.card,
    required this.raised,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.brandPrimary,
    required this.onBrandPrimary,
    required this.brandTint,
    required this.statusOk,
    required this.statusWarning,
    required this.statusFault,
    required this.statusOffline,
    required this.statusPending,
    required this.statusAi,
    this.statusOkTint,
    this.statusWarningTint,
    this.statusFaultTint,
    this.statusOfflineTint,
    this.statusPendingTint,
    this.statusAiTint,
    this.statusYellow,
    this.statusYellowTint,
    this.statusOrange,
    this.statusOrangeTint,
  });

  static const light = AppColors(
    background: AppColorTokens.lightBackground,
    card: AppColorTokens.lightCard,
    raised: AppColorTokens.lightRaised,
    textPrimary: AppColorTokens.lightTextPrimary,
    textSecondary: AppColorTokens.lightTextSecondary,
    border: AppColorTokens.lightBorder,
    brandPrimary: AppColorTokens.lightBrandPrimary,
    onBrandPrimary: AppColorTokens.lightOnBrandPrimary,
    brandTint: AppColorTokens.lightBrandTint,
    statusOk: AppColorTokens.lightStatusOk,
    statusWarning: AppColorTokens.lightStatusWarning,
    statusFault: AppColorTokens.lightStatusFault,
    statusOffline: AppColorTokens.lightStatusOffline,
    statusPending: AppColorTokens.lightStatusPending,
    statusAi: AppColorTokens.lightStatusAi,
    statusOkTint: AppColorTokens.lightStatusOkTint,
    statusWarningTint: AppColorTokens.lightStatusWarningTint,
    statusFaultTint: AppColorTokens.lightStatusFaultTint,
    statusOfflineTint: AppColorTokens.lightStatusOfflineTint,
    statusPendingTint: AppColorTokens.lightStatusPendingTint,
    statusAiTint: AppColorTokens.lightStatusAiTint,
  );

  static const dark = AppColors(
    background: Color(0xFF0B100E),
    card: Color(0xFF151C19),
    raised: Color(0xFF1F2925),
    textPrimary: Color(0xFFEAF1EE),
    textSecondary: Color(0xFF9AABA4),
    border: Color(0xFF26322D),
    brandPrimary: Color(0xFF2CC98E),
    onBrandPrimary: Color(0xFF04140D),
    brandTint: Color(0xFF12342A),
    statusOk: Color(0xFF46C277),
    statusWarning: Color(0xFFF2B33D),
    statusFault: Color(0xFFFF6B6B),
    statusOffline: Color(0xFF8E9AAA),
    statusPending: Color(0xFF6FA0FF),
    statusAi: Color(0xFFA48CFF),
    statusOkTint: Color(0xFF1C3326),
    statusWarningTint: Color(0xFF38290D),
    statusFaultTint: Color(0xFF3A1818),
    statusOfflineTint: Color(0xFF262E2D),
    statusPendingTint: Color(0xFF16264A),
    statusAiTint: Color(0xFF2A2250),
  );

  final Color background;
  final Color card;
  final Color raised;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color brandPrimary;
  final Color onBrandPrimary;
  final Color brandTint;
  final Color statusOk;
  final Color statusWarning;
  final Color statusFault;
  final Color statusOffline;
  final Color statusPending;
  final Color statusAi;
  final Color? statusOkTint;
  final Color? statusWarningTint;
  final Color? statusFaultTint;
  final Color? statusOfflineTint;
  final Color? statusPendingTint;
  final Color? statusAiTint;
  final Color? statusYellow;
  final Color? statusYellowTint;
  final Color? statusOrange;
  final Color? statusOrangeTint;

  @override
  AppColors copyWith({
    Color? background,
    Color? card,
    Color? raised,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? brandPrimary,
    Color? onBrandPrimary,
    Color? brandTint,
    Color? statusOk,
    Color? statusWarning,
    Color? statusFault,
    Color? statusOffline,
    Color? statusPending,
    Color? statusAi,
    Color? statusOkTint,
    Color? statusWarningTint,
    Color? statusFaultTint,
    Color? statusOfflineTint,
    Color? statusPendingTint,
    Color? statusAiTint,
    Color? statusYellow,
    Color? statusYellowTint,
    Color? statusOrange,
    Color? statusOrangeTint,
  }) => AppColors(
    background: background ?? this.background,
    card: card ?? this.card,
    raised: raised ?? this.raised,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    border: border ?? this.border,
    brandPrimary: brandPrimary ?? this.brandPrimary,
    onBrandPrimary: onBrandPrimary ?? this.onBrandPrimary,
    brandTint: brandTint ?? this.brandTint,
    statusOk: statusOk ?? this.statusOk,
    statusWarning: statusWarning ?? this.statusWarning,
    statusFault: statusFault ?? this.statusFault,
    statusOffline: statusOffline ?? this.statusOffline,
    statusPending: statusPending ?? this.statusPending,
    statusAi: statusAi ?? this.statusAi,
    statusOkTint: statusOkTint ?? this.statusOkTint,
    statusWarningTint: statusWarningTint ?? this.statusWarningTint,
    statusFaultTint: statusFaultTint ?? this.statusFaultTint,
    statusOfflineTint: statusOfflineTint ?? this.statusOfflineTint,
    statusPendingTint: statusPendingTint ?? this.statusPendingTint,
    statusAiTint: statusAiTint ?? this.statusAiTint,
    statusYellow: statusYellow ?? this.statusYellow,
    statusYellowTint: statusYellowTint ?? this.statusYellowTint,
    statusOrange: statusOrange ?? this.statusOrange,
    statusOrangeTint: statusOrangeTint ?? this.statusOrangeTint,
  );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      card: Color.lerp(card, other.card, t)!,
      raised: Color.lerp(raised, other.raised, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      onBrandPrimary: Color.lerp(onBrandPrimary, other.onBrandPrimary, t)!,
      brandTint: Color.lerp(brandTint, other.brandTint, t)!,
      statusOk: Color.lerp(statusOk, other.statusOk, t)!,
      statusWarning: Color.lerp(statusWarning, other.statusWarning, t)!,
      statusFault: Color.lerp(statusFault, other.statusFault, t)!,
      statusOffline: Color.lerp(statusOffline, other.statusOffline, t)!,
      statusPending: Color.lerp(statusPending, other.statusPending, t)!,
      statusAi: Color.lerp(statusAi, other.statusAi, t)!,
      statusOkTint: Color.lerp(statusOkTint, other.statusOkTint, t),
      statusWarningTint: Color.lerp(
        statusWarningTint,
        other.statusWarningTint,
        t,
      ),
      statusFaultTint: Color.lerp(statusFaultTint, other.statusFaultTint, t),
      statusOfflineTint: Color.lerp(
        statusOfflineTint,
        other.statusOfflineTint,
        t,
      ),
      statusPendingTint: Color.lerp(
        statusPendingTint,
        other.statusPendingTint,
        t,
      ),
      statusAiTint: Color.lerp(statusAiTint, other.statusAiTint, t),
      statusYellow: Color.lerp(statusYellow, other.statusYellow, t),
      statusYellowTint: Color.lerp(statusYellowTint, other.statusYellowTint, t),
      statusOrange: Color.lerp(statusOrange, other.statusOrange, t),
      statusOrangeTint: Color.lerp(statusOrangeTint, other.statusOrangeTint, t),
    );
  }
}
