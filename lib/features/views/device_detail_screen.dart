import 'package:flutter/material.dart';

import '../../core/session/demo_session.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/sems_models.dart';
import '../../data/repositories/sems_repository.dart';
import '../../shared/widgets/sems_widgets.dart';
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

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(device.name, style: Theme.of(context).textTheme.titleMedium),
          Text(device.id, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(child: RoleBadge(isFamily: DemoSession.isMember)),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 24),
      children: [
        _summaryCard(context),
        if (!device.online || device.safetyTrip) ...[
          const SizedBox(height: 10),
          _stateBanner(),
        ],
        const SizedBox(height: 12),
        const _DetailSection('LIVE READINGS'),
        const SizedBox(height: 6),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 7,
          crossAxisSpacing: 7,
          childAspectRatio: 1.4,
          children: [
            _ReadingTile(
              label: 'Voltage',
              value: _reading(device.voltageV, 1),
              unit: 'V',
            ),
            _ReadingTile(
              label: 'Current',
              value: _reading(device.currentA, 2),
              unit: 'A',
            ),
            _ReadingTile(
              label: 'Frequency',
              value: _reading(device.frequencyHz, 1),
              unit: 'Hz',
            ),
            _ReadingTile(
              label: 'Power factor',
              value: _reading(device.powerFactor, 2),
              unit: '',
            ),
            _ReadingTile(
              label: 'Session kWh',
              value: _reading(device.sessionKwh, 2),
              unit: 'This appliance',
            ),
            _ReadingTile(
              label: 'Meter lifetime',
              value: device.meterKwh.toStringAsFixed(2),
              unit: 'Socket total',
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _DetailSection('DEVICE'),
        const SizedBox(height: 6),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _InfoRow('Device ID', device.id, monospace: true),
              const Divider(height: 1),
              const _InfoRow('Serial', 'SN-26A7F1', monospace: true),
              const Divider(height: 1),
              const _InfoRow('Model', 'SEMS-S1'),
              const Divider(height: 1),
              const _InfoRow('Firmware', 'v1.4.2', subtitle: 'Read only'),
              const Divider(height: 1),
              _InfoRow(
                'Wi-Fi signal',
                _signalStrength(device.signalDbm),
                subtitle: device.signalDbm == null
                    ? 'Signal unavailable'
                    : 'Home Wi-Fi · ${device.signalDbm} dBm',
              ),
              const Divider(height: 1),
              _InfoRow(
                'Cloud connection',
                device.online ? 'Connected' : 'Disconnected',
                subtitle: 'MQTT over Wi-Fi',
                valueColor: device.online
                    ? SemsColors.forest
                    : SemsColors.muted,
                icon: device.online
                    ? Icons.cloud_done_outlined
                    : Icons.cloud_off,
              ),
              const Divider(height: 1),
              _InfoRow('Last telemetry', _lastSeenLabel),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const _DetailSection('DIAGNOSTICS'),
        const SizedBox(height: 6),
        const AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _InfoRow('Last fault code', 'None'),
              Divider(height: 1),
              _InfoRow(
                'Meter status',
                'Reading OK',
                valueColor: SemsColors.forest,
              ),
              Divider(height: 1),
              _InfoRow(
                'Unsent data queue',
                '0 readings · 0% full',
                subtitle: 'Readings waiting to reach the app',
              ),
              Divider(height: 1),
              _InfoRow('Uptime', '312 h'),
              Divider(height: 1),
              _InfoRow('Reboot reason', 'Power on'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const _DetailSection('MANAGE'),
        const SizedBox(height: 6),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              if (!DemoSession.isMember) ...[
                _ManageRow(
                  icon: Icons.edit_outlined,
                  title: 'Rename socket',
                  onTap: _renameSocket,
                ),
                const Divider(height: 1),
                _ManageRow(
                  icon: Icons.home_outlined,
                  title: 'Assign room',
                  subtitle: device.room,
                  onTap: _assignRoom,
                ),
                const Divider(height: 1),
              ],
              _ManageRow(
                icon: Icons.shield_outlined,
                title: 'Safety limits',
                subtitle:
                    '${_limit(device.safetyLimits.maxCurrentA)} A · ${_limit(device.safetyLimits.maxPowerW)} W · ${_limit(device.safetyLimits.minVoltageV)} to ${_limit(device.safetyLimits.maxVoltageV)} V',
                onTap: _openSafetyLimits,
              ),
              const Divider(height: 1),
              _ManageRow(
                icon: Icons.info_outline_rounded,
                title: 'Using the socket buttons',
                subtitle: 'Nav and OK, config menu',
                onTap: _showButtonHelp,
              ),
              if (!DemoSession.isMember) ...[
                const Divider(height: 1),
                _ManageRow(
                  icon: Icons.wifi_outlined,
                  title: 'Change Wi-Fi',
                  subtitle: 'Needs you near the socket',
                  onTap: _changeWifi,
                ),
                const Divider(height: 1),
                _ManageRow(
                  icon: Icons.people_outline_rounded,
                  title: 'Transfer ownership',
                  subtitle: 'Give this home to another account',
                  onTap: _transferOwnership,
                ),
                const Divider(height: 1),
                _ManageRow(
                  icon: Icons.delete_outline_rounded,
                  title: 'Remove device',
                  subtitle: 'History is kept',
                  destructive: true,
                  onTap: _removeDevice,
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );

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

  Widget _summaryCard(BuildContext context) => AppCard(
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: ComponentTheme.colors(context).brandTint,
                borderRadius: BorderRadius.circular(9),
              ),
              alignment: Alignment.center,
              child: Icon(
                _applianceIcon,
                color: ComponentTheme.colors(context).brandPrimary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.appliance,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    device.room,
                    style: const TextStyle(
                      color: SemsColors.muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  device.online && device.isOn ? '${device.watts} W' : '—',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  _lastSeenLabel,
                  style: const TextStyle(color: SemsColors.muted, fontSize: 9),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            StatusBadge(
              icon: device.online ? Icons.wifi_rounded : Icons.wifi_off_rounded,
              label: device.online ? 'Online' : 'Offline',
              tone: device.online ? StatusTone.ok : StatusTone.off,
            ),
            const SizedBox(width: 6),
            if (device.online)
              StatusBadge(
                icon: Icons.power_settings_new_rounded,
                label: device.isOn ? 'ON' : 'OFF',
                tone: device.isOn ? StatusTone.ok : StatusTone.mute,
              ),
            if (device.safetyTrip) ...[
              const SizedBox(width: 6),
              const StatusBadge(
                icon: Icons.shield_outlined,
                label: 'Safety trip',
                tone: StatusTone.fault,
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        AppButton(
          label: 'Remote control',
          leadingIcon: Icons.power_settings_new_rounded,
          size: AppButtonSize.small,
          onPressed: device.online ? _openControl : null,
        ),
      ],
    ),
  );

  Widget _stateBanner() {
    final isTrip = device.safetyTrip;
    return AppBanner(
      tone: isTrip ? StatusTone.fault : StatusTone.off,
      icon: isTrip ? Icons.shield_outlined : Icons.wifi_off_rounded,
      title: isTrip ? 'Safety protection active' : 'Socket is offline',
      body: isTrip
          ? '${device.tripReason ?? 'The socket is paused for safety.'}${device.tripSecondsRemaining == null ? '' : ' Retry in ${device.tripSecondsRemaining} s.'}'
          : 'Last seen $_lastSeenLabel. Local safety limits and schedules continue on the socket.',
    );
  }

  IconData get _applianceIcon {
    final appliance = device.appliance.toLowerCase();
    if (appliance.contains('fan')) return Icons.air_rounded;
    if (appliance.contains('refrigerator') || appliance.contains('fridge')) {
      return Icons.kitchen_outlined;
    }

    if (appliance.contains('heater')) {
      return Icons.local_fire_department_outlined;
    }
    return Icons.power_rounded;
  }

  String get _lastSeenLabel {
    if (device.lastSeenMinutes == 0) return 'Just now';
    return '${device.lastSeenMinutes} min ago';
  }

  static String _reading(double? value, int decimals) =>
      value?.toStringAsFixed(decimals) ?? '—';

  static String _signalStrength(int? signalDbm) {
    if (signalDbm == null) return '—';
    if (signalDbm >= -60) return 'Strong';
    if (signalDbm >= -75) return 'Good';
    return 'Weak';
  }

  static String _limit(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : '$value';

  void _openControl() => Navigator.push(
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            for (final room in rooms)
              ListTile(
                title: Text(room),
                trailing: room == device.room
                    ? const Icon(Icons.check_rounded, color: SemsColors.forest)
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 14),
            ListTile(
              leading: Icon(Icons.arrow_forward_rounded),
              title: Text('Navigate'),
              subtitle: Text('Use the Nav button to move through the menu.'),
            ),
            ListTile(
              leading: Icon(Icons.check_circle_outline_rounded),
              title: Text('Select'),
              subtitle: Text('Press OK to select a menu item.'),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app_rounded),
              title: Text('Exit'),
              subtitle: Text('Choose Exit to return to the socket display.'),
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
        title: const Text('Remove device?'),
        content: Text(
          'Remove ${device.name} from this demo home? History is kept.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          AppButton(
            fullWidth: false,
            variant: AppButtonVariant.danger,
            onPressed: () => Navigator.pop(context, true),
            label: 'Remove device',
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

  SemsDevice get _currentDevice =>
      widget.repository.devices.firstWhere((item) => item.id == device.id);
}

class _RenameSocketSheet extends StatefulWidget {
  const _RenameSocketSheet({required this.initialName});

  final String initialName;

  @override
  State<_RenameSocketSheet> createState() => _RenameSocketSheetState();
}

class _RenameSocketSheetState extends State<_RenameSocketSheet> {
  late final controller = TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom
        .clamp(0.0, MediaQuery.sizeOf(context).height * 0.5);
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rename socket',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 14),
              AppButton(
                label: 'Save name',
                onPressed: () {
                  final value = controller.text.trim();
                  if (value.isNotEmpty) Navigator.pop(context, value);
                },
              ),
            ],
          ),
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
  final form = GlobalKey<FormState>();
  final network = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    network.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom
        .clamp(0.0, MediaQuery.sizeOf(context).height * 0.5);
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Change Wi-Fi',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: network,
                  decoration: const InputDecoration(labelText: 'Wi-Fi name'),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a Wi-Fi name'
                      : null,
                ),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Wi-Fi password',
                  ),
                ),
                const SizedBox(height: 14),
                AppButton(
                  label: 'Continue',
                  onPressed: () {
                    if (form.currentState!.validate()) {
                      Navigator.pop(context, true);
                    }
                  },
                ),
              ],
            ),
          ),
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
  final form = GlobalKey<FormState>();
  final email = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Transfer ownership?'),
    content: Form(
      key: form,
      child: TextFormField(
        controller: email,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(labelText: 'New owner email'),
        validator: (value) => value == null || !value.contains('@')
            ? 'Enter a valid email'
            : null,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('Cancel'),
      ),
      AppButton(
        fullWidth: false,
        label: 'Transfer',
        onPressed: () {
          if (form.currentState!.validate()) Navigator.pop(context, true);
        },
      ),
    ],
  );
}

