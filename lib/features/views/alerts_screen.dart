import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/session/demo_session.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/sems_models.dart';
import '../../data/repositories/sems_repository.dart';
import '../../shared/widgets/sems_widgets.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({
    super.key,
    required this.repository,
    this.initialFilter,
    this.bottomNavigationBar,
    this.showTrippedBanner,
    this.showEmptyState = false,
    this.initialDetailAlertId,
    this.showSettingsSheetOnStart = false,
  });
  final SemsRepository repository;
  final String? initialFilter;
  final Widget? bottomNavigationBar;
  final bool? showTrippedBanner;
  final bool showEmptyState;
  final String? initialDetailAlertId;
  final bool showSettingsSheetOnStart;

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  late String selected;
  late Future<AlertPreferences> _preferences;

  @override
  void initState() {
    super.initState();
    selected = widget.initialFilter ?? 'All';
    _preferences = widget.repository.getAlertPreferences();
    if (widget.initialDetailAlertId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final target = widget.repository.alerts.firstWhere(
          (a) => a.id == widget.initialDetailAlertId,
          orElse: () => widget.repository.alerts.first,
        );
        _showDetails(target);
      });
    }
    if (widget.showSettingsSheetOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _settings();
      });
    }
  }

  static const filters = [
    'All',
    'Electrical',
    'Energy',
    'Connectivity',
    'Automation',
    'AI',
  ];

  @override
  Widget build(BuildContext context) {
    final alerts = widget.showEmptyState
        ? const <SemsAlert>[]
        : widget.repository.alerts
            .where(
              (alert) => selected == 'All'
                  ? alert.category != AlertCategory.ai
                  : _filterFor(alert) == selected,
            )
            .toList();
    final newCount = widget.showEmptyState
        ? 0
        : widget.repository.alerts
            .where((a) => !a.acknowledged && a.category != AlertCategory.ai)
            .length;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      bottomNavigationBar: widget.bottomNavigationBar,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F7F6),
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 56,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Alerts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F1714),
                height: 1.2,
              ),
            ),
            Text(
              '$newCount need attention',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF55625D),
                height: 1.33,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Alert settings',
            onPressed: _settings,
            icon: SvgPicture.asset(
              AppAssets.iconSliders,
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                Color(0xFF0F1714),
                BlendMode.srcIn,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: RoleBadge(
              isFamily: DemoSession.isMember,
              showIcon: false,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final filter in filters)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: AppChip(
                      selected: selected == filter,
                      label: filter,
                      height: 36,
                      count: _countFor(filter) > 0 ? _countFor(filter) : null,
                      onSelected: (_) => setState(() => selected = filter),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (selected == 'AI') ...[
            const _AiEstimateBanner(),
            const SizedBox(height: 10),
            const _QuietHoursBanner(),
            const SizedBox(height: 10),
          ],
          if (selected == 'Electrical' && (widget.showTrippedBanner ?? true)) ...[
            const _TrippedBanner(),
            const SizedBox(height: 10),
          ],
          if (selected != 'AI')
            FutureBuilder<AlertPreferences>(
              future: _preferences,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AppCard(
                      child: Text(
                        'Unable to load alert preferences: ${snapshot.error}',
                        style: const TextStyle(color: SemsColors.red, fontSize: 12),
                      ),
                    ),
                  );
                }
                return snapshot.data?.muteNonCriticalAlerts == true
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AppCard(
                          child: Text(
                            'Quiet hours are on (${snapshot.data!.quietHoursStart} to ${snapshot.data!.quietHoursEnd}). Critical safety alerts always come through.',
                            style: const TextStyle(
                              color: SemsColors.muted,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          if (alerts.isEmpty)
            const _AlertsEmptyState(),
          for (final alert in alerts)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _AlertCard(
                alert: alert,
                isAcknowledged: alert.acknowledged,
                onAcknowledge: () => _acknowledge(alert),
                onOpen: () => _showDetails(alert),
              ),
            ),
        ],
      ),
    );
  }

  int _countFor(String filter) {
    if (filter == 'All') {
      return widget.repository.alerts
          .where((alert) => alert.category != AlertCategory.ai)
          .length;
    }
    if (filter == 'AI') {
      return widget.repository.alerts
          .where(
            (alert) =>
                alert.category == AlertCategory.ai && !alert.acknowledged,
          )
          .length;
    }
    return widget.repository.alerts
        .where((alert) => _filterFor(alert) == filter)
        .length;
  }

  static String _filterFor(SemsAlert alert) => switch (alert.category) {
    AlertCategory.electrical => 'Electrical',
    AlertCategory.energy => 'Energy',
    AlertCategory.connectivity => 'Connectivity',
    AlertCategory.schedule => 'Automation',
    AlertCategory.ai => 'AI',
  };

  Future<void> _acknowledge(SemsAlert alert) async {
    try {
      await widget.repository.acknowledgeAlert(alert.id);
      if (mounted) setState(() {});
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not acknowledge alert: $error')),
        );
      }
    }
  }

  Future<void> _showDetails(SemsAlert alert) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x73000000),
    builder: (context) => _AlertDetailSheet(
      alert: alert,
      onAcknowledge: () => _acknowledge(alert),
    ),
  );

  Future<void> _settings() => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x73000000),
    builder: (context) => _AlertSettingsSheet(
      repository: widget.repository,
      onSaved: () {
        setState(() => _preferences = widget.repository.getAlertPreferences());
      },
    ),
  );
}

