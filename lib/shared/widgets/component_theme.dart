// Implements shared Figma component theme helpers.
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

abstract final class ComponentTheme {
  static AppColors colors(BuildContext context) =>
      Theme.of(context).extension<AppColors>() ?? AppColors.light;

  static Color tone(BuildContext context, String tone) {
    final colors = ComponentTheme.colors(context);
    return switch (tone) {
      'ok' => colors.statusOk,
      'warn' => colors.statusWarning,
      'fault' => colors.statusFault,
      'off' => colors.statusOffline,
      'pend' => colors.statusPending,
      'ai' => colors.statusAi,
      'brand' => colors.brandPrimary,
      'yellow' => colors.statusYellow ?? colors.statusWarning,
      'orange' => colors.statusOrange ?? colors.statusWarning,
      'mute' => colors.textSecondary,
      _ => colors.textSecondary,
    };
  }

  static Color tint(BuildContext context, String tone) {
    final colors = ComponentTheme.colors(context);
    final value = switch (tone) {
      'ok' => colors.statusOkTint,
      'warn' => colors.statusWarningTint,
      'fault' => colors.statusFaultTint,
      'off' => colors.statusOfflineTint,
      'pend' => colors.statusPendingTint,
      'ai' => colors.statusAiTint,
      'brand' => colors.brandTint,
      'yellow' => colors.statusWarningTint,
      'orange' => colors.statusWarningTint,
      'mute' => colors.raised,
      _ => colors.raised,
    };
    return value ?? colors.raised;
  }
}

class DashedOutline extends StatelessWidget {
  const DashedOutline({
    super.key,
    required this.child,
    required this.color,
    this.radius = 12,
    this.strokeWidth = 1,
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final Color color;
  final double radius;
  final double strokeWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => CustomPaint(
    foregroundPainter: _DashedOutlinePainter(
      color: color,
      radius: radius,
      strokeWidth: strokeWidth,
    ),
    child: Padding(padding: padding, child: child),
  );
}

class _DashedOutlinePainter extends CustomPainter {
  const _DashedOutlinePainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
  });

  final Color color;
  final double radius;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(strokeWidth / 2),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final dashed = Path();
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + 5).clamp(0.0, metric.length).toDouble();
        dashed.addPath(metric.extractPath(distance, end), Offset.zero);
        distance += 9;
      }
    }
    canvas.drawPath(
      dashed,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }

  @override
  bool shouldRepaint(_DashedOutlinePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      oldDelegate.strokeWidth != strokeWidth;
}
