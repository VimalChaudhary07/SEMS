// Implements Figma component: settings and list row.
import 'package:flutter/material.dart';

import 'component_theme.dart';

class AppRow extends StatelessWidget {
  const AppRow({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    this.showChevron = false,
    this.danger = false,
    this.dimmed = false,
    this.semanticLabel,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;
  final bool danger;
  final bool dimmed;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final foreground = danger ? colors.statusFault : colors.textPrimary;
    return Semantics(
      button: onTap != null,
      label: semanticLabel,
      child: Opacity(
        opacity: dimmed ? .45 : 1,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: danger
                            ? colors.statusFault.withValues(alpha: .1)
                            : colors.raised,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, size: 19, color: foreground),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: foreground,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                  ?trailing,
                  if (showChevron)
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colors.textSecondary,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
