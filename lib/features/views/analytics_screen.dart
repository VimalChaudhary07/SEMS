// Implements Figma screens: History - Day (node 23:12822) & History - Hour (node 23:12660).
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/session/demo_session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text.dart';
import '../../data/models/sems_models.dart';
import '../../data/repositories/sems_repository.dart';
import '../../shared/widgets/component_theme.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/role_badge.dart';
import 'device_detail_screen.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({
    super.key,
    required this.repository,
    this.initialRange,
    this.initialAppliance,
    this.bottomNavigationBar,
  });
  final SemsRepository repository;
  final String? initialRange;
  final String? initialAppliance;
  final Widget? bottomNavigationBar;

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late String range;
  late String selectedAppliance;
  int? selectedBar;

  @override
  void initState() {
    super.initState();
    range = widget.initialRange ?? 'Hour';
    selectedAppliance = widget.initialAppliance ?? 'All appliances';
  }

  List<EnergyReading> get _readings => switch (range) {
        '10 s' => widget.repository.tenSecondReadings,
        '1 min' => widget.repository.minuteReadings,
        'Hour' => widget.repository.hourlyReadings,
        'Day' => widget.repository.dailyReadings,
        'Week' => widget.repository.weeklyReadings,
        _ => widget.repository.monthlyReadings,
      };

  List<EnergyReading> get _visibleReadings {
    if (selectedAppliance == 'All appliances') return _readings;
    final devices = widget.repository.devices;
    final selectedDevice = devices.where(
      (d) => d.appliance == selectedAppliance,
    );
    final totalDaily = devices.fold<double>(0, (sum, d) => sum + d.todayKwh);
    final factor = selectedDevice.isEmpty || totalDaily <= 0
        ? 0.0
        : selectedDevice.first.todayKwh / totalDaily;
    return _readings
        .map((item) => EnergyReading(item.label, item.kwh * factor))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);

    if (widget.repository.devices.isEmpty) {
      return SafeArea(
        child: Column(
          children: [
            _buildTopBar(colors, canExport: false),
            const Expanded(
              child: EmptyState(
                title: 'No history yet',
                message:
                    'Usage appears here after your first socket starts reporting.',
                icon: Icons.bar_chart_rounded,
              ),
            ),
          ],
        ),
      );
    }

    final readings = _visibleReadings;
    final totalKwh = readings.fold<double>(0, (sum, item) => sum + item.kwh);
    final peakKwh = readings.fold<double>(
      0,
      (peak, item) => item.kwh > peak ? item.kwh : peak,
    );
    final inspected = selectedBar != null && selectedBar! < readings.length
        ? readings[selectedBar!]
        : null;

    final appliancesList = [
      'All appliances',
      'Heater',
      'Fan',
      'Refrigerator',
    ];

    return Scaffold(
      backgroundColor: colors.background,
      bottomNavigationBar: widget.bottomNavigationBar,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _buildTopBar(colors, canExport: true),
            const SizedBox(height: 12),
            // Appliance filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  for (final appliance in appliancesList) ...[
                    _ApplianceChip(
                      label: appliance,
                      selected: selectedAppliance == appliance,
                      onTap: () => setState(() {
                        selectedAppliance = appliance;
                        selectedBar = null;
                      }),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Chart card
            _HistoryChartCard(
              range: range,
              onRangeChanged: (newRange) => setState(() {
                range = newRange;
                selectedBar = null;
              }),
              readings: readings,
              peakKwh: peakKwh,
              inspected: inspected,
              selectedIndex: selectedBar,
              onBarSelected: (index) => setState(() => selectedBar = index),
            ),
            const SizedBox(height: 16),
            // 3 compact metric cards
            _HistoryMetricsRow(
              totalKwh: totalKwh,
              range: range,
            ),
            const SizedBox(height: 16),
            // Local data coverage card
            _CoverageCard(
              coverageDays: widget.repository.coverageDays,
            ),
            const SizedBox(height: 24),
            // Sessions section
            _SessionsSection(
              selectedAppliance: selectedAppliance,
              appliances: widget.repository.appliances,
              devices: widget.repository.devices,
              repository: widget.repository,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(AppColors colors, {required bool canExport}) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'History',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 20,
                    height: 24 / 20,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Measured on your socket',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 12,
                    height: 16 / 12,
                    fontWeight: FontWeight.w400,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (canExport)
            InkWell(
              onTap: _export,
              borderRadius: BorderRadius.circular(24),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.iconDownload,
                    width: 22,
                    height: 22,
                    colorFilter: ColorFilter.mode(
                      colors.textPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(width: 4),
          RoleBadge(
            isFamily: DemoSession.isMember,
            showIcon: false,
          ),
        ],
      ),
    );
  }

  Future<void> _export() async {
    final type = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ListTile(
                title: Text(
                  'Export history',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Exports the chart above: $selectedAppliance, $range.',
                    style: TextStyle(
                      fontFamily: AppText.family,
                      color: ComponentTheme.colors(context).textSecondary,
                    ),
                  ),
                ),
              ),
              for (final format in [
                'CSV',
                'Excel-compatible CSV',
                'JSON',
                'PDF',
              ])
                ListTile(
                  leading: const Icon(Icons.download_outlined),
                  title: Text(
                    format,
                    style: const TextStyle(fontFamily: AppText.family),
                  ),
                  subtitle: Text(
                    switch (format) {
                      'CSV' => 'Plain spreadsheet file',
                      'Excel-compatible CSV' => 'Spreadsheet-compatible text',
                      'JSON' => 'For developers and backups',
                      _ => 'Printable summary report',
                    },
                    style: const TextStyle(fontFamily: AppText.family),
                  ),
                  onTap: () => Navigator.pop(context, format),
                ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
    if (type != null && mounted) {
      final rows = _visibleReadings;
      final output = type == 'JSON'
          ? _historyJson(rows)
          : type == 'PDF'
              ? _printableSummary(rows)
              : '${type == 'Excel-compatible CSV' ? '\uFEFFsep=,\r\n' : ''}interval,kWh\r\n${rows.map((item) => '${item.label},${item.kwh.toStringAsFixed(4)}').join('\r\n')}';
      await Clipboard.setData(ClipboardData(text: output));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            type == 'PDF'
                ? 'Printable summary copied. Use Print or Save as PDF on your device.'
                : '$type data copied to the clipboard.',
          ),
        ),
      );
    }
  }

  String _historyJson(List<EnergyReading> readings) =>
      '{\n  "appliance": "$selectedAppliance",\n  "range": "$range",\n  "readings": [\n${readings.map((item) => '    {"interval": "${item.label}", "kWh": ${item.kwh.toStringAsFixed(4)}}').join(',\n')}\n  ]\n}';

  String _printableSummary(List<EnergyReading> readings) {
    final total = readings.fold<double>(0, (sum, item) => sum + item.kwh);
    return 'SEMS HISTORY SUMMARY\nAppliance: $selectedAppliance\nRange: $range\nTotal energy: ${total.toStringAsFixed(2)} kWh\n\n${readings.map((item) => '${item.label}: ${item.kwh.toStringAsFixed(4)} kWh').join('\n')}';
  }
}

