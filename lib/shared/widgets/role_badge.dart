// Implements Figma component: Owner and Family role badge.
import 'package:flutter/material.dart';

import 'status_badge.dart';

class RoleBadge extends StatelessWidget {
  const RoleBadge({super.key, required this.isFamily, this.showIcon = true});

  final bool isFamily;
  final bool showIcon;

  @override
  Widget build(BuildContext context) => StatusBadge(
    label: isFamily ? 'Family' : 'Owner',
    tone: isFamily ? StatusTone.pend : StatusTone.brand,
    icon: showIcon ? (isFamily ? Icons.people_outline : Icons.shield_outlined) : null,
    compact: true,
  );
}
