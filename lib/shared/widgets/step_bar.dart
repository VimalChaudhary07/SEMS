// Implements Figma component: segmented multi-step progress bar.
import 'package:flutter/material.dart';

import 'component_theme.dart';

class StepBar extends StatelessWidget {
  const StepBar({
    super.key,
    required this.steps,
    required this.currentStep,
    this.spacing = 5,
  });

  final int steps;
  final int currentStep;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final safeSteps = steps.clamp(1, 100);
    final safeCurrent = currentStep.clamp(0, safeSteps);
    return Semantics(
      label: 'Step $safeCurrent of $safeSteps',
      child: Row(
        children: [
          for (var step = 0; step < safeSteps; step++) ...[
            if (step > 0) SizedBox(width: spacing),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 5,
                decoration: BoxDecoration(
                  color: step < safeCurrent
                      ? colors.brandPrimary
                      : colors.raised,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
