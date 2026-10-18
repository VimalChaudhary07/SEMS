import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/sems_models.dart';
import '../../data/repositories/sems_repository.dart';
import '../../shared/widgets/sems_widgets.dart';
import 'settings_detail_screens.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key, required this.repository});
  final SemsRepository repository;
  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  int dataDays = 45;
  @override
  Widget build(BuildContext context) {
    final quality = dataDays >= 30
        ? 'Strong'
        : dataDays >= 10
        ? 'Good'
        : dataDays >= 5
        ? 'Basic'
        : 'Learning';
    final progress = dataDays >= 30 ? 1.0 : dataDays / 30;
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Energy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              'Calculated on this phone',
              style: TextStyle(fontSize: 11, color: SemsColors.muted),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'AI settings',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const AiSettingsScreen()),
            ),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          const AppBanner(
            tone: StatusTone.ai,
            title: 'Estimated, not measured',
            body: 'Calculated privately on this phone from sample readings. No data leaves the device.',
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Data coverage',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    DropdownButton<int>(
                      value: dataDays,
                      underline: const SizedBox.shrink(),
                      items: const [
                        DropdownMenuItem(value: 45, child: Text('45 days')),
                        DropdownMenuItem(value: 10, child: Text('10 days')),
                        DropdownMenuItem(value: 5, child: Text('5 days')),
                        DropdownMenuItem(value: 2, child: Text('2 days')),
                      ],
                      onChanged: (v) =>
                          setState(() => dataDays = v ?? dataDays),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                AppProgressBar(value: progress, tone: 'ai', height: 5),
                const SizedBox(height: 6),
                Text(
                  '$dataDays days · $quality · ${dataDays >= 5 ? 'Enough history for a local estimate.' : 'Learning your usage baseline.'}',
                  style: const TextStyle(color: SemsColors.muted, fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: Color(0xFF7955D9),
                      size: 18,
                    ),
                    SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'Consumption forecast',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    EstimatedBadge(),
                  ],
                ),
                const SizedBox(height: 8),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '248',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'kWh this month',
                      style: TextStyle(color: SemsColors.muted, fontSize: 11),
                    ),
                  ],
                ),
                const Text(
                  '₹2,480 estimated cost · range 231 to 266 kWh',
                  style: TextStyle(color: SemsColors.muted, fontSize: 11),
                ),
                const SizedBox(height: 8),
                SizedBox(height: 74, child: _ForecastChart()),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mon',
                      style: TextStyle(color: SemsColors.muted, fontSize: 9),
                    ),
                    Text(
                      'Wed',
                      style: TextStyle(color: SemsColors.muted, fontSize: 9),
                    ),
                    Text(
                      'Fri',
                      style: TextStyle(color: SemsColors.muted, fontSize: 9),
                    ),
                    Text(
                      'Sun',
                      style: TextStyle(color: SemsColors.muted, fontSize: 9),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Next 7 days, kWh per day. Shaded band is the likely range.',
                  style: TextStyle(color: SemsColors.muted, fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      color: SemsColors.forest,
                      size: 18,
                    ),
                    SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'Peak usage periods',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    EstimatedBadge(),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _PeakPeriod(
                        title: 'Usual peak',
                        time: '19:00–22:00',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _PeakPeriod(title: 'Tomorrow', time: '20:00'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const SectionTitle('INSIGHTS'),
          const SizedBox(height: 8),
          if (dataDays >= 5)
            _InsightTile(
              icon: Icons.show_chart_rounded,
              color: SemsColors.red,
              label: 'Abnormal consumption',
              tag: 'HIGH',
              title: 'Heater is 47% above normal',
              detail: 'Current 2,200 W, usual 1,500 W. Estimated from your personal baseline.',
              onTap: () => _details(
                context,
                'Abnormal consumption',
                'The heater sample reading is 2,200 W. The comparison baseline is 1,500 W. Check the appliance and its schedule.',
              ),
            )
          else
            const _LearningTile(),
          if (widget.repository.recommendations.isNotEmpty)
            _InsightTile(
              icon: Icons.savings_outlined,
              color: const Color(0xFF7955D9),
              label: 'Potential saving',
              tag: 'ESTIMATED',
              title: 'Reduce heater usage 1 hr/day',
              detail: 'Save ₹20/day, or about ₹600 per month.',
              onTap: () => _details(
                context,
                widget.repository.recommendations.first.title,
                widget.repository.recommendations.first.description,
              ),
            ),
          if (dataDays >= 10)
            _InsightTile(
              icon: Icons.local_fire_department_outlined,
              color: SemsColors.amber,
              label: 'Wastage detected',
              tag: 'LOW',
              title: 'Fan ran 9 h while room was likely empty',
              detail: 'Estimated 2.1 kWh wasted this week.',
              onTap: () => _details(
                context,
                'Wastage detected',
                'The sample indicates a fan schedule may run longer than needed. Review its local schedule.',
              ),
            ),
          const SizedBox(height: 8),
          const SectionTitle('APPLIANCE BASELINES'),
          const SizedBox(height: 8),
          for (final device in widget.repository.devices)
            _BaselineTile(device: device, dataDays: dataDays),
          const SizedBox(height: 10),
          const AppCard(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: SemsColors.mint,
                  child: Icon(
                    Icons.currency_rupee_rounded,
                    color: SemsColors.forest,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimated savings available',
                        style: TextStyle(color: SemsColors.muted, fontSize: 11),
                      ),
                      Text(
                        '₹600 per month',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                EstimatedBadge(),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const AppCard(
            child: Text(
              'Illustrative AI design preview. No AI model is running; all predictions and recommendations are sample content.',
              style: TextStyle(
                color: SemsColors.muted,
                fontSize: 11,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _details(BuildContext context, String title, String body) =>
      showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (context) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                Text(
                  body,
                  style: const TextStyle(color: SemsColors.muted, height: 1.5),
                ),
                const SizedBox(height: 18),
                AppButton(
                  onPressed: () => Navigator.pop(context),
                  label: 'Done',
                ),
              ],
            ),
          ),
        ),
      );
}

class _PeakPeriod extends StatelessWidget {
  const _PeakPeriod({required this.title, required this.time});
  final String title, time;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      border: Border.all(color: SemsColors.line),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: SemsColors.muted, fontSize: 10),
        ),
        Text(time, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    ),
  );
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.tag,
    required this.title,
    required this.detail,
    required this.onTap,
  });
  final IconData icon;
  final Color color;
  final String label, tag, title, detail;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: AppCard(
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 10,
                            color: SemsColors.muted,
                          ),
                        ),
                      ),
                      Text(
                        tag,
                        style: TextStyle(
                          fontSize: 9,
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    detail,
                    style: const TextStyle(
                      fontSize: 10,
                      color: SemsColors.muted,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: SemsColors.muted),
          ],
        ),
      ),
    ),
  );
}

