// Implements Figma frames: Dashboard, empty, learning, and alert states.
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/sems_models.dart';
import '../../data/repositories/sems_repository.dart';
import '../../shared/widgets/sems_widgets.dart';
import 'analytics_screen.dart';
import 'alerts_screen.dart';
import 'control_screen.dart';
import 'device_detail_screen.dart';
import 'insights_screen.dart';
import 'more_screens.dart';
import 'more_home_screen.dart';
import 'device_pairing_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.repository});
  final SemsRepository repository;
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedRoom = 'All';

  @override
  Widget build(BuildContext context) {
    final devices = widget.repository.devices;
    final visible = selectedRoom == 'All'
        ? devices
        : devices.where((device) => device.room == selectedRoom).toList();
    final activeWatts = devices
        .where((d) => d.isOn)
        .fold<int>(0, (sum, d) => sum + d.watts);
    final online = devices.where((d) => d.online).length;
    if (devices.isEmpty) return _buildEmptyDashboard(context);
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 22),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good evening, Asha',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Sunday, 11 October',
                            style: TextStyle(
                              fontSize: 12,
                              color: SemsColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Settings',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const SettingsScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.tune_rounded),
                    ),
                    const _OwnerBadge(),
                  ],
                ),
                const SizedBox(height: 8),
                if (online < devices.length)
                  _OfflineBanner(
                    count: devices.length - online,
                    onTap: () => _go(
                      context,
                      AlertsScreen(repository: widget.repository),
                    ),
                  ),
                const SizedBox(height: 12),
                AppCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                            color: SemsColors.green,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Total power now',
                              style: TextStyle(
                                color: SemsColors.muted,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Text(
                            'Updated 4 s ago',
                            style: TextStyle(
                              color: SemsColors.muted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            activeWatts == 0 ? '0' : activeWatts.toString(),
                            style: const TextStyle(
                              fontSize: 40,
                              height: 1.1,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'W',
                            style: TextStyle(
                              color: SemsColors.muted,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const _LoadCurve(),
                      const SizedBox(height: 4),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '00',
                            style: TextStyle(
                              color: SemsColors.muted,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            '06',
                            style: TextStyle(
                              color: SemsColors.muted,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            '12',
                            style: TextStyle(
                              color: SemsColors.muted,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            '18',
                            style: TextStyle(
                              color: SemsColors.muted,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            '24',
                            style: TextStyle(
                              color: SemsColors.muted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _CompactMetric(
                        title: 'Today',
                        value: '4.9',
                        unit: 'kWh',
                        note: '↑ 8% vs avg',
                        onTap: () => _go(
                          context,
                          AnalyticsScreen(repository: widget.repository),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _CompactMetric(
                        title: 'This period',
                        value: '168',
                        unit: 'kWh',
                        note: 'Billing period',
                        onTap: () => _go(
                          context,
                          AnalyticsScreen(repository: widget.repository),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _CompactMetric(
                        title: 'Bill so far',
                        value: '₹1,292',
                        unit: 'Est.',
                        note: 'Estimated',
                        onTap: () => _go(context, const BillsScreen()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SectionTitle(
                  'AI INSIGHTS',
                  trailing: 'Details',
                  onTap: () => _go(
                    context,
                    InsightsScreen(repository: widget.repository),
                  ),
                ),
                const SizedBox(height: 8),
                if (widget.repository.coverageDays < 7)
                  _LearningInsightCard(
                    days: widget.repository.coverageDays,
                    recommendedDays: 7,
                  )
                else ...[
                  _InsightCard(
                    icon: Icons.show_chart_rounded,
                    tag: 'HIGH',
                    color: SemsColors.red,
                    title: 'Heater is 47% above normal',
                    subtitle: 'Current 2,200 W, usual 1,500 W',
                    button: 'Check appliance',
                    onTap: () => _go(
                      context,
                      AppliancesScreen(repository: widget.repository),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _InsightCard(
                    icon: Icons.savings_outlined,
                    tag: 'Estimated',
                    color: const Color(0xFF7955D9),
                    title: 'Reduce heater usage 1 hr/day',
                    subtitle: 'Save ₹20/day · ₹600/month',
                    button: 'View suggestion',
                    onTap: () => _go(
                      context,
                      InsightsScreen(repository: widget.repository),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _InsightCard(
                    icon: Icons.trending_up_rounded,
                    tag: 'Estimated',
                    color: SemsColors.forest,
                    title: 'Estimated this month 248 kWh',
                    subtitle: '₹2,480 estimated cost · range 231 to 266 kWh',
                    button: 'View forecast',
                    onTap: () => _go(
                      context,
                      InsightsScreen(repository: widget.repository),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                SectionTitle(
                  'APPLIANCES',
                  trailing: 'Add appliance',
                  onTap: () => _go(
                    context,
                    AppliancesScreen(repository: widget.repository),
                  ),
                ),
                const SizedBox(height: 7),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final room in [
                        'All',
                        'Living room',
                        'Bedroom',
                        'Kitchen',
                      ])
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Text(room),
                            selected: selectedRoom == room,
                            onSelected: (_) =>
                                setState(() => selectedRoom = room),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                for (final device in visible)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _ApplianceTile(
                      device: device,
                      onTap: () => _go(
                        context,
                        DeviceDetailScreen(
                          device: device,
                          repository: widget.repository,
                          onChanged: () => setState(() {}),
                        ),
                      ),
                      onPower: () => _go(
                        context,
                        ControlScreen(
                          device: device,
                          repository: widget.repository,
                          onChanged: () => setState(() {}),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                const SectionTitle('OVERVIEW'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _CompactMetric(
                        title: 'Peak load today',
                        value: '1,890 W',
                        unit: 'at 19:42',
                        note: 'Measured',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _CompactMetric(
                        title: 'Sockets online',
                        value: '$online of ${devices.length}',
                        unit: '',
                        note: 'Connection status',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AppCard(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: Color(0xFF7955D9),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI SAVING TIP',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                                color: SemsColors.muted,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Start the heater schedule 30 minutes later. Forecast saving is about 6 kWh a week.',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => _go(
                          context,
                          InsightsScreen(repository: widget.repository),
                        ),
                        child: const Text('See insights'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const AppCard(
                  child: Row(
                    children: [
                      Icon(
                        Icons.cloud_done_outlined,
                        color: SemsColors.forest,
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Last sync 2 hr ago',
                          style: TextStyle(
                            color: SemsColors.muted,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Text(
                        '14 pending',
                        style: TextStyle(
                          color: SemsColors.forest,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDashboard(BuildContext context) => SafeArea(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 16, 12),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good evening, Asha',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Sunday, 11 October',
                      style: TextStyle(color: SemsColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Settings',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsScreen(),
                  ),
                ),
                icon: const Icon(Icons.tune_rounded),
              ),
              const _OwnerBadge(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
          child: AppCard(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 48),
            child: Column(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    color: SemsColors.mint,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    AppAssets.splashSocket,
                    width: 32,
                    height: 32,
                    colorFilter: const ColorFilter.mode(
                      SemsColors.forest,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'No sockets yet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Add your first SEMS socket to start measuring and controlling an appliance.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: SemsColors.muted,
                    fontSize: 14,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: _openSetup,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add socket'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  void _openSetup() => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => DevicePairingScreen(
        repository: widget.repository,
        onAdded: () => setState(() {}),
      ),
    ),
  );

  void _go(BuildContext context, Widget page) =>
      Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
}

class _OwnerBadge extends StatelessWidget {
  const _OwnerBadge();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: SemsColors.mint,
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Text(
      'Owner',
      style: TextStyle(
        color: SemsColors.forest,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner({required this.count, required this.onTap});
  final int count;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFECEEF0),
        border: Border.all(color: const Color(0xFF7A8594)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.wifi_off_rounded, color: SemsColors.muted, size: 19),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count of 3 sockets offline',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Their last known values are greyed out below.',
                  style: TextStyle(color: SemsColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _LoadCurve extends StatelessWidget {
  const _LoadCurve();
  static const heights = [
    6,
    6,
    6,
    6,
    6,
    16,
    16,
    22,
    22,
    22,
    14,
    14,
    14,
    14,
    14,
    14,
    14,
    24,
    40,
    40,
    40,
    40,
    16,
    16,
  ];
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 42,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < heights.length; i++)
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 3),
              height: heights[i].toDouble(),
              decoration: BoxDecoration(
                color: i < 18 ? SemsColors.forest : SemsColors.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
      ],
    ),
  );
}

class _CompactMetric extends StatelessWidget {
  const _CompactMetric({
    required this.title,
    required this.value,
    required this.unit,
    required this.note,
    this.onTap,
  });
  final String title, value, unit, note;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: AppCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: SemsColors.muted, fontSize: 10),
          ),
          const SizedBox(height: 5),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (unit.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: Text(
                      unit,
                      style: const TextStyle(
                        fontSize: 10,
                        color: SemsColors.muted,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            note,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: SemsColors.muted, fontSize: 9),
          ),
        ],
      ),
    ),
  );
}

class _LearningInsightCard extends StatelessWidget {
  const _LearningInsightCard({
    required this.days,
    required this.recommendedDays,
  });

  final int days;
  final int recommendedDays;

  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              color: Color(0xFF7955D9),
              size: 16,
            ),
            const SizedBox(width: 8),
            const Text(
              'Learning',
              style: TextStyle(color: SemsColors.muted, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Learning your usage pattern',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 7),
        Text(
          '${recommendedDays - days} more days of data recommended',
          style: const TextStyle(color: SemsColors.muted, fontSize: 12),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: (days / recommendedDays).clamp(0, 1),
            minHeight: 5,
            backgroundColor: SemsColors.line,
            color: const Color(0xFF7955D9),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$days of $recommendedDays days',
          style: const TextStyle(color: SemsColors.muted, fontSize: 10),
        ),
      ],
    ),
  );
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.icon,
    required this.tag,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.button,
    required this.onTap,
  });
  final IconData icon;
  final String tag, title, subtitle, button;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.all(12),
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
          child: Icon(icon, size: 17, color: color),
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
                      title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 9,
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 10, color: SemsColors.muted),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: onTap,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(button, style: const TextStyle(fontSize: 10)),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ApplianceTile extends StatelessWidget {
  const _ApplianceTile({
    required this.device,
    required this.onTap,
    required this.onPower,
  });
  final SemsDevice device;
  final VoidCallback onTap, onPower;
  @override
  Widget build(BuildContext context) {
    final duration = MediaQuery.of(context).disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 240);
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Row(
        children: [
          InkWell(
            onTap: onTap,
            child: Row(
              children: [
                AnimatedContainer(
                  duration: duration,
                  curve: Curves.easeInOutCubic,
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: device.online
                        ? SemsColors.mint
                        : const Color(0xFFECEEF0),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(
                    _icon(device.appliance),
                    size: 18,
                    color: device.online ? SemsColors.forest : SemsColors.muted,
                  ),
                ),
                const SizedBox(width: 9),
                SizedBox(
                  width: 92,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.appliance,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        device.room,
                        style: const TextStyle(
                          fontSize: 10,
                          color: SemsColors.muted,
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: duration,
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, .15),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                        child: Text(
                          device.online
                              ? '● Online  ● ${device.isOn ? 'ON' : 'OFF'}'
                              : '● Offline',
                          key: ValueKey('${device.online}_${device.isOn}'),
                          style: TextStyle(
                            fontSize: 9,
                            color: device.online
                                ? SemsColors.green
                                : SemsColors.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          AnimatedSwitcher(
            duration: duration,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            ),
            child: Text(
              device.online ? '${device.watts} W' : '—',
              key: ValueKey('${device.online}_${device.watts}'),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            onPressed: onPower,
            tooltip: 'Control ${device.appliance}',
            icon: AnimatedSwitcher(
              duration: duration,
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: Icon(
                device.isOn ? Icons.power_settings_new : Icons.power,
                key: ValueKey(device.isOn),
                size: 19,
                color: device.isOn ? SemsColors.forest : SemsColors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static IconData _icon(String name) => name.toLowerCase().contains('fan')
      ? Icons.toys_outlined
      : name.toLowerCase().contains('fridge')
      ? Icons.kitchen_outlined
      : name.toLowerCase().contains('heater')
      ? Icons.local_fire_department_outlined
      : Icons.power_rounded;
}
