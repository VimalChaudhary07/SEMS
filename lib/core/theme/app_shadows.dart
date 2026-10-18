// Implements the Figma Design System card-shadow effects.
import 'package:flutter/material.dart';

abstract final class AppShadows {
  static const card = [
    BoxShadow(color: Color(0x0D101614), offset: Offset(0, 1), blurRadius: 2),
    BoxShadow(color: Color(0x0D101614), offset: Offset(0, 4), blurRadius: 14),
  ];
}
