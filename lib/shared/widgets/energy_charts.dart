// Implements Figma components: Energy bar, area, forecast and data-gap charts.
import 'package:flutter/material.dart';

import 'component_theme.dart';

class EnergyBarChart extends StatelessWidget {
  const EnergyBarChart({
    super.key,
    required this.values,
    this.labels = const [],
    this.selectedIndex,
    this.dataGap = false,
    this.height = 184,
  });

  final List<double?> values;
  final List<String> labels;
  final int? selectedIndex;
  final bool dataGap;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final maxValue = values.fold<double>(
      0,
      (maximum, value) => value != null && value > maximum ? value : maximum,
    );
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: labels.isEmpty ? 0 : 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < values.length; index++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: values[index] == null
                          ? const SizedBox.shrink()
                          : FractionallySizedBox(
                              heightFactor: maxValue <= 0
                                  ? .02
                                  : (values[index]! / maxValue).clamp(.02, 1),
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: index == selectedIndex
                                      ? colors.brandPrimary
                                      : colors.brandTint,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
              ],
            ),
          ),
          if (labels.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 20,
              child: Row(
                children: [
                  for (var index = 0; index < values.length; index++)
                    Expanded(
                      child: Text(
                        index < labels.length ? labels[index] : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          if (dataGap)
            Positioned.fill(
              child: ColoredBox(
                color: colors.background.withValues(alpha: .74),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: colors.border),
                    ),
                    child: const Text('No data received'),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class EnergyAreaChart extends StatelessWidget {
  const EnergyAreaChart({
    super.key,
    required this.values,
    this.forecastStart,
    this.lowerForecast,
    this.upperForecast,
    this.dataGap = false,
    this.height = 200,
  });

  final List<double?> values;
  final int? forecastStart;
  final List<double>? lowerForecast;
  final List<double>? upperForecast;
  final bool dataGap;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: _EnergyAreaPainter(
              values: values,
              forecastStart: forecastStart,
              lowerForecast: lowerForecast,
              upperForecast: upperForecast,
              lineColor: colors.brandPrimary,
              fillColor: colors.brandTint,
            ),
          ),
          if (dataGap)
            Positioned.fill(
              child: ColoredBox(
                color: colors.background.withValues(alpha: .74),
                child: const Center(child: Text('No data received')),
              ),
            ),
        ],
      ),
    );
  }
}

class _EnergyAreaPainter extends CustomPainter {
  const _EnergyAreaPainter({
    required this.values,
    required this.forecastStart,
    required this.lowerForecast,
    required this.upperForecast,
    required this.lineColor,
    required this.fillColor,
  });

  final List<double?> values;
  final int? forecastStart;
  final List<double>? lowerForecast;
  final List<double>? upperForecast;
  final Color lineColor;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2 || size.isEmpty) return;
    final numbers = <double>[
      ...values.whereType<double>(),
      ...?lowerForecast,
      ...?upperForecast,
    ];
    if (numbers.isEmpty) return;
    final maximum = numbers.reduce((a, b) => a > b ? a : b);
    final minimum = numbers.reduce((a, b) => a < b ? a : b);
    final span = (maximum - minimum).abs() < .001 ? 1.0 : maximum - minimum;
    Offset point(int index, double value) => Offset(
      size.width * index / (values.length - 1),
      size.height * (1 - (value - minimum) / span),
    );

    final actualSegments = <Path>[];
    final forecastSegments = <Path>[];
    Path? current;
    bool? currentIsForecast;
    final forecastLineStart =
        forecastStart ??
        (lowerForecast == null ? null : values.length - lowerForecast!.length);
    void finishSegment() {
      if (current == null) return;
      (currentIsForecast! ? forecastSegments : actualSegments).add(current!);
      current = null;
      currentIsForecast = null;
    }

    for (var index = 0; index < values.length; index++) {
      final value = values[index];
      if (value == null) {
        finishSegment();
        continue;
      }
      final isForecast =
          forecastLineStart != null && index >= forecastLineStart;
      if (currentIsForecast != isForecast) finishSegment();
      final currentPoint = point(index, value);
      if (current == null) {
        current = Path()..moveTo(currentPoint.dx, currentPoint.dy);
        currentIsForecast = isForecast;
      } else {
        current!.lineTo(currentPoint.dx, currentPoint.dy);
      }
    }
    finishSegment();

    if (lowerForecast != null &&
        upperForecast != null &&
        lowerForecast!.isNotEmpty &&
        upperForecast!.isNotEmpty) {
      final start = (forecastStart ?? values.length - lowerForecast!.length)
          .clamp(0, values.length - 1);
      final requestedCount = lowerForecast!.length < upperForecast!.length
          ? lowerForecast!.length
          : upperForecast!.length;
      final safeForecastCount = requestedCount < values.length - start
          ? requestedCount
          : values.length - start;
      final band = Path();
      for (var index = 0; index < safeForecastCount; index++) {
        final position = (start + index).clamp(0, values.length - 1);
        final p = point(position, upperForecast![index]);
        if (index == 0) {
          band.moveTo(p.dx, p.dy);
        } else {
          band.lineTo(p.dx, p.dy);
        }
      }
      for (var index = safeForecastCount - 1; index >= 0; index--) {
        final position = (start + index).clamp(0, values.length - 1);
        final p = point(position, lowerForecast![index]);
        band.lineTo(p.dx, p.dy);
      }
      band.close();
      canvas.drawPath(
        band,
        Paint()
          ..color = fillColor.withValues(alpha: .55)
          ..style = PaintingStyle.fill,
      );
    }

    final line = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final path in actualSegments) {
      canvas.drawPath(path, line);
    }
    final dashedLine = Paint()
      ..color = lineColor.withValues(alpha: .8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final path in forecastSegments) {
      for (final metric in path.computeMetrics()) {
        final dashPath = Path();
        var offset = 0.0;
        while (offset < metric.length) {
          dashPath.addPath(
            metric.extractPath(offset, (offset + 5).clamp(0, metric.length)),
            Offset.zero,
          );
          offset += 9;
        }
        canvas.drawPath(dashPath, dashedLine);
      }
    }
  }

  @override
  bool shouldRepaint(_EnergyAreaPainter oldDelegate) =>
      oldDelegate.values != values ||
      oldDelegate.forecastStart != forecastStart ||
      oldDelegate.lowerForecast != lowerForecast ||
      oldDelegate.upperForecast != upperForecast ||
      oldDelegate.lineColor != lineColor ||
      oldDelegate.fillColor != fillColor;
}