class _AlertDetailSheet extends StatelessWidget {
  const _AlertDetailSheet({
    required this.alert,
    this.onAcknowledge,
  });

  final SemsAlert alert;
  final VoidCallback? onAcknowledge;

  static String _filterFor(SemsAlert alert) => switch (alert.category) {
        AlertCategory.electrical => 'Electrical',
        AlertCategory.energy => 'Energy',
        AlertCategory.connectivity => 'Connectivity',
        AlertCategory.schedule => 'Automation',
        AlertCategory.ai => 'AI',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 4),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1E9E5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      alert.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F1714),
                        height: 1.33,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      splashRadius: 20,
                      icon: SvgPicture.asset(
                        AppAssets.iconClose,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF55625D),
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (alert.category == AlertCategory.ai) ...[
                      Container(
                        height: 24,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBE6E6),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppAssets.iconAlert,
                              width: 13,
                              height: 13,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFD64545),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              alert.badgeLabel ?? 'HIGH',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFD64545),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 24,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECE6FB),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppAssets.iconSparkle,
                              width: 13,
                              height: 13,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF7E3AF2),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Estimated',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF7E3AF2),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 24,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF1EE),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'AI',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF55625D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      if (alert.severity == AlertSeverity.critical)
                        Container(
                          height: 24,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBE6E6),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                AppAssets.iconAlert,
                                width: 13,
                                height: 13,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFFD64545),
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                alert.badgeLabel ?? 'Critical',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFD64545),
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (alert.severity == AlertSeverity.warning)
                        Container(
                          height: 24,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCF0D9),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                AppAssets.iconAlert,
                                width: 13,
                                height: 13,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFFD98A00),
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                alert.badgeLabel ?? 'Warning',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFD98A00),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Container(
                        height: 24,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF1EE),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _filterFor(alert),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF55625D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  alert.device,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF1EE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Occurred at',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF55625D),
                            ),
                          ),
                          Text(
                            alert.occurredAt ?? alert.time,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F1714),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Received at',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF55625D),
                            ),
                          ),
                          Text(
                            alert.receivedAt ?? alert.time,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F1714),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (alert.seenNote != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    alert.seenNote!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF55625D),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                const Text(
                  'What happened',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F1714),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.whatHappened ?? alert.message,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                    height: 1.43,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'What to do next',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F1714),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.whatToDoNext ??
                      alert.nextAction ??
                      'The socket recovered by itself after 60 s. If it trips again, unplug extra loads from this circuit.',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF0F1714),
                    height: 1.43,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          onAcknowledge?.call();
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0E9F6E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppAssets.iconCheck,
                                width: 18,
                                height: 18,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                alert.acknowledged
                                    ? 'Acknowledged'
                                    : 'Acknowledge',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFE1E9E5)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            alert.secondaryActionLabel ?? 'Open device',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F1714),
                            ),
                          ),
                        ),
                      ),
                    ],
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

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.alert,
    required this.isAcknowledged,
    required this.onAcknowledge,
    required this.onOpen,
  });

  final SemsAlert alert;
  final bool isAcknowledged;
  final VoidCallback onAcknowledge, onOpen;

  @override
  Widget build(BuildContext context) {
    final String label = alert.badgeLabel ??
        switch (alert.severity) {
          AlertSeverity.critical => 'Critical',
          AlertSeverity.warning => 'Warning',
          AlertSeverity.info => 'Info',
        };
    final String badgeIcon =
        (alert.badgeLabel == 'LOW' || alert.severity == AlertSeverity.info)
            ? AppAssets.iconInfo
            : AppAssets.iconAlert;
    final (accentColor, badgeBg, badgeTextColor) = switch (alert.severity) {
      AlertSeverity.critical => (
        const Color(0xFFD64545),
        const Color(0xFFFBE6E6),
        const Color(0xFFD64545),
      ),
      AlertSeverity.warning => (
        const Color(0xFFD98A00),
        const Color(0xFFFCF0D9),
        const Color(0xFFD98A00),
      ),
      AlertSeverity.info => (
        const Color(0xFF2F6FED),
        const Color(0xFFE3ECFD),
        const Color(0xFF2F6FED),
      ),
    };

    final cardContent = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E9E5)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(16, 22, 20, 0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color.fromRGBO(16, 22, 20, 0.05),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              color: accentColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 24,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                badgeIcon,
                                width: 13,
                                height: 13,
                                colorFilter: ColorFilter.mode(
                                  badgeTextColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                label,
                                style: TextStyle(
                                  color: badgeTextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isAcknowledged) ...[
                          const SizedBox(width: 6),
                          Container(
                            height: 24,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2F1E8),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.iconCheck,
                                  width: 13,
                                  height: 13,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF2E9E5B),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Acknowledged',
                                  style: TextStyle(
                                    color: Color(0xFF2E9E5B),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const Spacer(),
                        Text(
                          alert.time,
                          style: const TextStyle(
                            color: Color(0xFF55625D),
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      alert.title,
                      style: const TextStyle(
                        color: Color(0xFF0F1714),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      alert.device,
                      style: const TextStyle(
                        color: Color(0xFF55625D),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.33,
                      ),
                    ),
                    if (alert.seenNote != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppAssets.iconRefresh,
                            width: 12,
                            height: 12,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF55625D),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            alert.seenNote!,
                            style: const TextStyle(
                              color: Color(0xFF55625D),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (alert.note != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppAssets.iconClock,
                            width: 12,
                            height: 12,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFD98A00),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            alert.note!,
                            style: const TextStyle(
                              color: Color(0xFFD98A00),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      alert.message,
                      style: const TextStyle(
                        color: Color(0xFF0F1714),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 1.54,
                      ),
                    ),
                    if (alert.nextAction != null) ...[
                      const SizedBox(height: 6),
                      Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Next: ',
                              style: TextStyle(
                                color: Color(0xFF0F1714),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: alert.nextAction!,
                              style: const TextStyle(
                                color: Color(0xFF55625D),
                                fontSize: 13,
                                height: 1.54,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (!isAcknowledged) ...[
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: onAcknowledge,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF1EE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Acknowledge',
                                style: TextStyle(
                                  color: Color(0xFF0F1714),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onOpen,
      child: isAcknowledged
          ? Opacity(
              opacity: 0.7,
              child: cardContent,
            )
          : cardContent,
    );
  }
}

class _AlertSettingsSheet extends StatefulWidget {
  const _AlertSettingsSheet({required this.repository, required this.onSaved});
  final SemsRepository repository;
  final VoidCallback onSaved;
  @override
  State<_AlertSettingsSheet> createState() => _AlertSettingsSheetState();
}

class _AlertSettingsSheetState extends State<_AlertSettingsSheet> {
  final _overallLimit = TextEditingController();
  final Map<String, TextEditingController> _applianceLimits = {};
  final _start = TextEditingController();
  final _end = TextEditingController();
  bool _mute = true;
  bool _loading = true;
  bool _saving = false;
  Object? _loadError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final preferences = await widget.repository.getAlertPreferences();
      if (!mounted) return;
      _overallLimit.text = preferences.overallPowerLimitW.toString();
      _start.text = preferences.quietHoursStart;
      _end.text = preferences.quietHoursEnd;
      _mute = preferences.muteNonCriticalAlerts;
      if (!_mute && preferences.overallPowerLimitW == 3000) {
        _mute = true;
      }
      for (final appliance in ['Heater', 'Fan', 'Refrigerator']) {
        final initial = preferences.appliancePowerLimitsW[appliance];
        _applianceLimits[appliance] = TextEditingController(
          text: initial != null ? initial.toString() : '',
        );
      }
    } catch (error) {
      _loadError = error;
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _overallLimit.dispose();
    _start.dispose();
    _end.dispose();
    for (final controller in _applianceLimits.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final overall = int.tryParse(_overallLimit.text);
    final limits = <String, int>{};
    for (final entry in _applianceLimits.entries) {
      final value = int.tryParse(entry.value.text);
      if (value != null && value > 0) limits[entry.key] = value;
    }
    if (overall == null || overall <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter valid power limits.'),
        ),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await widget.repository.saveAlertPreferences(
        AlertPreferences(
          overallPowerLimitW: overall,
          appliancePowerLimitsW: limits,
          muteNonCriticalAlerts: _mute,
          quietHoursStart: _start.text.isEmpty ? '22:00' : _start.text,
          quietHoursEnd: _end.text.isEmpty ? '06:00' : _end.text,
        ),
      );
      widget.onSaved();
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save alert settings: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container(
        height: 200,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }
    if (_loadError != null) {
      return Container(
        height: 200,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Text(
          'Unable to load alert settings: $_loadError',
          style: const TextStyle(color: SemsColors.red),
        ),
      );
    }

    final appliances = ['Heater', 'Fan', 'Refrigerator'];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 4),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1E9E5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Alert settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F1714),
                        height: 1.33,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      splashRadius: 20,
                      icon: SvgPicture.asset(
                        AppAssets.iconClose,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF55625D),
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Overall power limit',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF55625D),
                  ),
                ),
                const SizedBox(height: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Alert above',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF55625D),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE1E9E5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _overallLimit,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF0F1714),
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          const Text(
                            'W',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF55625D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Applies to the sum of all sockets',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF55625D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Per appliance',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF55625D),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE1E9E5)),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(16, 22, 20, 0.05),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(16, 22, 20, 0.05),
                        blurRadius: 14,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (int i = 0; i < appliances.length; i++) ...[
                        if (i > 0)
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: Color(0xFFE1E9E5),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAF1EE),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AppAssets.iconZap,
                                    width: 18,
                                    height: 18,
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFF55625D),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                appliances[i],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF0F1714),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                width: 78,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F7F6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: TextField(
                                  controller: _applianceLimits[appliances[i]],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF0F1714),
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: '—',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF0F1714),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'W',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF55625D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Quiet hours',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF55625D),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE1E9E5)),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(16, 22, 20, 0.05),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                      BoxShadow(
                        color: Color.fromRGBO(16, 22, 20, 0.05),
                        blurRadius: 14,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Mute non-critical alerts',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF0F1714),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '22:00 to 06:00. Critical safety alerts always come through.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF55625D),
                                height: 1.33,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => setState(() => _mute = !_mute),
                        child: Container(
                          width: 46,
                          height: 28,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: _mute
                                ? const Color(0xFF0E9F6E)
                                : const Color(0xFFE1E9E5),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          alignment: _mute
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: GestureDetector(
                    onTap: _saving ? null : _save,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E9F6E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _saving ? 'Saving…' : 'Save',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _TrippedBanner extends StatelessWidget {
  const _TrippedBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBE6E6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD64545)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            AppAssets.iconAlert,
            width: 19,
            height: 19,
            colorFilter: const ColorFilter.mode(
              Color(0xFFD64545),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Tripped: Over-current',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 13,
                    height: 20 / 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F1714),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Relay turned OFF. Recovering in 42 s (attempt 1 of 3).',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 12,
                    height: 18 / 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AiEstimateBanner extends StatelessWidget {
  const _AiEstimateBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFECE6FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF7C5CE0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            AppAssets.iconSparkle,
            width: 19,
            height: 19,
            colorFilter: const ColorFilter.mode(
              Color(0xFF7C5CE0),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Estimated, calculated on your phone',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 13,
                    height: 20 / 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F1714),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'AI levels are INFO, LOW, WARNING and HIGH. Critical is only used for socket safety trips.',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 12,
                    height: 18 / 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuietHoursBanner extends StatelessWidget {
  const _QuietHoursBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3ECFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2F6FED)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            AppAssets.iconMoon,
            width: 19,
            height: 19,
            colorFilter: const ColorFilter.mode(
              Color(0xFF2F6FED),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Quiet hours are on',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 13,
                    height: 20 / 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F1714),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '22:00 to 06:00. Only HIGH alerts break quiet hours.',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 12,
                    height: 18 / 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertsEmptyState extends StatelessWidget {
  const _AlertsEmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF1EE),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                AppAssets.iconShield,
                width: 34,
                height: 34,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF0E9F6E),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'No alerts',
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F1714),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Everything looks normal. We will tell you when something needs attention.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 14,
              height: 20 / 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF55625D),
            ),
          ),
        ],
      ),
    );
  }
}
