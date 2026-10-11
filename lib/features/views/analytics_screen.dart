import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/sems_models.dart';
import '../../data/repositories/sems_repository.dart';
import '../../shared/widgets/sems_widgets.dart';
import 'device_detail_screen.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key, required this.repository});
  final SemsRepository repository;
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String range = 'Hour';
  String selectedAppliance = 'All appliances';
  int? selectedBar;

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
    final devices = selectedAppliance == 'All appliances'
        ? widget.repository.devices
        : widget.repository.devices
              .where((d) => d.appliance == selectedAppliance)
              .toList();
    final readings = _visibleReadings;
    final totalKwh = readings.fold<double>(0, (sum, item) => sum + item.kwh);
    final peakKwh = readings.fold<double>(
      0,
      (peak, item) => item.kwh > peak ? item.kwh : peak,
    );
    final inspected = selectedBar != null && selectedBar! < readings.length
        ? readings[selectedBar!]
        : null;
    if (widget.repository.devices.isEmpty) {
      return SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: PageHeading(
                title: 'History',
                subtitle: 'Measured on your socket',
                action: IconButton(
                  tooltip: 'Export data',
                  onPressed: _export,
                  icon: const Icon(Icons.file_download_outlined),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bar_chart_rounded, size: 54),
                      SizedBox(height: 18),
                      Text(
                        'No history yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Usage appears here after your first socket starts reporting.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: SemsColors.muted),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          PageHeading(
            title: 'History',
            subtitle: 'Measured on your socket',
            action: IconButton(
              tooltip: 'Export data',
              onPressed: _export,
              icon: const Icon(Icons.file_download_outlined),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final appliance in {
                  'All appliances',
                  ...widget.repository.devices.map((d) => d.appliance),
                })
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(appliance),
                      selected: selectedAppliance == appliance,
                      onSelected: (_) =>
                          setState(() => selectedAppliance = appliance),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final item in [
                        '10 s',
                        '1 min',
                        'Hour',
                        'Day',
                        'Week',
                        'Month',
                      ])
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: ChoiceChip(
                            label: Text(item),
                            selected: range == item,
                            onSelected: (_) => setState(() {
                              range = item;
                              selectedBar = null;
                            }),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    inspected == null
                        ? 'Touch the chart to inspect · Example data'
                        : '${inspected.label} · ${inspected.kwh.toStringAsFixed(2)} kWh',
                    style: TextStyle(color: SemsColors.muted, fontSize: 11),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 150,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 28,
                        height: 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              peakKwh.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 9,
                                color: SemsColors.muted,
                              ),
                            ),
                            Text(
                              (peakKwh / 2).toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 9,
                                color: SemsColors.muted,
                              ),
                            ),
                            const Text(
                              '0.0',
                              style: TextStyle(
                                fontSize: 9,
                                color: SemsColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: _HistoryBars(
                          values: readings.map((item) => item.kwh).toList(),
                          maxValue: peakKwh,
                          selectedIndex: selectedBar,
                          onSelected: (index) =>
                              setState(() => selectedBar = index),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final index in [
                      0,
                      readings.length ~/ 4,
                      readings.length ~/ 2,
                      readings.length * 3 ~/ 4,
                      readings.isEmpty ? 0 : readings.length - 1,
                    ])
                      Text(
                        readings.isEmpty
                            ? ''
                            : readings[index.clamp(0, readings.length - 1)]
                                  .label,
                        style: const TextStyle(
                          color: SemsColors.muted,
                          fontSize: 9,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  switch (range) {
                    '10 s' => 'Recent readings, energy every 10 seconds',
                    '1 min' => 'Recent readings, energy per minute',
                    'Hour' => 'Last 24 hours, energy per hour',
                    'Day' => 'Recent days, energy per day',
                    'Week' => 'Last 7 days, energy per day',
                    _ => 'Recent weeks, energy per week',
                  },
                  style: const TextStyle(color: SemsColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _HistoryMetric(
                  title: 'Energy',
                  value: totalKwh.toStringAsFixed(1),
                  unit: 'kWh',
                  foot: 'Measured locally',
                  icon: Icons.bolt_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _HistoryMetric(
                  title: 'Cost',
                  value: '₹${(totalKwh * 7.6).toStringAsFixed(0)}',
                  unit: 'Estimated',
                  foot: 'At sample tariff',
                  icon: Icons.currency_rupee_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _HistoryMetric(
                  title: 'Runtime',
                  value:
                      '${(totalKwh / 2).floor()} h ${((totalKwh * 30).round() % 60)} min',
                  unit: '',
                  foot: 'Across sockets',
                  icon: Icons.timer_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Local data coverage',
                        style: TextStyle(color: SemsColors.muted, fontSize: 12),
                      ),
                    ),
                    Text(
                      '${(widget.repository.coverageDays / 45 * 100).clamp(0, 100).round()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (widget.repository.coverageDays / 45).clamp(0, 1),
                  minHeight: 5,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.repository.coverageDays} days of local history available. Cost and runtime are estimates.',
                  style: TextStyle(color: SemsColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const SectionTitle('SESSIONS'),
          const SizedBox(height: 8),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < devices.length; i++)
                  _SessionRow(
                    device: devices[i],
                    isLast: i == devices.length - 1,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => DeviceDetailScreen(
                          device: devices[i],
                          repository: widget.repository,
                          onChanged: () => setState(() {}),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Session kWh = meter at end minus meter at start. It is not the socket’s lifetime reading.',
            style: TextStyle(color: SemsColors.muted, fontSize: 10),
          ),
          const SizedBox(height: 14),
          const AppCard(
            child: Text(
              'This preview uses local example data. Cost and runtime are estimates; no cloud export or monitoring service is connected.',
              style: TextStyle(color: SemsColors.muted, fontSize: 12),
            ),
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
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Exports the chart above: $selectedAppliance, $range.',
                    style: const TextStyle(color: SemsColors.muted),
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
                  title: Text(format),
                  subtitle: Text(switch (format) {
                    'CSV' => 'Plain spreadsheet file',
                    'Excel-compatible CSV' => 'Spreadsheet-compatible text',
                    'JSON' => 'For developers and backups',
                    _ => 'Printable summary report',
                  }),
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

class _HistoryMetric extends StatelessWidget {
  const _HistoryMetric({
    required this.title,
    required this.value,
    required this.unit,
    required this.foot,
    required this.icon,
  });
  final String title, value, unit, foot;
  final IconData icon;
  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.all(9),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: SemsColors.muted, fontSize: 10),
        ),
        const SizedBox(height: 3),
        FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ),
        if (unit.isNotEmpty)
          Text(
            unit,
            style: const TextStyle(fontSize: 9, color: SemsColors.muted),
          ),
        const SizedBox(height: 4),
        Text(
          foot,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 9,
            color: title == 'Energy' ? SemsColors.amber : SemsColors.muted,
          ),
        ),
      ],
    ),
  );
}

class _HistoryBars extends StatelessWidget {
  const _HistoryBars({
    required this.values,
    required this.maxValue,
    required this.selectedIndex,
    required this.onSelected,
  });
  final List<double> values;
  final double maxValue;
  final int? selectedIndex;
  final ValueChanged<int> onSelected;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 130,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < values.length; i++)
          Expanded(
            child: InkWell(
              key: ValueKey('history-bar-$i'),
              onTap: () => onSelected(i),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: FractionallySizedBox(
                  heightFactor: maxValue <= 0
                      ? .08
                      : (values[i] / maxValue).clamp(.08, 1),
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedIndex == i
                          ? SemsColors.forest
                          : SemsColors.green,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({
    required this.device,
    required this.isLast,
    required this.onTap,
  });
  final SemsDevice device;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ListTile(
        onTap: onTap,
        leading: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: SemsColors.mint,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(
            Icons.bolt_rounded,
            color: SemsColors.forest,
            size: 19,
          ),
        ),
        title: Row(
          children: [
            Text(
              device.appliance,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(width: 7),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: SemsColors.mint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Open',
                style: TextStyle(color: SemsColors.forest, fontSize: 9),
              ),
            ),
          ],
        ),
        subtitle: Text(
          '${device.id} · ${device.room}',
          style: const TextStyle(color: SemsColors.muted, fontSize: 10),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${device.todayKwh} kWh',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
            Text(
              'Est. ₹${(device.todayKwh * 8).round()}',
              style: const TextStyle(color: SemsColors.muted, fontSize: 10),
            ),
          ],
        ),
      ),
      if (!isLast) const Divider(height: 1, indent: 56),
    ],
  );
}
