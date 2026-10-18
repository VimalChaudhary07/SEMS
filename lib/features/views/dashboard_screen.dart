// Implements Figma screen: Dashboard (node 13:401).
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_assets.dart';
import '../../core/session/demo_session.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text.dart';
import '../../data/mock/mock_dashboard_data.dart';
import '../../data/models/dashboard_models.dart';
import '../../data/models/sems_models.dart';
import '../../data/repositories/sems_repository.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/app_progress_bar.dart';
import '../../shared/widgets/component_theme.dart';
import '../../shared/widgets/role_badge.dart';
import 'add_appliance_screen.dart';
import 'alerts_screen.dart';
import 'analytics_screen.dart';
import 'backup_restore_screen.dart';
import 'control_screen.dart';
import 'device_detail_screen.dart';
import 'device_pairing_screen.dart';
import 'insights_screen.dart';
import 'more_screens.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.repository});
  final SemsRepository repository;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedRoom = 'All';
  final _numberFormat = NumberFormat('#,###');

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final devices = widget.repository.devices;
    final visible = selectedRoom == 'All'
        ? devices
        : devices.where((device) => device.room == selectedRoom).toList();
    final activeWatts = devices
        .where((d) => d.isOn && d.online)
        .fold<int>(0, (sum, d) => sum + d.watts);
    final online = devices.where((d) => d.online).length;
    final offlineCount = devices.length - online;

    if (devices.isEmpty) return _buildEmptyDashboard(context);

    const overview = MockDashboardData.overview;
    const insights = MockDashboardData.insights;
    const savingTip = MockDashboardData.savingTip;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _TopBar(
                  userName: 'Asha',
                  dateText: 'Sunday, 11 October',
                  onSettings: () => _go(context, const SettingsScreen()),
                ),
                const SizedBox(height: 8),
                if (offlineCount > 0) ...[
                  _OfflineBanner(
                    count: offlineCount,
                    total: devices.length,
                    onTap: () => _go(
                      context,
                      AlertsScreen(repository: widget.repository),
                    ),
                  ),
                  const SizedBox(height: 16),
                ] else
                  const SizedBox(height: 8),
                _TotalPowerCard(
                  wattsFormatted: _numberFormat.format(
                    activeWatts == 0 ? 2255 : activeWatts,
                  ),
                ),
                const SizedBox(height: 16),
                _ThreeMetricsRow(
                  todayKwh: '4.9',
                  periodKwh: '168',
                  billInr: '1,292',
                  onTodayTap: () => _go(
                    context,
                    AnalyticsScreen(repository: widget.repository),
                  ),
                  onPeriodTap: () => _go(
                    context,
                    AnalyticsScreen(repository: widget.repository),
                  ),
                  onBillTap: () => _go(
                    context,
                    BillsScreen(repository: widget.repository),
                  ),
                ),
                const SizedBox(height: 16),
                _SectionHeader(
                  title: 'AI INSIGHTS',
                  actionText: 'Details',
                  onAction: () => _go(
                    context,
                    InsightsScreen(repository: widget.repository),
                  ),
                ),
                const SizedBox(height: 10),
                if (widget.repository.coverageDays < 7)
                  _LearningInsightCard(
                    days: widget.repository.coverageDays,
                    recommendedDays: 7,
                  )
                else ...[
                  for (var i = 0; i < insights.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _AiInsightCard(
                        insight: insights[i],
                        onTap: () {
                          if (insights[i].isAnomaly) {
                            final heater = devices.firstWhere(
                              (d) => d.appliance.toLowerCase().contains('heater'),
                              orElse: () => devices.first,
                            );
                            _go(
                              context,
                              DeviceDetailScreen(
                                device: heater,
                                repository: widget.repository,
                                onChanged: () => setState(() {}),
                              ),
                            );
                          } else {
                            _go(
                              context,
                              InsightsScreen(repository: widget.repository),
                            );
                          }
                        },
                      ),
                    ),
                ],
                const SizedBox(height: 6),
                _SectionHeader(
                  title: 'APPLIANCES',
                  actionText: 'Add appliance',
                  onAction: () => _go(
                    context,
                    AddApplianceScreen(repository: widget.repository),
                  ),
                ),
                const SizedBox(height: 10),
                _RoomChips(
                  selectedRoom: selectedRoom,
                  onRoomSelected: (room) => setState(() => selectedRoom = room),
                ),
                const SizedBox(height: 10),
                for (final device in visible)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ApplianceCard(
                      device: device,
                      wattsFormatted: _numberFormat.format(device.watts),
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
                const SizedBox(height: 6),
                const _SectionHeader(title: 'OVERVIEW'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _OverviewMetricCard(
                        title: 'Peak load today',
                        value: '${_numberFormat.format(overview.peakWatts)} W',
                        subtext: overview.peakTime,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _OverviewMetricCard(
                        title: 'Sockets online',
                        value: '$online of ${devices.length}',
                        valueColor: colors.statusWarning,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _AiSavingTipCard(
                  tip: savingTip,
                  onTap: () => _go(
                    context,
                    InsightsScreen(repository: widget.repository),
                  ),
                ),
                const SizedBox(height: 10),
                _DriveSyncCard(
                  lastSyncText: overview.lastSyncText,
                  pendingCount: overview.pendingSyncCount,
                  onTap: () => _go(
                    context,
                    const BackupRestoreScreen(),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDashboard(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: _TopBar(
              userName: 'Asha',
              dateText: 'Sunday, 11 October',
              onSettings: () => _go(context, const SettingsScreen()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 0),
            child: AppCard(
              padding: const EdgeInsets.fromLTRB(32, 48, 32, 48),
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: colors.raised,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AppAssets.splashSocket,
                      width: 34,
                      height: 34,
                      colorFilter: ColorFilter.mode(
                        colors.brandPrimary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'No sockets yet',
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Add your first SEMS socket to start measuring and controlling an appliance.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 14,
                      height: 20 / 14,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  AppButton(
                    label: 'Add socket',
                    leadingIcon: Icons.add_rounded,
                    onPressed: _openSetup,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.userName,
    required this.dateText,
    required this.onSettings,
  });

  final String userName;
  final String dateText;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
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
                  'Good evening, $userName',
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
                  dateText,
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
          Tooltip(
            message: 'Settings',
            child: InkWell(
              onTap: onSettings,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppAssets.iconSliders,
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
          RoleBadge(isFamily: DemoSession.isMember, showIcon: false),
        ],
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner({
    required this.count,
    required this.total,
    required this.onTap,
  });

  final int count;
  final int total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.statusOfflineTint ?? const Color(0xFFECEEF0),
          border: Border.all(
            color: colors.statusOffline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.iconWifiOff,
              width: 19,
              height: 19,
              colorFilter: ColorFilter.mode(
                colors.statusOffline,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count of $total sockets offline',
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 13,
                      height: 20 / 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Their last known values are greyed out below.',
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
          ],
        ),
      ),
    );
  }
}

class _TotalPowerCard extends StatelessWidget {
  const _TotalPowerCard({required this.wattsFormatted});
  final String wattsFormatted;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return Container(
      padding: const EdgeInsets.all(16),
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
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: colors.statusOk,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Total power now',
                style: TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 13,
                  height: 18 / 13,
                  fontWeight: FontWeight.w500,
                  color: colors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                'Updated 4 s ago',
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
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                wattsFormatted,
                style: TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 40,
                  height: 44 / 40,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'W',
                style: TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 16,
                  height: 24 / 16,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const _LoadCurve(),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in ['00', '06', '12', '18', '24'])
                Text(
                  label,
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
    );
  }
}

class _LoadCurve extends StatelessWidget {
  const _LoadCurve();

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final heights = MockDashboardData.loadCurveHeights;
    return SizedBox(
      height: 44,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < heights.length; i++)
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < heights.length - 1 ? 3 : 0),
                height: heights[i],
                decoration: BoxDecoration(
                  color: i < 18 ? colors.brandPrimary : colors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ThreeMetricsRow extends StatelessWidget {
  const _ThreeMetricsRow({
    required this.todayKwh,
    required this.periodKwh,
    required this.billInr,
    required this.onTodayTap,
    required this.onPeriodTap,
    required this.onBillTap,
  });

  final String todayKwh;
  final String periodKwh;
  final String billInr;
  final VoidCallback onTodayTap;
  final VoidCallback onPeriodTap;
  final VoidCallback onBillTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _CompactMetricCard(
            title: 'Today',
            value: todayKwh,
            unit: 'kWh',
            note: 'Measured',
            onTap: onTodayTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _CompactMetricCard(
            title: 'This period',
            value: periodKwh,
            unit: 'kWh',
            note: 'Billing period',
            onTap: onPeriodTap,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _CompactMetricCard(
            title: 'Bill so far',
            value: '₹$billInr',
            unit: '',
            note: 'Estimated',
            isEstimatedDashed: true,
            hasSparkleIcon: true,
            onTap: onBillTap,
          ),
        ),
      ],
    );
  }
}

class _CompactMetricCard extends StatelessWidget {
  const _CompactMetricCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.note,
    this.isEstimatedDashed = false,
    this.hasSparkleIcon = false,
    required this.onTap,
  });

  final String title;
  final String value;
  final String unit;
  final String note;
  final bool isEstimatedDashed;
  final bool hasSparkleIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final content = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: isEstimatedDashed ? null : Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (hasSparkleIcon) ...[
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
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 12,
                    height: 16 / 12,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 20,
                    height: 24 / 20,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                if (unit.isNotEmpty) ...[
                  const SizedBox(width: 3),
                  Text(
                    unit,
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 11,
                      height: 14 / 11,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            note,
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
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.card),
      child: isEstimatedDashed
          ? DashedOutline(
              color: colors.textSecondary,
              radius: AppRadii.card,
              child: content,
            )
          : content,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.actionText,
    this.onAction,
  });

  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: AppText.family,
            fontSize: 13,
            height: 18 / 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.06 * 13,
            color: colors.textSecondary,
          ),
        ),
        const Spacer(),
        if (actionText != null)
          InkWell(
            onTap: onAction,
            child: Text(
              actionText!,
              style: TextStyle(
                fontFamily: AppText.family,
                fontSize: 13,
                height: 18 / 13,
                fontWeight: FontWeight.w600,
                color: colors.brandPrimary,
              ),
            ),
          ),
      ],
    );
  }
}

