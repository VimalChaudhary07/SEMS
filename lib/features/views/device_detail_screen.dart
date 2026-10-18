import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_assets.dart';
import '../../core/session/demo_session.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text.dart';
import '../../data/models/sems_models.dart';
import '../../data/repositories/sems_repository.dart';
import '../../shared/widgets/component_theme.dart';
import '../../shared/widgets/role_badge.dart';
import '../../shared/widgets/signal_bars.dart';
import 'control_screen.dart';
import 'safety_limits_screen.dart';

class DeviceDetailScreen extends StatefulWidget {
  const DeviceDetailScreen({
    super.key,
    required this.device,
    required this.repository,
    required this.onChanged,
  });

  final SemsDevice device;
  final SemsRepository repository;
  final VoidCallback onChanged;

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  late SemsDevice device = widget.device;
  final NumberFormat _numberFormat = NumberFormat('#,##0');

  SemsDevice get _currentDevice =>
      widget.repository.devices.firstWhere(
        (item) => item.id == device.id,
        orElse: () => device,
      );

  String get _applianceSvg {
    final name = device.appliance.toLowerCase();
    if (name.contains('fan')) return AppAssets.iconFan;
    if (name.contains('fridge') || name.contains('refrigerator')) {
      return AppAssets.iconFridge;
    }
    if (name.contains('heater')) return AppAssets.iconFlame;
    return AppAssets.iconPlug;
  }

  int get _signalLevel {
    if (!device.online) return 0;
    if (device.signalDbm != null) {
      if (device.signalDbm! > -60) return 4;
      if (device.signalDbm! > -75) return 3;
      if (device.signalDbm! > -85) return 2;
      return 1;
    }
    return 4;
  }

  String get _lastSeenLabel {
    if (device.online) return '4 s ago';
    if (device.lastSeenMinutes > 0) return '${device.lastSeenMinutes} min ago';
    return '14 min ago';
  }