class _LearningTile extends StatelessWidget {
  const _LearningTile();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.only(bottom: 8),
    child: AppCard(
      child: Row(
        children: [
          Icon(Icons.hourglass_empty_rounded, color: SemsColors.muted),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Learning your usage baseline',
              style: TextStyle(color: SemsColors.muted, fontSize: 12),
            ),
          ),
        ],
      ),
    ),
  );
}

class _BaselineTile extends StatelessWidget {
  const _BaselineTile({required this.device, required this.dataDays});
  final SemsDevice device;
  final int dataDays;
  @override
  Widget build(BuildContext context) {
    final learned = dataDays >= 10;
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(
              device.appliance.toLowerCase().contains('fan')
                  ? Icons.toys_outlined
                  : device.appliance.toLowerCase().contains('heater')
                  ? Icons.local_fire_department_outlined
                  : Icons.kitchen_outlined,
              color: SemsColors.muted,
              size: 18,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.appliance,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    learned
                        ? 'Normal range estimated from sample readings'
                        : 'Needs more days of sample data',
                    style: const TextStyle(
                      fontSize: 9,
                      color: SemsColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              learned ? '✓ Learned' : 'Learning',
              style: TextStyle(
                fontSize: 9,
                color: learned ? SemsColors.green : SemsColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForecastChart extends StatelessWidget {
  const _ForecastChart();
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _ForecastPainter(), child: const SizedBox.expand());
}

class _ForecastPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = SemsColors.line
      ..strokeWidth = 1;
    for (var i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final points = [.73, .67, .72, .63, .56, .62, .59];
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final point = Offset(
        size.width * i / (points.length - 1),
        size.height * points[i],
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF7955D9)
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
