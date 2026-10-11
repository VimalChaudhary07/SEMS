import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/session/demo_session.dart';
import '../../data/models/sems_models.dart';
import '../../data/repositories/sems_repository.dart';
import '../../shared/widgets/sems_widgets.dart';
import 'device_detail_screen.dart';
import 'insights_screen.dart';
import 'more_screens.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'settings_detail_screens.dart';
import 'backup_restore_screen.dart';
import 'add_appliance_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key, required this.repository});
  final SemsRepository repository;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: PageHeading(title: 'More', subtitle: 'Your SEMS home tools'),
        ),
        const SizedBox(height: 18),
        AppCard(
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: SemsColors.forest,
                child: Text(
                  'AV',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Asha Verma',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'owner@sems.app',
                      style: TextStyle(color: SemsColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              _OwnerBadge(label: DemoSession.isMember ? 'Member' : 'Owner'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _MoreTile(
                icon: Icons.layers_outlined,
                title: 'Appliances',
                subtitle:
                    '${repository.appliances.where((item) => !item.archived).length} active appliances',
                onTap: () =>
                    _push(context, AppliancesScreen(repository: repository)),
              ),
              _MoreTile(
                icon: Icons.calendar_month_outlined,
                title: 'Scheduling',
                subtitle: 'Automate device routines',
                onTap: () =>
                    _push(context, SchedulesScreen(repository: repository)),
              ),
              _MoreTile(
                icon: Icons.receipt_long_outlined,
                title: 'Billing and tariff',
                subtitle: 'Bills, budget, estimates',
                onTap: () => _push(
                  context,
                  TariffSettingsScreen(readOnly: DemoSession.isMember),
                ),
              ),
              _MoreTile(
                icon: Icons.auto_awesome_outlined,
                title: 'AI energy',
                subtitle: 'Forecasts and tips',
                onTap: () =>
                    _push(context, InsightsScreen(repository: repository)),
              ),
              _MoreTile(
                icon: Icons.cloud_outlined,
                title: 'Backup and restore',
                subtitle: 'Local preview',
                onTap: () {
                  if (DemoSession.isMember) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Backup is available to the owner in this demo.',
                        ),
                      ),
                    );
                  } else {
                    _push(context, const BackupRestoreScreen());
                  }
                },
              ),
              _MoreTile(
                icon: Icons.tune_rounded,
                title: 'Settings',
                subtitle: 'Profile, notifications, privacy',
                onTap: () => _push(context, const SettingsScreen()),
                last: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _MoreTile(
                icon: Icons.person_outline_rounded,
                title: 'Profile',
                subtitle: 'Account and support',
                onTap: () =>
                    _push(context, ProfileScreen(repository: repository)),
              ),
              _MoreTile(
                icon: Icons.help_outline_rounded,
                title: 'Help and support',
                subtitle: 'Frequently asked questions',
                onTap: () => _push(context, const HelpScreen()),
                last: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const Center(
          child: Text(
            'SEMS v1.0.0 · Example data only',
            style: TextStyle(color: SemsColors.muted, fontSize: 11),
          ),
        ),
      ],
    ),
  );

  static void _push(BuildContext context, Widget page) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
}

class _OwnerBadge extends StatelessWidget {
  const _OwnerBadge({this.label = 'Owner'});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: SemsColors.mint,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: SemsColors.forest,
        fontWeight: FontWeight.w600,
        fontSize: 11,
      ),
    ),
  );
}

class _MoreTile extends StatelessWidget {
  const _MoreTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.last = false,
  });
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  final bool last;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 1),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: SemsColors.mint,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 19, color: SemsColors.forest),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: SemsColors.muted, fontSize: 11),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: SemsColors.muted,
        ),
        minLeadingWidth: 0,
      ),
      if (!last) const Divider(height: 1, indent: 64),
    ],
  );
}

class AppliancesScreen extends StatefulWidget {
  const AppliancesScreen({super.key, required this.repository});
  final SemsRepository repository;
  @override
  State<AppliancesScreen> createState() => _AppliancesScreenState();
}