class _AiInsightCard extends StatelessWidget {
  const _AiInsightCard({
    required this.insight,
    required this.onTap,
  });

  final DashboardAiInsight insight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final iconBg = insight.isAnomaly
        ? colors.statusFaultTint ?? const Color(0xFFFBE6E6)
        : colors.statusAiTint ?? const Color(0xFFECE6FB);
    final iconColor = insight.isAnomaly
        ? colors.statusFault
        : colors.statusAi;

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: colors.border),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (insight.isAnomaly)
              Container(width: 4, color: colors.statusFault),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: iconBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            insight.iconAsset,
                            width: 15,
                            height: 15,
                            colorFilter: ColorFilter.mode(
                              iconColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            insight.categoryTitle,
                            maxLines: 2,
                            style: TextStyle(
                              fontFamily: AppText.family,
                              fontSize: 12,
                              height: 16 / 12,
                              fontWeight: FontWeight.w600,
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (insight.isAnomaly) ...[
                          _PillBadge(
                            text: 'HIGH',
                            iconAsset: AppAssets.iconAlert,
                            textColor: colors.statusFault,
                            bgColor: colors.statusFaultTint ?? const Color(0xFFFBE6E6),
                          ),
                          const SizedBox(width: 6),
                        ],
                        if (insight.badge2Text != null || !insight.isAnomaly)
                          _PillBadge(
                            text: insight.badge2Text ?? insight.badge1Text,
                            iconAsset: AppAssets.iconSparkle,
                            textColor: colors.statusAi,
                            bgColor: colors.statusAiTint ?? const Color(0xFFECE6FB),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      insight.mainTitle,
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 15,
                        height: 20 / 15,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      insight.subtitle1,
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 13,
                        height: 18 / 13,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                      ),
                    ),
                    if (insight.subtitle2 != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        insight.subtitle2!,
                        style: TextStyle(
                          fontFamily: AppText.family,
                          fontSize: 12,
                          height: 18 / 12,
                          fontWeight: FontWeight.w400,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                    if (insight.actionButtonText != null) ...[
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: onTap,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: colors.raised,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            insight.actionButtonText!,
                            style: TextStyle(
                              fontFamily: AppText.family,
                              fontSize: 13,
                              height: 18 / 13,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PillBadge extends StatelessWidget {
  const _PillBadge({
    required this.text,
    this.iconAsset,
    required this.textColor,
    required this.bgColor,
  });

  final String text;
  final String? iconAsset;
  final Color textColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconAsset != null) ...[
            SvgPicture.asset(
              iconAsset!,
              width: 12,
              height: 12,
              colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomChips extends StatelessWidget {
  const _RoomChips({
    required this.selectedRoom,
    required this.onRoomSelected,
  });

  final String selectedRoom;
  final ValueChanged<String> onRoomSelected;

  static const rooms = ['All', 'Living room', 'Bedroom', 'Kitchen'];

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final room in rooms)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => onRoomSelected(room),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: selectedRoom == room
                        ? colors.brandPrimary
                        : colors.card,
                    border: Border.all(
                      color: selectedRoom == room
                          ? colors.brandPrimary
                          : colors.border,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    room,
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 13,
                      height: 18 / 13,
                      fontWeight: FontWeight.w500,
                      color: selectedRoom == room
                          ? Colors.white
                          : colors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ApplianceCard extends StatelessWidget {
  const _ApplianceCard({
    required this.device,
    required this.wattsFormatted,
    required this.onTap,
    required this.onPower,
  });

  final SemsDevice device;
  final String wattsFormatted;
  final VoidCallback onTap;
  final VoidCallback onPower;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final isOnline = device.online;
    final isHeater = device.appliance.toLowerCase().contains('heater');
    final isFan = device.appliance.toLowerCase().contains('fan');
    final iconAsset = isHeater
        ? AppAssets.iconFlame
        : isFan
            ? AppAssets.iconFan
            : AppAssets.iconFridge;

    final iconBg = isOnline
        ? colors.brandTint
        : (colors.statusOfflineTint ?? const Color(0xFFECEEF0));
    final iconColor = isOnline ? colors.brandPrimary : colors.statusOffline;

    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: colors.border),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppRadii.card),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        iconAsset,
                        width: 22,
                        height: 22,
                        colorFilter: ColorFilter.mode(
                          iconColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            device.appliance,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppText.family,
                              fontSize: 15,
                              height: 20 / 15,
                              fontWeight: FontWeight.w600,
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            device.room,
                            style: TextStyle(
                              fontFamily: AppText.family,
                              fontSize: 12,
                              height: 16 / 12,
                              fontWeight: FontWeight.w400,
                              color: colors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (isOnline) ...[
                                _StatusPill(
                                  iconAsset: AppAssets.iconWifi,
                                  text: 'Online',
                                  color: colors.brandPrimary,
                                  bgColor: colors.brandTint,
                                ),
                                const SizedBox(width: 6),
                                _StatusPill(
                                  iconAsset: AppAssets.iconPower,
                                  text: device.isOn ? 'ON' : 'OFF',
                                  color: colors.brandPrimary,
                                  bgColor: colors.brandTint,
                                ),
                              ] else
                                _StatusPill(
                                  iconAsset: AppAssets.iconWifiOff,
                                  text: 'Offline',
                                  color: colors.statusOffline,
                                  bgColor: colors.statusOfflineTint ??
                                      const Color(0xFFECEEF0),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isOnline ? '$wattsFormatted W' : '—',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 19,
                            height: 26 / 19,
                            fontWeight: FontWeight.w600,
                            color: isOnline
                                ? colors.textPrimary
                                : colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isOnline
                              ? '${device.todayKwh} kWh today'
                              : '${device.lastSeenMinutes > 0 ? device.lastSeenMinutes : 14} min ago',
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
            ),
          ),
          Container(
            width: 1,
            height: 84,
            color: colors.border,
          ),
          InkWell(
            onTap: onPower,
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(AppRadii.card),
            ),
            child: SizedBox(
              width: 56,
              height: 84,
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.iconPower,
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    isOnline && device.isOn
                        ? colors.brandPrimary
                        : colors.brandPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.iconAsset,
    required this.text,
    required this.color,
    required this.bgColor,
  });

  final String iconAsset;
  final String text;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconAsset,
            width: 12,
            height: 12,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewMetricCard extends StatelessWidget {
  const _OverviewMetricCard({
    required this.title,
    required this.value,
    this.subtext,
    this.valueColor,
  });

  final String title;
  final String value;
  final String? subtext;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w500,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 20,
              height: 24 / 20,
              fontWeight: FontWeight.w600,
              color: valueColor ?? colors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtext ?? ' ',
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
    );
  }
}

class _AiSavingTipCard extends StatelessWidget {
  const _AiSavingTipCard({required this.tip, required this.onTap});
  final DashboardSavingTip tip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.card),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(color: colors.border),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.statusAiTint ?? const Color(0xFFECE6FB),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                AppAssets.iconSparkle,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  colors.statusAi,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        tip.category,
                        style: TextStyle(
                          fontFamily: AppText.family,
                          fontSize: 12,
                          height: 16 / 12,
                          fontWeight: FontWeight.w600,
                          color: colors.statusAi,
                          letterSpacing: 0.06 * 12,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        height: 20,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: colors.statusAiTint ?? const Color(0xFFECE6FB),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          tip.badge,
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 12,
                            height: 16 / 12,
                            fontWeight: FontWeight.w500,
                            color: colors.statusAi,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tip.body,
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 14,
                      height: 20 / 14,
                      fontWeight: FontWeight.w400,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tip.actionText,
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 13,
                      height: 18 / 13,
                      fontWeight: FontWeight.w600,
                      color: colors.statusAi,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DriveSyncCard extends StatelessWidget {
  const _DriveSyncCard({
    required this.lastSyncText,
    required this.pendingCount,
    required this.onTap,
  });

  final String lastSyncText;
  final int pendingCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.card),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(color: colors.border),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              AppAssets.iconCloud,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                colors.brandPrimary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Row(
              children: [
                Text(
                  'Last sync',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 13,
                    height: 18 / 13,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  lastSyncText,
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 13,
                    height: 18 / 13,
                    fontWeight: FontWeight.w400,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              height: 24,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: colors.statusPendingTint ?? const Color(0xFFE3ECFD),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppAssets.iconUpload,
                    width: 12,
                    height: 12,
                    colorFilter: ColorFilter.mode(
                      colors.statusPending,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$pendingCount pending',
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 12,
                      height: 16 / 12,
                      fontWeight: FontWeight.w500,
                      color: colors.statusPending,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LearningInsightCard extends StatelessWidget {
  const _LearningInsightCard({
    required this.days,
    required this.recommendedDays,
  });

  final int days;
  final int recommendedDays;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                AppAssets.iconSparkle,
                width: 15,
                height: 15,
                colorFilter: ColorFilter.mode(
                  colors.statusAi,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Learning',
                style: TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 12,
                  height: 16 / 12,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Learning your usage pattern',
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 15,
              height: 20 / 15,
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${recommendedDays - days} more days of data recommended',
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 13,
              height: 18 / 13,
              fontWeight: FontWeight.w400,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          AppProgressBar(
            value: (days / recommendedDays).clamp(0, 1),
            tone: 'ai',
            height: 6,
          ),
          const SizedBox(height: 6),
          Text(
            '$days of $recommendedDays days',
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
    );
  }
}
