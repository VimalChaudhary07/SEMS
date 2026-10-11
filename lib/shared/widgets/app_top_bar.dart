// Implements Figma component: app bar with optional role badge.
import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import 'role_badge.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.actions = const [],
    this.isFamily,
    this.leading,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final List<Widget> actions;
  final bool? isFamily;
  final Widget? leading;

  @override
  Size get preferredSize => Size.fromHeight(subtitle == null ? 64 : 76);

  @override
  Widget build(BuildContext context) => AppBar(
    leading:
        leading ??
        (onBack == null
            ? null
            : IconButton(
                tooltip: 'Back',
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded),
              )),
    titleSpacing: AppSpacing.screen,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        if (subtitle != null)
          Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
      ],
    ),
    actions: [
      if (isFamily != null) ...[
        RoleBadge(isFamily: isFamily!),
        const SizedBox(width: 8),
      ],
      ...actions,
      if (actions.isNotEmpty) const SizedBox(width: 8),
    ],
  );
}
