// Implements the Figma Design System typography foundations.
import 'package:flutter/material.dart';

abstract final class AppText {
  static const family = 'Inter';
  static const monoFamily = 'JetBrains Mono';

  static const caption = TextStyle(
    fontFamily: family,
    fontSize: 11,
    height: 14 / 11,
    fontWeight: FontWeight.w400,
  );
  static const label = TextStyle(
    fontFamily: family,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
  );
  static const section = TextStyle(
    fontFamily: family,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
  );
  static const bodySmall = TextStyle(
    fontFamily: family,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
  );
  static const bodyMedium = TextStyle(
    fontFamily: family,
    fontSize: 15,
    height: 22 / 15,
    fontWeight: FontWeight.w400,
  );
  static const bodyLarge = TextStyle(
    fontFamily: family,
    fontSize: 17,
    height: 24 / 17,
    fontWeight: FontWeight.w400,
  );
  static const titleSmall = TextStyle(
    fontFamily: family,
    fontSize: 20,
    height: 26 / 20,
    fontWeight: FontWeight.w600,
  );
  static const titleMedium = TextStyle(
    fontFamily: family,
    fontSize: 22,
    height: 28 / 22,
    fontWeight: FontWeight.w600,
  );
  static const headlineSmall = TextStyle(
    fontFamily: family,
    fontSize: 28,
    height: 34 / 28,
    fontWeight: FontWeight.w700,
  );
  static const display = TextStyle(
    fontFamily: family,
    fontSize: 40,
    height: 44 / 40,
    fontWeight: FontWeight.w700,
  );
  static const headline = TextStyle(
    fontFamily: family,
    fontSize: 24,
    height: 30 / 24,
    fontWeight: FontWeight.w700,
  );
  static const title = TextStyle(
    fontFamily: family,
    fontSize: 18,
    height: 24 / 18,
    fontWeight: FontWeight.w600,
  );
  static const body = TextStyle(
    fontFamily: family,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
  );
  static const mono = TextStyle(
    fontFamily: monoFamily,
    fontSize: 12,
    height: 16 / 12,
  );
  static const monoLarge = TextStyle(
    fontFamily: monoFamily,
    fontSize: 13,
    height: 18 / 13,
    fontWeight: FontWeight.w500,
  );
}
