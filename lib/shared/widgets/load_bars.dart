// Implements Figma component: 24-hour load bars with faint future periods.
import 'package:flutter/material.dart';

import 'component_theme.dart';

class LoadBars extends StatelessWidget {
  const LoadBars({
    super.key,
    required this.values,
    required this.currentHour,
    this.height = 72,
  }) : assert(values.length == 24);

  final List<double> values;
  final int currentHour;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final maxValue = values.fold<double>(
      0,
      (maximum, value) => value > maximum ? value : maximum,
    );
    return Semantics(
      label: 'Hourly load chart, current hour ${currentHour.clamp(0, 23)}',
      child: SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var hour = 0; hour < values.length; hour++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: FractionallySizedBox(
                    heightFactor: maxValue == 0
                        ? .04
                        : (values[hour] / maxValue).clamp(.04, 1),
                    alignment: Alignment.bottomCenter,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: hour > currentHour
                            ? colors.raised.withValues(alpha: .55)
                            : hour == currentHour
                            ? colors.brandPrimary
                            : colors.brandTint,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(3),
                        ),
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
