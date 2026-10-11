// Implements Figma component: measured, estimated and billed metric tile.
import 'package:flutter/material.dart';

import '../../core/theme/app_radii.dart';
import 'component_theme.dart';
import 'estimated_badge.dart';

enum MetricKind { measured, estimated, billed }

class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.kind = MetricKind.measured,
    this.icon,
  });

  final String label;
  final String value;
  final String? unit;
  final MetricKind kind;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final content = Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(color: colors.textSecondary, fontSize: 12),
                ),
              ),
              if (kind == MetricKind.estimated)
                Icon(Icons.auto_awesome, size: 15, color: colors.statusAi),
              if (kind == MetricKind.billed)
                Icon(
                  icon ?? Icons.receipt_long_outlined,
                  size: 16,
                  color: colors.textSecondary,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 4),
                Text(
                  unit!,
                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                ),
              ],
            ],
          ),
          if (kind == MetricKind.estimated) ...[
            const SizedBox(height: 8),
            const EstimatedBadge(),
          ],
        ],
      ),
    );

    if (kind == MetricKind.estimated) {
      return DashedOutline(
        color: colors.statusAi,
        radius: AppRadii.card,
        padding: EdgeInsets.zero,
        child: content,
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: kind == MetricKind.billed ? colors.raised : colors.card,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: colors.border),
      ),
      child: content,
    );
  }
}
