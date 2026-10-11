// Implements Figma component: Family permission gate presentation.
import 'package:flutter/material.dart';

import 'empty_state.dart';

enum PermissionPresentation { hidden, dimmed, locked, readOnly }

class PermissionGate extends StatelessWidget {
  const PermissionGate({
    super.key,
    required this.allowed,
    required this.child,
    this.fallback,
    this.presentation = PermissionPresentation.hidden,
    this.explanation = 'Only the Owner can do this.',
  });

  final bool allowed;
  final Widget child;
  final Widget? fallback;
  final PermissionPresentation presentation;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    if (allowed) return child;
    return switch (presentation) {
      PermissionPresentation.hidden => const SizedBox.shrink(),
      PermissionPresentation.dimmed => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Opacity(opacity: .45, child: IgnorePointer(child: child)),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              explanation,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
      PermissionPresentation.locked =>
        fallback ??
            EmptyState(
              title: 'Owner access required',
              message: explanation,
              icon: Icons.lock_outline,
            ),
      PermissionPresentation.readOnly => IgnorePointer(
        child: ExcludeFocus(child: child),
      ),
    };
  }
}