class _AppliancesScreenState extends State<AppliancesScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Appliances'),
      actions: [
        if (!DemoSession.isMember)
          IconButton(
            onPressed: _addAppliance,
            tooltip: 'Add appliance',
            icon: const Icon(Icons.add_rounded),
          ),
      ],
    ),
    body: Builder(
      builder: (context) {
        final active = widget.repository.appliances
            .where((item) => !item.archived)
            .toList();
        final archived = widget.repository.appliances
            .where((item) => item.archived)
            .toList();
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SectionTitle('ACTIVE'),
            const SizedBox(height: 8),
            if (active.isEmpty)
              const AppCard(
                child: Text(
                  'No appliances yet. Add one to start tracking energy use.',
                  style: TextStyle(color: SemsColors.muted),
                ),
              ),
            for (final appliance in active)
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: AppCard(
                  child: ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ApplianceOverviewScreen(
                          appliance: appliance,
                          repository: widget.repository,
                          onChanged: () => setState(() {}),
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: appliance.online
                            ? SemsColors.mint
                            : const Color(0xFFECEEF0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _applianceIcon(appliance.name),
                        color: appliance.online
                            ? SemsColors.forest
                            : SemsColors.muted,
                      ),
                    ),
                    title: Text(
                      appliance.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      appliance.socketId == null
                          ? '${appliance.room.isEmpty ? 'No room' : appliance.room} · Assign a socket later'
                          : '${appliance.room} · ${appliance.socketId} · ${appliance.online ? 'Online' : 'Offline'}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: SemsColors.muted,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          appliance.online ? '${appliance.watts} W' : '—',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '${appliance.todayKwh} kWh today',
                          style: const TextStyle(
                            color: SemsColors.muted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            const SectionTitle('ARCHIVED'),
            const SizedBox(height: 8),
            if (archived.isEmpty)
              const AppCard(
                child: Text(
                  'Archived appliances and their energy history appear here.',
                  style: TextStyle(color: SemsColors.muted),
                ),
              ),
            for (final appliance in archived)
              AppCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.inventory_2_outlined,
                    color: SemsColors.muted,
                  ),
                  title: Text(appliance.name),
                  subtitle: Text(
                    '${appliance.lifetimeKwh} kWh lifetime · history kept',
                    style: const TextStyle(
                      fontSize: 11,
                      color: SemsColors.muted,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    ),
  );

  Future<void> _addAppliance() async {
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddApplianceScreen(repository: widget.repository),
      ),
    );
    if (added == true && mounted) setState(() {});
  }

  static IconData _applianceIcon(String name) =>
      name.toLowerCase().contains('fan')
      ? Icons.toys_outlined
      : name.toLowerCase().contains('fridge')
      ? Icons.kitchen_outlined
      : name.toLowerCase().contains('heater')
      ? Icons.local_fire_department_outlined
      : Icons.power_rounded;
}

void _showApplianceMessage(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));

class ApplianceOverviewScreen extends StatefulWidget {
  const ApplianceOverviewScreen({
    super.key,
    required this.appliance,
    required this.repository,
    required this.onChanged,
  });
  final SemsAppliance appliance;
  final SemsRepository repository;
  final VoidCallback onChanged;
  @override
  State<ApplianceOverviewScreen> createState() =>
      _ApplianceOverviewScreenState();
}

