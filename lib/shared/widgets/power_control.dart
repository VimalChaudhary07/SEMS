// Implements Figma component: circular remote power control states.
import 'package:flutter/material.dart';

import 'component_theme.dart';

enum PowerControlState { on, off, pending, failed, offline, blocked }

class PowerControl extends StatelessWidget {
  const PowerControl({
    super.key,
    required this.state,
    required this.onPressed,
    this.size = 192,
    this.label,
  });

  final PowerControlState state;
  final VoidCallback? onPressed;
  final double size;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final color = switch (state) {
      PowerControlState.on => colors.brandPrimary,
      PowerControlState.off => colors.textSecondary,
      PowerControlState.pending => colors.statusPending,
      PowerControlState.failed ||
      PowerControlState.blocked => colors.statusFault,
      PowerControlState.offline => colors.statusOffline,
    };
    final enabled =
        onPressed != null &&
        state != PowerControlState.pending &&
        state != PowerControlState.offline &&
        state != PowerControlState.blocked;
    final stateLabel =
        label ??
        switch (state) {
          PowerControlState.on => 'Turn off',
          PowerControlState.off => 'Turn on',
          PowerControlState.pending => 'Command pending',
          PowerControlState.failed => 'Command failed, retry',
          PowerControlState.offline => 'Socket offline',
          PowerControlState.blocked => 'Blocked by safety limit',
        };
    return Semantics(
      button: enabled,
      label: stateLabel,
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.square(
              dimension: size,
              child: CircularProgressIndicator(
                value: state == PowerControlState.pending ? null : 1,
                strokeWidth: 6,
                color: color.withValues(alpha: .28),
                backgroundColor: colors.raised,
              ),
            ),
            Material(
              color: color.withValues(alpha: .1),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: enabled ? onPressed : null,
                child: SizedBox.square(
                  dimension: size - 28,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.power_settings_new,
                          size: size * .2,
                          color: color,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          stateLabel,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w700,
                            fontSize: size < 140 ? 9 : 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
