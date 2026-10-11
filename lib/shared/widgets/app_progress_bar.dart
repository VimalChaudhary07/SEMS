// Implements Figma component: toned linear progress bar.
import 'package:flutter/material.dart';

import 'component_theme.dart';

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.tone = 'brand',
    this.height = 6,
  });

  final double value;
  final String tone;
  final double height;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(999),
    child: LinearProgressIndicator(
      value: value.clamp(0, 1),
      minHeight: height,
      color: ComponentTheme.tone(context, tone),
      backgroundColor: ComponentTheme.tint(context, tone),
    ),
  );
}
