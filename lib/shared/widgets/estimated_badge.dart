// Implements Figma component: purple Estimated badge with sparkle icon.
import 'package:flutter/material.dart';

import 'status_badge.dart';

class EstimatedBadge extends StatelessWidget {
  const EstimatedBadge({super.key, this.label = 'Estimated'});

  final String label;

  @override
  Widget build(BuildContext context) => StatusBadge(
    label: label,
    tone: StatusTone.ai,
    icon: Icons.auto_awesome,
    compact: true,
  );
}
