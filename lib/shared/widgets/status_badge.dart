import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_radii.dart';
import 'component_theme.dart';

enum StatusTone { ok, warn, fault, off, pend, ai, brand, mute, yellow, orange }

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    this.tone = StatusTone.mute,
    this.icon,
    this.svgAsset,
    this.compact = false,
  });

  final String label;
  final StatusTone tone;
  final IconData? icon;
  final String? svgAsset;
  final bool compact;

  String get _toneName => switch (tone) {
    StatusTone.ok => 'ok',
    StatusTone.warn => 'warn',
    StatusTone.fault => 'fault',
    StatusTone.off => 'off',
    StatusTone.pend => 'pend',
    StatusTone.ai => 'ai',
    StatusTone.brand => 'brand',
    StatusTone.mute => 'mute',
    StatusTone.yellow => 'yellow',
    StatusTone.orange => 'orange',
  };

  @override
  Widget build(BuildContext context) {
    final foreground = ComponentTheme.tone(context, _toneName);
    return Container(
      constraints: const BoxConstraints(minHeight: 24),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: ComponentTheme.tint(context, _toneName),
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (svgAsset != null) ...[
            SvgPicture.asset(
              svgAsset!,
              width: 13,
              height: 13,
              colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
            ),
            const SizedBox(width: 4),
          ] else if (icon != null) ...[
            Icon(icon, size: 13, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              height: 1.2,
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
