// Implements Figma component: titled settings group with dividers.
import 'package:flutter/material.dart';

import '../../core/theme/app_radii.dart';
import 'app_row.dart';
import 'component_theme.dart';

class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, required this.title, required this.children});

  final String title;
  final List<AppRow> children;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: .7,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            children: [
              for (var index = 0; index < children.length; index++) ...[
                if (index > 0)
                  Divider(height: 1, indent: 14, color: colors.border),
                children[index],
              ],
            ],
          ),
        ),
      ],
    );
  }
}