  static String _limit(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : '$value';

  void _openControl() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ControlScreen(
          device: device,
          repository: widget.repository,
          onChanged: () {
            setState(() => device = _currentDevice);
            widget.onChanged();
          },
        ),
      ),
    );
  }

  Future<void> _openSafetyLimits() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) =>
            SafetyLimitsScreen(device: device, repository: widget.repository),
      ),
    );
    if (!mounted) return;
    setState(() => device = _currentDevice);
    widget.onChanged();
  }

  Future<void> _renameSocket() async {
    final name = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _RenameSocketSheet(initialName: device.name),
    );
    if (name == null) return;
    await widget.repository.renameDevice(device.id, name);
    if (!mounted) return;
    setState(() => device = _currentDevice);
    widget.onChanged();
  }

  Future<void> _assignRoom() async {
    const rooms = ['Living room', 'Bedroom', 'Kitchen', 'Study', 'Bathroom'];
    final room = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Assign room',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            for (final room in rooms)
              ListTile(
                title: Text(
                  room,
                  style: const TextStyle(fontFamily: AppText.family),
                ),
                trailing: room == device.room
                    ? const Icon(Icons.check_rounded, color: Color(0xFF0E9F6E))
                    : null,
                onTap: () => Navigator.pop(context, room),
              ),
          ],
        ),
      ),
    );
    if (room == null) return;
    await widget.repository.assignRoom(device.id, room);
    if (!mounted) return;
    setState(() => device = _currentDevice);
    widget.onChanged();
  }

  Future<void> _showButtonHelp() => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => const SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Using the socket buttons',
              style: TextStyle(
                fontFamily: AppText.family,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 14),
            ListTile(
              leading: Icon(Icons.arrow_forward_rounded),
              title: Text('Navigate', style: TextStyle(fontFamily: AppText.family)),
              subtitle: Text('Use the Nav button to move through the menu.', style: TextStyle(fontFamily: AppText.family)),
            ),
            ListTile(
              leading: Icon(Icons.check_circle_outline_rounded),
              title: Text('Select', style: TextStyle(fontFamily: AppText.family)),
              subtitle: Text('Press OK to select a menu item.', style: TextStyle(fontFamily: AppText.family)),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app_rounded),
              title: Text('Exit', style: TextStyle(fontFamily: AppText.family)),
              subtitle: Text('Choose Exit to return to the socket display.', style: TextStyle(fontFamily: AppText.family)),
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> _changeWifi() async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _ChangeWifiSheet(),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Wi-Fi setup is a local preview; no socket was changed.',
          ),
        ),
      );
    }
  }

  Future<void> _transferOwnership() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const _TransferOwnershipDialog(),
    );
    if (confirmed == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ownership transfer is not connected in this preview.'),
        ),
      );
    }
  }

  Future<void> _removeDevice() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove device?', style: TextStyle(fontFamily: AppText.family)),
        content: Text(
          'Remove ${device.name} from this demo home? History is kept.',
          style: const TextStyle(fontFamily: AppText.family),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(fontFamily: AppText.family)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD64545),
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove device', style: TextStyle(fontFamily: AppText.family)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await widget.repository.removeDevice(device.id);
    if (!mounted) return;
    widget.onChanged();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar — height 56px, Figma Frame #14:561
            _DetailTopBar(
              title: device.name,
              subtitle: device.id,
              onBack: () => Navigator.pop(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  // Summary Card — Frame #14:314
                  _SummaryCard(
                    device: device,
                    applianceSvg: _applianceSvg,
                    formattedWatts: _numberFormat.format(device.watts),
                    lastSeenText: _lastSeenLabel,
                    onRemoteControl: _openControl,
                  ),
                  const SizedBox(height: 16),
                  // LIVE READINGS — Frame #14:356
                  _SectionHeader(title: 'LIVE READINGS'),
                  const SizedBox(height: 10),
                  _LiveReadingsGrid(device: device),
                  const SizedBox(height: 16),
                  // DEVICE — Frame #14:406
                  _SectionHeader(title: 'DEVICE'),
                  const SizedBox(height: 10),
                  _DeviceInfoGroup(
                    device: device,
                    signalLevel: _signalLevel,
                    lastSeenText: _lastSeenLabel,
                  ),
                  const SizedBox(height: 16),
                  // DIAGNOSTICS — Frame #14:440
                  _SectionHeader(title: 'DIAGNOSTICS'),
                  const SizedBox(height: 10),
                  _DiagnosticsGroup(),
                  const SizedBox(height: 16),
                  // MANAGE — Frame #14:548
                  _SectionHeader(title: 'MANAGE'),
                  const SizedBox(height: 10),
                  _ManageGroup(
                    device: device,
                    limitText:
                        '${_limit(device.safetyLimits.maxCurrentA)} A · ${_limit(device.safetyLimits.maxPowerW)} W · ${_limit(device.safetyLimits.minVoltageV)} to ${_limit(device.safetyLimits.maxVoltageV)} V',
                    onRename: _renameSocket,
                    onAssignRoom: _assignRoom,
                    onSafetyLimits: _openSafetyLimits,
                    onButtonHelp: _showButtonHelp,
                    onChangeWifi: _changeWifi,
                    onTransferOwnership: _transferOwnership,
                    onRemoveDevice: _removeDevice,
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

class _DetailTopBar extends StatelessWidget {
  const _DetailTopBar({
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return Container(
      height: 56,
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Row(
        children: [
          Tooltip(
            message: 'Back',
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppAssets.iconChevLeft,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    colors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
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
                  subtitle,
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
          const SizedBox(width: 4),
          RoleBadge(isFamily: DemoSession.isMember, showIcon: false),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.device,
    required this.applianceSvg,
    required this.formattedWatts,
    required this.lastSeenText,
    required this.onRemoteControl,
  });

  final SemsDevice device;
  final String applianceSvg;
  final String formattedWatts;
  final String lastSeenText;
  final VoidCallback onRemoteControl;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final iconBg = device.online
        ? colors.brandTint
        : (colors.statusOfflineTint ?? const Color(0xFFECEEF0));
    final iconColor = device.online
        ? colors.brandPrimary
        : colors.statusOffline;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  applianceSvg,
                  width: 26,
                  height: 26,
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
                  children: [
                    Text(
                      device.appliance,
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 17,
                        height: 24 / 17,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      device.room,
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 13,
                        height: 18 / 13,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (device.online) ...[
                          _PillBadge(
                            text: 'Online',
                            iconAsset: AppAssets.iconWifi,
                            textColor: colors.statusOk,
                            bgColor: colors.statusOkTint ?? const Color(0xFFE2F1E8),
                          ),
                          const SizedBox(width: 6),
                          _PillBadge(
                            text: device.isOn ? 'ON' : 'OFF',
                            iconAsset: AppAssets.iconPower,
                            textColor: device.isOn
                                ? colors.brandPrimary
                                : colors.textSecondary,
                            bgColor: device.isOn
                                ? colors.brandTint
                                : colors.raised,
                          ),
                        ] else
                          _PillBadge(
                            text: 'Offline',
                            iconAsset: AppAssets.iconWifiOff,
                            textColor: colors.statusOffline,
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
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        device.online && device.isOn ? formattedWatts : '—',
                        style: TextStyle(
                          fontFamily: AppText.family,
                          fontSize: 26,
                          height: 32 / 26,
                          fontWeight: FontWeight.w700,
                          color: device.online && device.isOn
                              ? colors.textPrimary
                              : colors.textSecondary,
                        ),
                      ),
                      if (device.online && device.isOn) ...[
                        const SizedBox(width: 2),
                        Text(
                          'W',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 13,
                            height: 18 / 13,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Updated $lastSeenText',
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
          const SizedBox(height: 16),
          InkWell(
            onTap: onRemoteControl,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: colors.brandPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.iconPower,
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Remote control',
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 15,
                      height: 20 / 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
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
    );
  }
}

class _LiveReadingsGrid extends StatelessWidget {
  const _LiveReadingsGrid({required this.device});

  final SemsDevice device;

  @override
  Widget build(BuildContext context) {
    final voltage = device.voltageV?.toStringAsFixed(1) ?? '230.2';
    final current = device.currentA?.toStringAsFixed(2) ?? '9.57';
    final freq = device.frequencyHz?.toStringAsFixed(1) ?? '50.0';
    final pf = device.powerFactor?.toStringAsFixed(2) ?? '0.99';
    final sessionKwh = device.sessionKwh?.toStringAsFixed(2) ?? '4.20';
    final lifetimeKwh = device.meterKwh.toStringAsFixed(2);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                title: 'Voltage',
                value: voltage,
                unit: 'V',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricTile(
                title: 'Current',
                value: current,
                unit: 'A',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricTile(
                title: 'Frequency',
                value: freq,
                unit: 'Hz',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                title: 'Power factor',
                value: pf,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricTile(
                title: 'Session kWh',
                value: sessionKwh,
                subtitle: 'This appliance',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricTile(
                title: 'Meter lifetime',
                value: lifetimeKwh == '0.00' ? '150.00' : lifetimeKwh,
                unit: 'kWh',
                subtitle: 'Socket total',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.title,
    required this.value,
    this.unit,
    this.subtitle,
  });

  final String title;
  final String value;
  final String? unit;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);

    return Container(
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
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
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
                if (unit != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    unit!,
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 12,
                      height: 16 / 12,
                      fontWeight: FontWeight.w500,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppText.family,
                fontSize: 11,
                height: 14 / 11,
                fontWeight: FontWeight.w400,
                color: colors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DeviceInfoGroup extends StatelessWidget {
  const _DeviceInfoGroup({
    required this.device,
    required this.signalLevel,
    required this.lastSeenText,
  });

  final SemsDevice device;
  final int signalLevel;
  final String lastSeenText;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          _InfoRow(
            label: 'Device ID',
            valueText: device.id,
            isMonospace: true,
          ),
          _divider(colors),
          const _InfoRow(
            label: 'Serial',
            valueText: 'SN-24A7F1',
            isMonospace: true,
          ),
          _divider(colors),
          const _InfoRow(
            label: 'Model',
            valueText: 'SEMS-S1',
          ),
          _divider(colors),
          const _InfoRow(
            label: 'Firmware',
            subtitle: 'Read only',
            valueText: 'v1.4.2',
            isMonospace: true,
          ),
          _divider(colors),
          _CustomInfoRow(
            label: 'Wi-Fi signal',
            subtitle: 'Home-WiFi · -52 dBm',
            trailing: SignalBars(
              level: signalLevel,
              activeColor: colors.textPrimary,
              inactiveColor: colors.border,
            ),
          ),
          _divider(colors),
          _CustomInfoRow(
            label: 'Cloud connection',
            subtitle: 'MQTT over Wi-Fi',
            trailing: _PillBadge(
              text: 'Connected',
              iconAsset: AppAssets.iconCloud,
              textColor: colors.statusOk,
              bgColor: colors.statusOkTint ?? const Color(0xFFE2F1E8),
            ),
          ),
          _divider(colors),
          _InfoRow(
            label: 'Last telemetry',
            valueText: lastSeenText,
            valueColor: colors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _divider(AppColors colors) => Container(
        height: 1,
        color: colors.border,
      );
}

class _DiagnosticsGroup extends StatelessWidget {
  const _DiagnosticsGroup();

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          _InfoRow(
            label: 'Last fault code',
            valueText: 'None',
            valueColor: colors.textSecondary,
          ),
          _divider(colors),
          _CustomInfoRow(
            label: 'Meter status',
            trailing: _PillBadge(
              text: 'Reading OK',
              iconAsset: AppAssets.iconCheck,
              textColor: colors.statusOk,
              bgColor: colors.statusOkTint ?? const Color(0xFFE2F1E8),
            ),
          ),
          _divider(colors),
          const _InfoRow(
            label: 'Unsent data queue',
            subtitle: 'Readings waiting to reach the app',
            valueText: '0 readings · 0% full',
          ),
          _divider(colors),
          const _InfoRow(
            label: 'Uptime',
            valueText: '312 h',
          ),
          _divider(colors),
          const _InfoRow(
            label: 'Reboot reason',
            valueText: 'Power on',
          ),
        ],
      ),
    );
  }

  Widget _divider(AppColors colors) => Container(
        height: 1,
        color: colors.border,
      );
}

class _ManageGroup extends StatelessWidget {
  const _ManageGroup({
    required this.device,
    required this.limitText,
    required this.onRename,
    required this.onAssignRoom,
    required this.onSafetyLimits,
    required this.onButtonHelp,
    required this.onChangeWifi,
    required this.onTransferOwnership,
    required this.onRemoveDevice,
  });

  final SemsDevice device;
  final String limitText;
  final VoidCallback onRename;
  final VoidCallback onAssignRoom;
  final VoidCallback onSafetyLimits;
  final VoidCallback onButtonHelp;
  final VoidCallback onChangeWifi;
  final VoidCallback onTransferOwnership;
  final VoidCallback onRemoveDevice;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          if (!DemoSession.isMember) ...[
            _ManageRow(
              iconSvg: AppAssets.iconEdit,
              title: 'Rename socket',
              onTap: onRename,
            ),
            _divider(colors),
            _ManageRow(
              iconSvg: AppAssets.iconHome,
              title: 'Assign room',
              subtitle: device.room,
              onTap: onAssignRoom,
            ),
            _divider(colors),
          ],
          _ManageRow(
            iconSvg: AppAssets.iconShield,
            title: 'Safety limits',
            subtitle: limitText,
            onTap: onSafetyLimits,
          ),
          _divider(colors),
          _ManageRow(
            iconSvg: AppAssets.iconInfo,
            title: 'Using the socket buttons',
            subtitle: 'NAV and OK, config menu',
            onTap: onButtonHelp,
          ),
          if (!DemoSession.isMember) ...[
            _divider(colors),
            _ManageRow(
              iconSvg: AppAssets.iconWifi,
              title: 'Change Wi-Fi',
              subtitle: 'Needs you near the socket',
              onTap: onChangeWifi,
            ),
            _divider(colors),
            _ManageRow(
              iconSvg: AppAssets.iconUsers,
              title: 'Transfer ownership',
              subtitle: 'Give this home to another account',
              onTap: onTransferOwnership,
            ),
            _divider(colors),
            _ManageRow(
              iconSvg: AppAssets.iconTrash,
              iconBgColor: const Color(0xFFFBE6E6),
              iconColor: const Color(0xFFD64545),
              title: 'Remove device',
              titleColor: const Color(0xFFD64545),
              subtitle: 'History is kept',
              onTap: onRemoveDevice,
            ),
          ],
        ],
      ),
    );
  }

  Widget _divider(AppColors colors) => Container(
        height: 1,
        color: colors.border,
      );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    this.subtitle,
    required this.valueText,
    this.valueColor,
    this.isMonospace = false,
  });

  final String label;
  final String? subtitle;
  final String valueText;
  final Color? valueColor;
  final bool isMonospace;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 15,
                    height: 20 / 15,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 12,
                      height: 18 / 12,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            valueText,
            style: TextStyle(
              fontFamily: isMonospace ? 'JetBrains Mono' : AppText.family,
              fontSize: isMonospace ? 12 : 13,
              height: 16 / 12,
              fontWeight: FontWeight.w500,
              color: valueColor ?? colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomInfoRow extends StatelessWidget {
  const _CustomInfoRow({
    required this.label,
    this.subtitle,
    required this.trailing,
  });

  final String label;
  final String? subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 15,
                    height: 20 / 15,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 12,
                      height: 18 / 12,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          trailing,
        ],
      ),
    );
  }
}

class _ManageRow extends StatelessWidget {
  const _ManageRow({
    required this.iconSvg,
    this.iconBgColor,
    this.iconColor,
    required this.title,
    this.titleColor,
    this.subtitle,
    required this.onTap,
  });

  final String iconSvg;
  final Color? iconBgColor;
  final Color? iconColor;
  final String title;
  final Color? titleColor;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBgColor ?? colors.raised,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                iconSvg,
                width: 19,
                height: 19,
                colorFilter: ColorFilter.mode(
                  iconColor ?? colors.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 15,
                      height: 20 / 15,
                      fontWeight: FontWeight.w500,
                      color: titleColor ?? colors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 12,
                        height: 18 / 12,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              AppAssets.iconChevRight,
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(
                colors.textSecondary,
                BlendMode.srcIn,
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
    required this.iconAsset,
    required this.textColor,
    required this.bgColor,
  });

  final String text;
  final String iconAsset;
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
          SvgPicture.asset(
            iconAsset,
            width: 13,
            height: 13,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),
          const SizedBox(width: 4),
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

class _RenameSocketSheet extends StatefulWidget {
  const _RenameSocketSheet({required this.initialName});

  final String initialName;

  @override
  State<_RenameSocketSheet> createState() => _RenameSocketSheetState();
}

class _RenameSocketSheetState extends State<_RenameSocketSheet> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          8,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Rename socket',
              style: TextStyle(
                fontFamily: AppText.family,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _controller,
              autofocus: true,
              style: const TextStyle(fontFamily: AppText.family),
              decoration: const InputDecoration(
                labelText: 'Socket name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E9F6E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final trimmed = _controller.text.trim();
                if (trimmed.isEmpty) return;
                Navigator.pop(context, trimmed);
              },
              child: const Text(
                'Save name',
                style: TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChangeWifiSheet extends StatefulWidget {
  const _ChangeWifiSheet();

  @override
  State<_ChangeWifiSheet> createState() => _ChangeWifiSheetState();
}

class _ChangeWifiSheetState extends State<_ChangeWifiSheet> {
  final _ssidController = TextEditingController(text: 'Home-WiFi');
  final _passwordController = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _ssidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          8,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Change Wi-Fi',
              style: TextStyle(
                fontFamily: AppText.family,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ssidController,
              decoration: const InputDecoration(
                labelText: 'Network name (SSID)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Wi-Fi Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E9F6E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Update Wi-Fi credentials'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransferOwnershipDialog extends StatefulWidget {
  const _TransferOwnershipDialog();

  @override
  State<_TransferOwnershipDialog> createState() =>
      _TransferOwnershipDialogState();
}

class _TransferOwnershipDialogState extends State<_TransferOwnershipDialog> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Transfer ownership'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Enter the recipient email address. Once accepted, you will lose primary owner controls.',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'New owner email',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0E9F6E),
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Send transfer invite'),
        ),
      ],
    );
  }
}
