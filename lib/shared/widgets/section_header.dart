// Implements Figma component: uppercase section heading with optional action.
import 'package:flutter/material.dart';

import '../../core/theme/app_text.dart';
import 'component_theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            title.toUpperCase(),
            style: AppText.section.copyWith(color: colors.textSecondary),
          ),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}
