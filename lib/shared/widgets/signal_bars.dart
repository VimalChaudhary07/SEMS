// Implements Figma component: 0-to-4 Wi-Fi signal bars.
import 'package:flutter/material.dart';

import 'component_theme.dart';

class SignalBars extends StatelessWidget {
  const SignalBars({super.key, required this.level, this.label});

  final int level;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final bars = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var index = 0; index < 4; index++)
          Container(
            width: 4,
            height: 5 + index * 3.5,
            margin: const EdgeInsets.only(right: 2),
            decoration: BoxDecoration(
              color: index < level.clamp(0, 4)
                  ? colors.brandPrimary
                  : colors.border,
              borderRadius: BorderRadius.circular(2),
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