class _ApplianceOverviewScreenState extends State<ApplianceOverviewScreen> {
  late SemsAppliance appliance = widget.appliance;
  bool working = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(appliance.name),
      actions: [
        if (!DemoSession.isMember)
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'move') {
                final socketId = appliance.socketId;
                if (socketId == null) {
                  _showApplianceMessage(
                    context,
                    'Assign a socket before moving this appliance.',
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => MoveApplianceScreen(
                      appliance: appliance,
                      repository: widget.repository,
                      onChanged: widget.onChanged,
                    ),
                  ),
                ).then((_) => _refresh());
              } else {
                await _archive();
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'move', child: Text('Move appliance')),
              PopupMenuItem(value: 'archive', child: Text('Archive appliance')),
            ],
          ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        AppCard(
          child: Column(
            children: [
              Icon(
                _AppliancesScreenState._applianceIcon(appliance.name),
                size: 48,
                color: appliance.online ? SemsColors.forest : SemsColors.muted,
              ),
              const SizedBox(height: 12),
              Text(
                appliance.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                appliance.socketId == null
                    ? '${appliance.room.isEmpty ? 'No room assigned' : appliance.room} · Not connected'
                    : '${appliance.room} · ${appliance.socketId}',
                style: const TextStyle(color: SemsColors.muted),
              ),
              const SizedBox(height: 10),
              Chip(
                label: Text(
                  appliance.archived
                      ? 'Archived'
                      : appliance.socketId == null
                      ? 'Assign a socket'
                      : appliance.online
                      ? 'Online'
                      : 'Offline',
                ),
                avatar: Icon(
                  appliance.online
                      ? Icons.wifi_rounded
                      : Icons.wifi_off_rounded,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                label: 'Current draw',
                value: appliance.online ? '${appliance.watts}' : '—',
                unit: 'W',
                icon: Icons.bolt_rounded,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                label: 'Today',
                value: '${appliance.todayKwh}',
                unit: 'kWh',
                icon: Icons.show_chart_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const SectionTitle('CURRENT SESSION'),
        const SizedBox(height: 8),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailRow(
                label: 'Session energy',
                value: appliance.sessionKwh == null
                    ? 'No active session'
                    : '${appliance.sessionKwh!.toStringAsFixed(2)} kWh',
              ),
              if (appliance.sessionStartedAt != null)
                _DetailRow(
                  label: 'Started',
                  value: appliance.sessionStartedAt!,
                ),
              if (appliance.meterKwh != null)
                _DetailRow(
                  label: 'Socket meter',
                  value: '${appliance.meterKwh!.toStringAsFixed(1)} kWh',
                ),
              if (appliance.ratedPowerW != null)
                _DetailRow(
                  label: 'Rated power',
                  value: '${appliance.ratedPowerW} W',
                ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const SectionTitle('Consumption history'),
        AppCard(
          child: EnergyBars(
            values: widget.repository.weeklyReadings.map((e) => e.kwh).toList(),
          ),
        ),
        if (appliance.socketId != null) ...[
          const SizedBox(height: 14),
          FilledButton(
            onPressed: () {
              final socket = widget.repository.devices.firstWhere(
                (item) => item.id == appliance.socketId,
              );
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => DeviceDetailScreen(
                    device: socket,
                    repository: widget.repository,
                    onChanged: widget.onChanged,
                  ),
                ),
              );
            },
            child: const Text('Open connected socket'),
          ),
        ],
        if (!DemoSession.isMember && !appliance.archived) ...[
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: working ? null : _rename,
            child: const Text('Rename appliance'),
          ),
        ],
        if (working)
          const Padding(
            padding: EdgeInsets.all(12),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    ),
  );

  Future<void> _refresh() async {
    if (!mounted) return;
    final updated = widget.repository.appliances.where(
      (item) => item.id == appliance.id,
    );
    if (updated.isNotEmpty) setState(() => appliance = updated.first);
  }

  Future<void> _rename() async {
    final controller = TextEditingController(text: appliance.name);
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename appliance'),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value == null || value.isEmpty || !mounted) return;
    setState(() => working = true);
    try {
      await widget.repository.renameApplianceRecord(appliance.id, value);
      await _refresh();
      widget.onChanged();
    } catch (error) {
      if (mounted) {
        _showApplianceMessage(context, 'Could not rename appliance: $error');
      }
    } finally {
      if (mounted) setState(() => working = false);
    }
  }

  Future<void> _archive() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive appliance?'),
        content: const Text(
          'This ends any active session and keeps the appliance’s energy history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    setState(() => working = true);
    try {
      await widget.repository.archiveAppliance(appliance.id);
      widget.onChanged();
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        _showApplianceMessage(context, 'Could not archive appliance: $error');
      }
    } finally {
      if (mounted) setState(() => working = false);
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: SemsColors.muted)),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

class MoveApplianceScreen extends StatefulWidget {
  const MoveApplianceScreen({
    super.key,
    required this.appliance,
    required this.repository,
    required this.onChanged,
  });
  final SemsAppliance appliance;
  final SemsRepository repository;
  final VoidCallback onChanged;
  @override
  State<MoveApplianceScreen> createState() => _MoveApplianceScreenState();
}

class _MoveApplianceScreenState extends State<MoveApplianceScreen> {
  int step = 0;
  String? selected;
  bool working = false;

  SemsDevice? get destination {
    for (final device in widget.repository.devices) {
      if (device.id == selected) return device;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Move ${widget.appliance.name}')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        LinearProgressIndicator(
          value: step >= 3 ? 1 : (step + 1) / 3,
          minHeight: 5,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 24),
        Text(
          [
            'Close current session',
            'Choose new socket',
            'Review and confirm',
            'Appliance moved',
          ][step],
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          [
            'The current meter session will be closed and its final reading kept.',
            'Choose an online SEMS socket. Any appliance there will be unassigned, with its history preserved.',
            'Review the source and destination meter readings before confirming.',
            'The new session is open. Previous appliance history is preserved.',
          ][step],
          style: const TextStyle(color: SemsColors.muted),
        ),
        const SizedBox(height: 20),
        if (step == 0)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(label: 'Appliance', value: widget.appliance.name),
                _DetailRow(
                  label: 'Current socket',
                  value: widget.appliance.socketId ?? 'Not assigned',
                ),
                _DetailRow(
                  label: 'Session energy',
                  value: widget.appliance.sessionKwh == null
                      ? 'No active session'
                      : '${widget.appliance.sessionKwh!.toStringAsFixed(2)} kWh',
                ),
                if (widget.appliance.meterKwh != null)
                  _DetailRow(
                    label: 'Current meter',
                    value:
                        '${widget.appliance.meterKwh!.toStringAsFixed(1)} kWh',
                  ),
              ],
            ),
          ),
        if (step == 1)
          RadioGroup<String>(
            groupValue: selected,
            onChanged: (value) => setState(() => selected = value),
            child: Column(
              children: [
                for (final device in widget.repository.devices.where(
                  (d) =>
                      d.id != widget.appliance.socketId &&
                      d.online &&
                      !d.safetyTrip,
                ))
                  RadioListTile<String>(
                    value: device.id,
                    title: Text(device.name),
                    subtitle: Text(
                      '${device.room} · ${device.id} · ${device.appliance == 'Unassigned' ? 'Available' : 'Currently ${device.appliance}'}',
                    ),
                  ),
              ],
            ),
          ),
        if (step == 1 &&
            !widget.repository.devices.any(
              (device) =>
                  device.id != widget.appliance.socketId &&
                  device.online &&
                  !device.safetyTrip,
            ))
          const AppCard(
            child: Text(
              'No online destination sockets are available. Connect another socket and try again.',
            ),
          ),
        if (step == 2 && destination != null)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(label: 'Appliance', value: widget.appliance.name),
                _DetailRow(
                  label: 'From',
                  value: widget.appliance.socketId ?? 'Not assigned',
                ),
                _DetailRow(label: 'To', value: destination!.name),
                _DetailRow(
                  label: 'Destination meter',
                  value: '${destination!.meterKwh.toStringAsFixed(1)} kWh',
                ),
                if (destination!.appliance != 'Unassigned')
                  _DetailRow(
                    label: 'Current appliance',
                    value: '${destination!.appliance} will be unassigned',
                  ),
                const Text(
                  'The current session will close. A new meter session starts at the destination reading.',
                  style: TextStyle(color: SemsColors.muted, height: 1.4),
                ),
              ],
            ),
          ),
        if (step == 3)
          const AppCard(
            child: Text(
              'Move completed locally. Meter sessions were updated; no hardware or backend was contacted.',
            ),
          ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: working
              ? null
              : step == 3
              ? () => Navigator.pop(context)
              : _next,
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
          child: Text(
            working
                ? 'Moving…'
                : step == 2
                ? 'Confirm move'
                : step == 3
                ? 'Done'
                : 'Continue',
          ),
        ),
      ],
    ),
  );

  Future<void> _next() async {
    if (step == 1 && selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a socket to continue.')),
      );
      return;
    }
    if (step == 2 && selected != null) {
      setState(() => working = true);
      try {
        await widget.repository.moveAppliance(
          widget.appliance.socketId!,
          selected!,
        );
        widget.onChanged();
        if (mounted) setState(() => step++);
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not move appliance: $error')),
          );
        }
      } finally {
        if (mounted) setState(() => working = false);
      }
      return;
    }
    setState(() => step++);
  }
}