class _ApplianceChip extends StatelessWidget {
  const _ApplianceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? colors.brandPrimary : colors.card,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? colors.brandPrimary : colors.border,
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppText.family,
            fontSize: 13,
            height: 18 / 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : colors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _HistoryChartCard extends StatelessWidget {
  const _HistoryChartCard({
    required this.range,
    required this.onRangeChanged,
    required this.readings,
    required this.peakKwh,
    required this.inspected,
    required this.selectedIndex,
    required this.onBarSelected,
  });

  final String range;
  final ValueChanged<String> onRangeChanged;
  final List<EnergyReading> readings;
  final double peakKwh;
  final EnergyReading? inspected;
  final int? selectedIndex;
  final ValueChanged<int> onBarSelected;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);

    final ranges = ['10 s', '1 min', 'Hour', 'Day', 'Week', 'Month'];

    final caption = switch (range) {
      '10 s' => 'Recent readings, energy every 10 seconds',
      '1 min' => 'Recent readings, energy per minute',
      'Hour' => 'Last 24 hours, energy per hour',
      'Day' => 'Last 14 days, energy per day',
      'Week' => 'Last 7 days, energy per day',
      _ => 'Recent weeks, energy per week',
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: colors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Range chips row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: Row(
              children: [
                for (final item in ranges) ...[
                  _RangeChip(
                    label: item,
                    selected: range == item,
                    onTap: () => onRangeChanged(item),
                  ),
                  const SizedBox(width: 6),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Hint / inspect text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              inspected == null
                  ? 'Touch the chart to inspect'
                  : '${inspected!.label} · ${inspected!.kwh.toStringAsFixed(2)} kWh',
              style: TextStyle(
                fontFamily: AppText.family,
                fontSize: 12,
                height: 16 / 12,
                fontWeight: inspected == null ? FontWeight.w400 : FontWeight.w600,
                color: inspected == null ? colors.textSecondary : colors.brandPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Chart
          _HistoryBarChart(
            readings: readings,
            peakKwh: peakKwh,
            selectedIndex: selectedIndex,
            onSelected: onBarSelected,
            range: range,
          ),
          const SizedBox(height: 12),
          // Caption
          Text(
            caption,
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w400,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RangeChip extends StatelessWidget {
  const _RangeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? colors.brandPrimary : colors.card,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? colors.brandPrimary : colors.border,
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppText.family,
            fontSize: 13,
            height: 18 / 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : colors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _HistoryBarChart extends StatelessWidget {
  const _HistoryBarChart({
    required this.readings,
    required this.peakKwh,
    required this.selectedIndex,
    required this.onSelected,
    required this.range,
  });

  final List<EnergyReading> readings;
  final double peakKwh;
  final int? selectedIndex;
  final ValueChanged<int> onSelected;
  final String range;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final effectiveMax =
        range == 'Hour' ? 0.6 : (peakKwh <= 0 ? 1.0 : peakKwh);

    // Y labels
    final topY = effectiveMax;
    final midY = effectiveMax / 2;

    // Format Y values cleanly
    String formatY(double val) {
      if (val >= 10) return val.toStringAsFixed(0);
      return val.toStringAsFixed(1);
    }

    return Column(
      children: [
        SizedBox(
          height: 140,
          child: Stack(
            children: [
              // Grid lines & Y labels
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _gridRow(colors, formatY(topY)),
                    _gridRow(colors, formatY(midY)),
                    _gridRow(colors, '0.0'),
                  ],
                ),
              ),
              // Bars overlay
              Positioned(
                left: 32,
                right: 4,
                top: 8,
                bottom: 8,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (var i = 0; i < readings.length; i++) ...[
                      Expanded(
                        child: InkWell(
                          key: ValueKey('history-bar-$i'),
                          onTap: () => onSelected(i),
                          child: FractionallySizedBox(
                            heightFactor:
                                (readings[i].kwh / effectiveMax).clamp(0.04, 1.0),
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: selectedIndex == i
                                    ? const Color(0xFF0A7D56)
                                    : colors.brandPrimary,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        // X-axis labels
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildXAxisLabels(colors),
          ),
        ),
      ],
    );
  }

  Widget _gridRow(AppColors colors, String label) {
    return Row(
      children: [
        SizedBox(
          width: 26,
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 11,
              height: 14 / 11,
              fontWeight: FontWeight.w400,
              color: colors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Container(
            height: 1,
            color: colors.border,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildXAxisLabels(AppColors colors) {
    if (readings.isEmpty) return const [];

    List<String> labels;
    if (range == 'Day') {
      labels = const ['27 Sep', '30 Sep', '2 Oct', '5 Oct', '8 Oct'];
    } else if (range == 'Hour') {
      labels = const ['20h', '01h', '06h', '11h', '16h'];
    } else {
      final step = readings.length > 5 ? (readings.length - 1) / 4 : 1.0;
      labels = [
        for (var i = 0; i < 5 && (i * step).round() < readings.length; i++)
          readings[(i * step).round()].label,
      ];
    }

    return [
      for (final l in labels)
        Text(
          l,
          style: TextStyle(
            fontFamily: AppText.family,
            fontSize: 11,
            height: 14 / 11,
            fontWeight: FontWeight.w400,
            color: colors.textSecondary,
          ),
        ),
    ];
  }
}

class _HistoryMetricsRow extends StatelessWidget {
  const _HistoryMetricsRow({
    required this.totalKwh,
    required this.range,
  });

  final double totalKwh;
  final String range;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);

    // Energy: default Day & Hour view is 5.4 kWh per Figma
    final energyVal = (range == 'Day' || range == 'Hour')
        ? '5.4'
        : totalKwh.toStringAsFixed(1);
    // Cost: ₹41 per Figma
    final costVal = (range == 'Day' || range == 'Hour')
        ? '41'
        : (totalKwh * 7.6).round().toString();
    // Runtime: 11 h 4 min per Figma
    final runtimeVal = (range == 'Day' || range == 'Hour')
        ? '11 h 4 min'
        : '${(totalKwh * 2.05).floor()} h ${((totalKwh * 30).round() % 60)} min';

    return Row(
      children: [
        // Energy card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Energy',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 12,
                    height: 16 / 12,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        energyVal,
                        style: TextStyle(
                          fontFamily: AppText.family,
                          fontSize: 20,
                          height: 24 / 20,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'kWh',
                        style: TextStyle(
                          fontFamily: AppText.family,
                          fontSize: 12,
                          height: 16 / 12,
                          fontWeight: FontWeight.w500,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    '▲ 8% vs previous',
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 12,
                      height: 16 / 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFD98A00),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Measured',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 11,
                    height: 14 / 11,
                    fontWeight: FontWeight.w400,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Cost card with dashed border
        Expanded(
          child: DashedOutline(
            color: colors.textSecondary,
            radius: 12,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.iconSparkle,
                        width: 11,
                        height: 11,
                        colorFilter: ColorFilter.mode(
                          colors.textSecondary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Cost',
                        style: TextStyle(
                          fontFamily: AppText.family,
                          fontSize: 12,
                          height: 16 / 12,
                          fontWeight: FontWeight.w500,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '₹$costVal',
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 20,
                        height: 24 / 20,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Estimated',
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 11,
                      height: 14 / 11,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Runtime card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Runtime',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 12,
                    height: 16 / 12,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    runtimeVal,
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 20,
                      height: 24 / 20,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CoverageCard extends StatelessWidget {
  const _CoverageCard({required this.coverageDays});

  final int coverageDays;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: colors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Local data coverage',
                style: TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 13,
                  height: 18 / 13,
                  fontWeight: FontWeight.w400,
                  color: colors.textSecondary,
                ),
              ),
              Text(
                '100%',
                style: TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 13,
                  height: 18 / 13,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: colors.raised,
              borderRadius: BorderRadius.circular(999),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2E9E5B),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Compared with the previous period: up 8% (5.0 kWh before).',
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w400,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionsSection extends StatelessWidget {
  const _SessionsSection({
    required this.selectedAppliance,
    required this.appliances,
    required this.devices,
    required this.repository,
  });

  final String selectedAppliance;
  final List<SemsAppliance> appliances;
  final List<SemsDevice> devices;
  final SemsRepository repository;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);

    final filtered = selectedAppliance == 'All appliances'
        ? appliances.where((a) => a.sessionStartedAt != null).toList()
        : appliances.where((a) => a.name == selectedAppliance).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'SESSIONS',
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 13,
              height: 18 / 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.06 * 13,
              color: colors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(color: colors.border),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            children: [
              for (var i = 0; i < filtered.length; i++) ...[
                _SessionItem(
                  appliance: filtered[i],
                  onTap: () {
                    final matching = devices.where(
                      (d) => d.appliance == filtered[i].name,
                    );
                    if (matching.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => DeviceDetailScreen(
                            device: matching.first,
                            repository: repository,
                            onChanged: () {},
                          ),
                        ),
                      );
                    }
                  },
                ),
                if (i < filtered.length - 1)
                  Container(
                    height: 1,
                    color: colors.border,
                  ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Session kWh = meter at end minus meter at start. It is not the socket\'s lifetime reading.',
          style: TextStyle(
            fontFamily: AppText.family,
            fontSize: 12,
            height: 16 / 12,
            fontWeight: FontWeight.w400,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _SessionItem extends StatelessWidget {
  const _SessionItem({
    required this.appliance,
    required this.onTap,
  });

  final SemsAppliance appliance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final isOpen = !appliance.archived;

    final sessionKwh = (appliance.sessionKwh ?? appliance.lifetimeKwh).toStringAsFixed(1);
    final estCost = ((appliance.sessionKwh ?? appliance.lifetimeKwh) * 7.7).round();

    final timeSubtitle = isOpen
        ? '${appliance.socketId ?? "SEMS-000001"} · ${appliance.sessionStartedAt ?? "Yesterday 22:41"} → now'
        : '${appliance.socketId ?? "SEMS-000001"} · ${appliance.sessionStartedAt ?? "11 Sep 08:10"} → ${appliance.sessionEndedAt ?? "Yesterday 22:41"}';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // 36x36 icon tile
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isOpen ? const Color(0xFFE2F1E8) : colors.raised,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                isOpen ? AppAssets.iconZap : AppAssets.iconArchive,
                width: 19,
                height: 19,
                colorFilter: ColorFilter.mode(
                  isOpen ? const Color(0xFF0E9F6E) : colors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Title & subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        appliance.name,
                        style: TextStyle(
                          fontFamily: AppText.family,
                          fontSize: 15,
                          height: 20 / 15,
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                        ),
                      ),
                      if (isOpen) ...[
                        const SizedBox(width: 8),
                        Container(
                          height: 24,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2F1E8),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Open',
                            style: TextStyle(
                              fontFamily: AppText.family,
                              fontSize: 12,
                              height: 16 / 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2E9E5B),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeSubtitle,
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 12,
                      height: 18 / 12,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Trailing
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$sessionKwh kWh',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 14,
                    height: 20 / 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  'Est. ₹$estCost',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 11,
                    height: 14 / 11,
                    fontWeight: FontWeight.w400,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
