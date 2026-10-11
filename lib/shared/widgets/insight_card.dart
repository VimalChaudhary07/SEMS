// Implements Figma component: AI insight card with estimated severity.
import 'package:flutter/material.dart';

import 'app_card.dart';
import 'component_theme.dart';
import 'estimated_badge.dart';
import 'status_badge.dart';

enum InsightSeverity { info, low, warning, high }

class InsightCard extends StatelessWidget {
  const InsightCard({
    super.key,
    required this.title,
    required this.body,
    required this.severity,
    this.estimated = true,
    this.onTap,
  });

  final String title;
  final String body;
  final InsightSeverity severity;
  final bool estimated;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final tone = switch (severity) {
      InsightSeverity.info || InsightSeverity.low => StatusTone.ai,
      InsightSeverity.warning => StatusTone.warn,
      InsightSeverity.high => StatusTone.fault,
    };
    return AppCard(
      accentColor: switch (severity) {
        InsightSeverity.info || InsightSeverity.low => colors.statusAi,
        InsightSeverity.warning => colors.statusWarning,
        InsightSeverity.high => colors.statusFault,
      },
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 17, color: colors.statusAi),
              const SizedBox(width: 6),
              StatusBadge(label: severity.name.toUpperCase(), tone: tone),
              const Spacer(),
              if (estimated) const EstimatedBadge(),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 5),
          Text(body, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
