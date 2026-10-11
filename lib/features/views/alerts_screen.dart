import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/sems_models.dart';
import '../../data/repositories/sems_repository.dart';
import '../../shared/widgets/sems_widgets.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key, required this.repository});
  final SemsRepository repository;
  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String selected = 'All';
  late Future<AlertPreferences> _preferences;

  @override
  void initState() {
    super.initState();
    _preferences = widget.repository.getAlertPreferences();
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
    final alerts = widget.repository.alerts
        .where(
          (alert) => selected == 'All'
              ? alert.category != AlertCategory.ai
              : _filterFor(alert) == selected,
        )
        .toList();
    final newCount = widget.repository.alerts
        .where((a) => !a.acknowledged && a.category != AlertCategory.ai)
        .length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts'),
        actions: [
          IconButton(
            tooltip: 'Alert settings',
            onPressed: _settings,
            icon: const Icon(Icons.tune_rounded),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: _OwnerBadge(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Text(
            '$newCount need attention',
            style: const TextStyle(fontSize: 12, color: SemsColors.muted),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final filter in filters)
                  Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: ChoiceChip(
                      selected: selected == filter,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(filter),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: selected == filter
                                  ? Colors.white
                                  : SemsColors.canvas,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Text(
                              '${_countFor(filter)}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      onSelected: (_) => setState(() => selected = filter),
                    ),
                  ),
              ],
            ),
          ),
          if (selected == 'AI')
            const AppCard(
              child: Text(
                'AI alerts are estimates based on local sample history; they are informational, not electrical faults.',
                style: TextStyle(color: SemsColors.muted, fontSize: 12),
              ),
            ),
          FutureBuilder<AlertPreferences>(
            future: _preferences,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return AppCard(
                  child: Text(
                    'Unable to load alert preferences: ${snapshot.error}',
                    style: const TextStyle(color: SemsColors.red, fontSize: 12),
                  ),
                );
              }
              return snapshot.data?.muteNonCriticalAlerts == true
                  ? AppCard(
                      child: Text(
                        'Quiet hours are on (${snapshot.data!.quietHoursStart} to ${snapshot.data!.quietHoursEnd}). Critical safety alerts always come through.',
                        style: const TextStyle(
                          color: SemsColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 12),
          if (alerts.isEmpty)
            const AppCard(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 36,
                      color: SemsColors.muted,
                    ),
                    SizedBox(height: 10),
                    Text('No alerts in this category'),
                    Text(
                      'You are all caught up.',
                      style: TextStyle(color: SemsColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
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
          const SizedBox(height: 6),
          const AppCard(
            child: Text(
              'Alerts use sample local data. No monitoring service or push notifications are connected.',
              style: TextStyle(color: SemsColors.muted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  int _countFor(String filter) => widget.repository.alerts
      .where(
        (alert) => filter == 'All'
            ? alert.category != AlertCategory.ai
            : _filterFor(alert) == filter,
      )
      .length;

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
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(alert.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(alert.device, style: const TextStyle(color: SemsColors.muted)),
            const SizedBox(height: 14),
            Text(alert.message, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 10),
            Text(
              alert.time,
              style: const TextStyle(color: SemsColors.muted, fontSize: 11),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () {
                unawaited(_acknowledge(alert));
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(alert.acknowledged ? 'Acknowledged' : 'Acknowledge'),
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> _settings() => showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => _AlertSettingsSheet(
      repository: widget.repository,
      onSaved: () {
        setState(() => _preferences = widget.repository.getAlertPreferences());
      },
    ),
  );
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
    final color = switch (alert.severity) {
      AlertSeverity.critical => SemsColors.red,
      AlertSeverity.warning => SemsColors.amber,
      AlertSeverity.info => const Color(0xFF4C86E8),
    };
    final label = switch (alert.severity) {
      AlertSeverity.critical => 'Critical',
      AlertSeverity.warning => 'Warning',
      AlertSeverity.info => 'Info',
    };
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onOpen,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(left: BorderSide(color: color, width: 4)),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D101614),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .13),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    '△ $label',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  alert.time,
                  style: const TextStyle(color: SemsColors.muted, fontSize: 10),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Text(
              alert.title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 3),
            Text(
              alert.device,
              style: const TextStyle(color: SemsColors.muted, fontSize: 11),
            ),
            const SizedBox(height: 6),
            Text(
              alert.message,
              style: const TextStyle(fontSize: 12, height: 1.45),
            ),
            const SizedBox(height: 9),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: isAcknowledged ? null : onAcknowledge,
                style: TextButton.styleFrom(
                  backgroundColor: isAcknowledged
                      ? SemsColors.canvas
                      : SemsColors.mint,
                  foregroundColor: SemsColors.ink,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 7,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  isAcknowledged ? '✓ Acknowledged' : 'Acknowledge',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
      for (final appliance
          in widget.repository.devices.map((d) => d.appliance).toSet()) {
        final initial = preferences.appliancePowerLimitsW[appliance];
        _applianceLimits[appliance] = TextEditingController(
          text: initial?.toString() ?? '',
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

  bool _validTime(String value) {
    final match = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$').firstMatch(value);
    return match != null;
  }

  Future<void> _save() async {
    final overall = int.tryParse(_overallLimit.text);
    final limits = <String, int>{};
    for (final entry in _applianceLimits.entries) {
      final value = int.tryParse(entry.value.text);
      if (value != null) limits[entry.key] = value;
    }
    if (overall == null ||
        overall <= 0 ||
        limits.values.any((value) => value <= 0) ||
        (_mute && (!_validTime(_start.text) || !_validTime(_end.text)))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter valid power limits and quiet-hour times.'),
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
          quietHoursStart: _start.text,
          quietHoursEnd: _end.text,
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
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _loadError != null
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Unable to load alert settings: $_loadError',
                style: const TextStyle(color: SemsColors.red),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Alert settings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  const Text('Overall power limit'),
                  TextField(
                    controller: _overallLimit,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Alert above',
                      suffixText: 'W',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
                      'Applies to the sum of all sockets',
                      style: TextStyle(color: SemsColors.muted, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Per appliance'),
                  for (final entry in _applianceLimits.entries)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(entry.key),
                      trailing: SizedBox(
                        width: 110,
                        child: TextField(
                          controller: entry.value,
                          textAlign: TextAlign.end,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(suffixText: 'W'),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  const Text('Quiet hours'),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Mute non-critical alerts'),
                    value: _mute,
                    onChanged: (value) => setState(() => _mute = value),
                  ),
                  if (_mute)
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _start,
                            decoration: const InputDecoration(
                              labelText: 'Start',
                              hintText: '22:00',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _end,
                            decoration: const InputDecoration(
                              labelText: 'End',
                              hintText: '06:00',
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 14),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: Text(_saving ? 'Saving…' : 'Save'),
                  ),
                ],
              ),
            ),
    ),
  );
}

class _OwnerBadge extends StatelessWidget {
  const _OwnerBadge();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: SemsColors.mint,
      borderRadius: BorderRadius.circular(18),
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
