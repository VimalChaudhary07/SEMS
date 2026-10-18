// Implements Figma component: 0-to-4 Wi-Fi signal bars.
import 'package:flutter/material.dart';

import 'component_theme.dart';

class SignalBars extends StatelessWidget {
  const SignalBars({
    super.key,
    required this.level,
    this.label,
    this.activeColor,
    this.inactiveColor,
  });

  final int level;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;

  static const List<double> _barHeights = [5.6, 8.2, 10.8, 13.4];

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final onColor = activeColor ?? colors.brandPrimary;
    final offColor = inactiveColor ?? colors.border;
    final bars = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var index = 0; index < 4; index++)
          Container(
            width: 3,
            height: _barHeights[index],
            margin: EdgeInsets.only(right: index < 3 ? 2 : 0),
            decoration: BoxDecoration(
              color: index < level.clamp(0, 4) ? onColor : offColor,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
      ],
    );
    return Semantics(
      label: label ?? 'Signal strength ${level.clamp(0, 4)} of 4',
      child: ExcludeSemantics(child: bars),
    );
  }
}