class _DetailSection extends StatelessWidget {
  const _DetailSection(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: const TextStyle(
      color: SemsColors.muted,
      fontSize: 10,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.8,
    ),
  );
}

class _ReadingTile extends StatelessWidget {
  const _ReadingTile({
    required this.label,
    required this.value,
    required this.unit,
  });

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.all(8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: SemsColors.muted, fontSize: 9),
        ),
        const Spacer(),
        FittedBox(
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (unit.length < 3 && unit.isNotEmpty) ...[
                const SizedBox(width: 3),
                Text(
                  unit,
                  style: const TextStyle(color: SemsColors.muted, fontSize: 9),
                ),
              ],
            ],
          ),
        ),
        if (unit.length >= 3)
          Text(
            unit,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: SemsColors.muted, fontSize: 8),
          ),
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(
    this.label,
    this.value, {
    this.subtitle,
    this.valueColor,
    this.icon,
    this.monospace = false,
  });

  final String label;
  final String value;
  final String? subtitle;
  final Color? valueColor;
  final IconData? icon;
  final bool monospace;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11)),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(color: SemsColors.muted, fontSize: 9),
                ),
            ],
          ),
        ),
        if (icon != null) ...[
          Icon(icon, size: 14, color: valueColor ?? SemsColors.forest),
          const SizedBox(width: 4),
        ],
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor ?? SemsColors.ink,
              fontSize: 10,
              fontFamily: monospace ? 'monospace' : null,
            ),
          ),
        ),
      ],
    ),
  );
}

class _ManageRow extends StatelessWidget {
  const _ManageRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 9, vertical: 0),
      leading: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: destructive
              ? ComponentTheme.tint(context, 'fault')
              : colors.brandTint,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 16,
          color: destructive ? colors.statusFault : colors.brandPrimary,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: destructive ? colors.statusFault : colors.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: const TextStyle(fontSize: 9, color: SemsColors.muted),
            ),
      trailing: const Icon(Icons.chevron_right_rounded, size: 18),
      onTap: onTap,
    );
  }
}
