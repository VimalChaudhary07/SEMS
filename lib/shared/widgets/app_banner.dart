// Implements Figma component: inline status banner.
import 'package:flutter/material.dart';

import 'status_badge.dart';
import 'component_theme.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({
    super.key,
    required this.tone,
    required this.title,
    this.body,
    this.actionText,
    this.onAction,
    this.icon,
  });

  final StatusTone tone;
  final String title;
  final String? body;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData? icon;

  String get _toneName => switch (tone) {
    StatusTone.ok => 'ok',
    StatusTone.warn || StatusTone.yellow || StatusTone.orange => 'warn',
    StatusTone.fault => 'fault',
    StatusTone.off => 'off',
    StatusTone.pend => 'pend',
    StatusTone.ai => 'ai',
    StatusTone.brand => 'brand',
    StatusTone.mute => 'mute',
  };

  IconData get _defaultIcon => switch (tone) {
    StatusTone.ok => Icons.check_circle_outline,
    StatusTone.warn ||
    StatusTone.yellow ||
    StatusTone.orange => Icons.warning_amber_rounded,
    StatusTone.fault => Icons.error_outline,
    StatusTone.off => Icons.wifi_off_outlined,
    StatusTone.pend => Icons.pending_outlined,
    StatusTone.ai => Icons.auto_awesome_outlined,
    StatusTone.brand => Icons.info_outline,
    StatusTone.mute => Icons.info_outline,
  };

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final color = ComponentTheme.tone(context, _toneName);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ComponentTheme.tint(context, _toneName),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? _defaultIcon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (body != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    body!,
                    style: TextStyle(color: colors.textSecondary, fontSize: 12),
                  ),
                ],
                if (actionText != null) ...[
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      foregroundColor: color,
                    ),
                    child: Text(actionText!),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
