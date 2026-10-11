import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/services/id_generator.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/sems_repository.dart';
import '../../domain/models/command_progress.dart';
import '../../domain/models/schedule_record.dart';
import '../../domain/models/schedule_window.dart';
import '../../shared/widgets/sems_widgets.dart';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({super.key, required this.repository});

  final SemsRepository repository;

  @override
  State<SchedulesScreen> createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  List<ScheduleRecord> _schedules = const [];
  SchedulePauseState _pauseState = const SchedulePauseState(paused: false);
  bool _loading = true;
  Object? _error;
  final Set<String> _countdownsInFlight = {};
  Timer? _countdownTicker;

  @override
  void initState() {
    super.initState();
    _load();
    _countdownTicker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _tickCountdowns(),
    );
  }

  @override
  void dispose() {
    _countdownTicker?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final values = await Future.wait<Object>([
        widget.repository.getSchedules(),
        widget.repository.getSchedulePauseState(),
      ]);
      if (!mounted) return;
      setState(() {
        _schedules = List<ScheduleRecord>.of(
          values[0] as List<ScheduleRecord>,
        )..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        _pauseState = values[1] as SchedulePauseState;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
    _tickCountdowns();
  }

  void _tickCountdowns() {
    if (!mounted || _loading || _error != null) return;
    final now = DateTime.now();
    final paused =
        _pauseState.paused &&
        (_pauseState.until == null || _pauseState.until!.isAfter(now));
    if (paused) {
      setState(() {});
      return;
    }
    for (final schedule in _schedules) {
      if (schedule.kind != 'countdown' ||
          !schedule.enabled ||
          schedule.countdownState != 'running' ||
          _countdownsInFlight.contains(schedule.id)) {
        continue;
      }
      final endsAt = DateTime.tryParse(schedule.countdownEndsAt ?? '');
      if (endsAt == null || !now.isBefore(endsAt)) {
        _expireCountdown(schedule);
      }
    }
    setState(() {});
  }

  Future<void> _expireCountdown(ScheduleRecord schedule) async {
    if (!_countdownsInFlight.add(schedule.id)) return;
    var result = 'failed';
    String? failure;
    try {
      final socketId = schedule.socketId;
      if (socketId == null) {
        throw StateError('Countdown has no assigned socket.');
      }
      final endsAt = DateTime.tryParse(schedule.countdownEndsAt ?? '');
      if (endsAt == null) {
        throw StateError('Countdown has no valid expiry time.');
      }
      await for (final progress in widget.repository.runCommand(
        socketId: socketId,
        targetRelay: false,
      )) {
        if (progress.state == CommandState.executed) {
          result = 'completed';
        } else if (progress.state == CommandState.failed ||
            progress.state == CommandState.expired ||
            progress.state == CommandState.blocked) {
          failure = progress.message ?? 'The socket did not turn off.';
        }
      }
      if (result != 'completed') {
        failure ??= 'The socket did not confirm the auto-off command.';
        result = 'failed';
      }
      final updated = schedule.copyWith(countdownState: result);
      await widget.repository.saveSchedule(updated);
      if (!mounted) return;
      setState(() {
        _schedules = [
          for (final item in _schedules)
            if (item.id == updated.id) updated else item,
        ];
      });
      if (failure != null) _showError('Countdown auto-off failed', failure);
    } catch (error) {
      final updated = schedule.copyWith(countdownState: 'failed');
      try {
        await widget.repository.saveSchedule(updated);
      } catch (saveError) {
        if (mounted) {
          _showError('Could not save countdown failure state', saveError);
        }
      }
      if (mounted) {
        setState(() {
          _schedules = [
            for (final item in _schedules)
              if (item.id == updated.id) updated else item,
          ];
        });
        _showError('Countdown auto-off failed', error);
      }
    } finally {
      _countdownsInFlight.remove(schedule.id);
    }
  }

  Future<void> _edit([ScheduleRecord? existing]) async {
    final result = await Navigator.of(context).push<ScheduleRecord>(
      MaterialPageRoute(
        builder: (_) => _ScheduleEditorScreen(
          repository: widget.repository,
          existing: existing,
          schedules: _schedules,
        ),
      ),
    );
    if (result == null || !mounted) return;
    try {
      await widget.repository.saveSchedule(result);
      await _load();
    } catch (error) {
      _showError('Could not save schedule', error);
    }
  }

  Future<void> _toggle(ScheduleRecord schedule, bool enabled) async {
    try {
      await widget.repository.saveSchedule(schedule.copyWith(enabled: enabled));
      await _load();
    } catch (error) {
      _showError('Could not update schedule', error);
    }
  }

  Future<void> _delete(ScheduleRecord schedule) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete schedule?'),
        content: Text('“${schedule.name}” will be removed from this device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await widget.repository.deleteSchedule(schedule.id);
      await _load();
    } catch (error) {
      _showError('Could not delete schedule', error);
    }
  }

  Future<void> _pause() async {
    final selection = await showModalBottomSheet<_PauseSelection>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Pause schedules',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sockets stay in their current state. Manual control remains available.',
                  style: TextStyle(color: SemsColors.muted),
                ),
                const SizedBox(height: 14),
                for (final option in <(String, _PauseSelection)>[
                  ('For 1 day', const _PauseSelection(Duration(days: 1))),
                  ('For 3 days', const _PauseSelection(Duration(days: 3))),
                  ('For 7 days', const _PauseSelection(Duration(days: 7))),
                  ('Until I resume', const _PauseSelection(null)),
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: FilledButton.tonal(
                      onPressed: () => Navigator.pop(context, option.$2),
                      child: Text(option.$1),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    if (selection == null) return;
    try {
      await widget.repository.pauseSchedules(duration: selection.duration);
      await _load();
    } catch (error) {
      _showError('Could not pause schedules', error);
    }
  }

  Future<void> _resume() async {
    try {
      await widget.repository.resumeSchedules();
      await _load();
    } catch (error) {
      _showError('Could not resume schedules', error);
    }
  }

  void _showError(String action, Object error) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$action: $error')));
  }

  @override
  Widget build(BuildContext context) {
    final paused =
        _pauseState.paused &&
        (_pauseState.until == null ||
            _pauseState.until!.isAfter(DateTime.now()));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedules'),
        actions: [
          IconButton(
            onPressed: _edit,
            tooltip: 'Add schedule',
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _LoadError(error: _error!, onRetry: _load)
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const PageHeading(
                  title: 'Timers & schedules',
                  subtitle: 'Automate your device routines',
                ),
                const SizedBox(height: 16),
                if (paused)
                  AppCard(
                    child: Row(
                      children: [
                        const Icon(Icons.pause_circle_outline_rounded),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _pauseState.until == null
                                ? 'Schedules paused until you resume'
                                : 'Schedules paused until ${_formatDate(_pauseState.until!)}',
                          ),
                        ),
                        TextButton(
                          onPressed: _resume,
                          child: const Text('Resume now'),
                        ),
                      ],
                    ),
                  ),
                AppCard(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: SemsColors.forest,
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Schedules run on the socket, even when your phone is offline.',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_schedules.any((s) => !s.enabled)) ...[
                  const SizedBox(height: 10),
                  const AppCard(
                    child: Text(
                      'Some schedules are turned off.',
                      style: TextStyle(color: SemsColors.muted),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                if (_schedules.isEmpty)
                  AppCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.event_available_rounded,
                            size: 36,
                            color: SemsColors.muted,
                          ),
                          const SizedBox(height: 8),
                          const Text('No schedules yet'),
                          const Text(
                            'Create a schedule to automate a device.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: SemsColors.muted,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: _edit,
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Create schedule'),
                          ),
                        ],
                      ),
                    ),
                  ),
                for (final schedule in _schedules)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ScheduleCard(
                      schedule: schedule,
                      appliance: widget.repository.appliances
                          .where((item) => item.id == schedule.applianceId)
                          .firstOrNull
                          ?.name,
                      onTap: () => _edit(schedule),
                      onToggle: (enabled) => _toggle(schedule, enabled),
                      onDelete: () => _delete(schedule),
                    ),
                  ),
                if (_schedules.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: paused ? _resume : _pause,
                    icon: Icon(
                      paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                    ),
                    label: Text(
                      paused ? 'Resume all schedules' : 'Pause all (holiday)',
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    onPressed: _edit,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Create schedule'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.schedule,
    required this.appliance,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  final ScheduleRecord schedule;
  final String? appliance;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final intervals = schedule.intervals.isEmpty
        ? [
            ScheduleInterval(
              startTime: schedule.startTime,
              endTime: schedule.endTime,
            ),
          ]
        : schedule.intervals;
    final times = intervals
        .map((item) {
          final overnight =
              _minutes(item.endTime) <= _minutes(item.startTime) ||
              schedule.overnight;
          return '${item.startTime}–${item.endTime}${overnight ? '  +1d' : ''}';
        })
        .join(' · ');
    return AppCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    schedule.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Switch.adaptive(value: schedule.enabled, onChanged: onToggle),
              ],
            ),
            Text(
              '${appliance ?? 'Device'} · ${_daySummary(schedule)}',
              style: const TextStyle(color: SemsColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              schedule.kind == 'countdown' ? _countdownLabel(schedule) : times,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            if (schedule.kind == 'oneTime' && schedule.scheduledDate != null)
              Text(
                'On ${_formatScheduleDate(schedule.scheduledDate!)}',
                style: const TextStyle(color: SemsColors.muted, fontSize: 12),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: onDelete,
                tooltip: 'Delete schedule',
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Schedules could not be loaded.'),
          const SizedBox(height: 6),
          Text(
            '$error',
            textAlign: TextAlign.center,
            style: const TextStyle(color: SemsColors.muted, fontSize: 12),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    ),
  );
}

class _ScheduleEditorScreen extends StatefulWidget {
  const _ScheduleEditorScreen({
    required this.repository,
    required this.schedules,
    this.existing,
  });

  final SemsRepository repository;
  final List<ScheduleRecord> schedules;
  final ScheduleRecord? existing;

  @override
  State<_ScheduleEditorScreen> createState() => _ScheduleEditorScreenState();
}

class _ScheduleEditorScreenState extends State<_ScheduleEditorScreen> {
  static const _dayNames = <String>['M', 'Tu', 'W', 'Th', 'F', 'Sa', 'Su'];
  static const _dayValues = <String>[
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];
  static const _types = <(String, String)>[
    ('countdown', 'Countdown'),
    ('oneTime', 'One-time'),
    ('daily', 'Daily'),
    ('weekly', 'Weekly'),
    ('multipleIntervals', 'Multiple intervals'),
    ('overnight', 'Overnight'),
  ];
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _countdown;
  late String _kind;
  late String? _applianceId;
  late Set<String> _selectedDays;
  late bool _enabled;
  late bool _resumeAtNextInterval;
  late DateTime? _date;
  late List<_EditableInterval> _intervals;
  bool _clockSynced = true;
  bool _checkingClock = false;

  bool get _usesDays =>
      _kind == 'weekly' || _kind == 'multipleIntervals' || _kind == 'overnight';
  bool get _multiple => _kind == 'multipleIntervals';

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _name = TextEditingController(text: existing?.name ?? '');
    _countdown = TextEditingController(
      text: existing?.countdownMinutes?.toString() ?? '30',
    );
    _kind = existing?.kind ?? 'daily';
    _applianceId =
        existing?.applianceId ??
        widget.repository.appliances
            .where((item) => !item.archived && item.socketId != null)
            .firstOrNull
            ?.id;
    _selectedDays = existing == null
        ? {'monday', 'tuesday', 'wednesday', 'thursday', 'friday'}
        : existing.days.toSet();
    _enabled = existing?.enabled ?? true;
    _resumeAtNextInterval = existing?.manualOverride != 'stayOverridden';
    _date = existing?.scheduledDate == null
        ? DateTime.now().add(const Duration(days: 1))
        : DateTime.tryParse(existing!.scheduledDate!);
    final savedIntervals = existing?.intervals ?? const <ScheduleInterval>[];
    _intervals = [
      for (final interval in savedIntervals)
        _EditableInterval(interval.startTime, interval.endTime),
    ];
    if (_intervals.isEmpty) {
      _intervals = [
        _EditableInterval(
          existing?.startTime ?? '06:00',
          existing?.endTime ?? '08:00',
        ),
        if (_kind == 'multipleIntervals')
          const _EditableInterval('18:00', '22:00'),
      ];
    }
    _refreshClockSync();
  }

  @override
  void dispose() {
    _name.dispose();
    _countdown.dispose();
    super.dispose();
  }

  Future<void> _refreshClockSync() async {
    final applianceId = _applianceId;
    if (applianceId == null) {
      setState(() => _clockSynced = false);
      return;
    }
    setState(() => _checkingClock = true);
    try {
      final synced = await widget.repository.isScheduleClockSynced(applianceId);
      if (!mounted) return;
      setState(() {
        _clockSynced = synced;
        _checkingClock = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _checkingClock = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not check socket time sync: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appliances = widget.repository.appliances
        .where((item) => !item.archived && item.socketId != null)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'New schedule' : 'Edit schedule'),
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'e.g. Evening heater',
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Enter a name' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _applianceId,
              decoration: const InputDecoration(labelText: 'Appliance'),
              items: [
                for (final appliance in appliances)
                  DropdownMenuItem(
                    value: appliance.id,
                    child: Text(
                      '${appliance.name} · ${_socketName(appliance.socketId)}',
                    ),
                  ),
              ],
              onChanged: (value) {
                setState(() => _applianceId = value);
                _refreshClockSync();
              },
            ),
            const SizedBox(height: 18),
            const Text('Type', style: TextStyle(color: SemsColors.muted)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final type in _types)
                  ChoiceChip(
                    label: Text(type.$2),
                    selected: _kind == type.$1,
                    onSelected: (_) => setState(() => _kind = type.$1),
                  ),
              ],
            ),
            if (_kind == 'countdown') ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _countdown,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Run for (minutes)',
                ),
                validator: (value) {
                  final minutes = int.tryParse(value ?? '');
                  return minutes == null || minutes < 1 || minutes > 10080
                      ? 'Enter a duration from 1 to 10080 minutes'
                      : null;
                },
              ),
            ],
            if (_kind == 'oneTime') ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_month_rounded),
                label: Text('Date · ${_formatDate(_date!)}'),
              ),
            ],
            if (_usesDays) ...[
              const SizedBox(height: 16),
              const Text('Days', style: TextStyle(color: SemsColors.muted)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 5,
                children: [
                  for (var index = 0; index < _dayNames.length; index++)
                    ChoiceChip(
                      label: Text(_dayNames[index]),
                      selected: _selectedDays.contains(_dayValues[index]),
                      onSelected: (selected) => setState(() {
                        if (selected) {
                          _selectedDays.add(_dayValues[index]);
                        } else {
                          _selectedDays.remove(_dayValues[index]);
                        }
                      }),
                    ),
                ],
              ),
            ],
            if (_kind != 'countdown') ...[
              const SizedBox(height: 16),
              Text(
                _kind == 'overnight'
                    ? 'ON from, OFF next day'
                    : 'ON from, OFF at',
                style: const TextStyle(color: SemsColors.muted),
              ),
              const SizedBox(height: 8),
              for (var index = 0; index < _intervals.length; index++)
                _intervalRow(index),
              if (_multiple)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _intervals.length >= 8
                        ? null
                        : () => setState(
                            () => _intervals.add(
                              const _EditableInterval('12:00', '13:00'),
                            ),
                          ),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add interval'),
                  ),
                ),
            ],
            if (!_clockSynced && !_checkingClock)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: AppCard(
                  child: Text(
                    'Waiting for time sync. This socket needs a valid clock before schedules can run.',
                    style: TextStyle(color: SemsColors.muted),
                  ),
                ),
              ),
            if (_kind != 'countdown' && _kind != 'oneTime') ...[
              const SizedBox(height: 16),
              const Text(
                'If you switch it manually',
                style: TextStyle(color: SemsColors.muted),
              ),
              RadioGroup<bool>(
                groupValue: _resumeAtNextInterval,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _resumeAtNextInterval = value);
                  }
                },
                child: const Column(
                  children: [
                    RadioListTile<bool>(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      value: true,
                      title: Text('Resume at the next interval'),
                      subtitle: Text(
                        'Your manual change lasts until the scheduled interval.',
                      ),
                    ),
                    RadioListTile<bool>(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      value: false,
                      title: Text('Stay overridden'),
                      subtitle: Text(
                        'The schedule will not change the socket until re-enabled.',
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Enabled'),
              subtitle: const Text('Time zone: IST (UTC+05:30)'),
              value: _enabled,
              onChanged: (value) => setState(() => _enabled = value),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: FilledButton(
          onPressed: _save,
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
          child: const Text('Save schedule'),
        ),
      ),
    );
  }

  Widget _intervalRow(int index) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _pickTime(index, true),
            child: Text(_intervals[index].start),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.chevron_right_rounded),
        ),
        Expanded(
          child: OutlinedButton(
            onPressed: () => _pickTime(index, false),
            child: Text(_intervals[index].end),
          ),
        ),
        if (_multiple)
          IconButton(
            tooltip: 'Remove interval',
            onPressed: _intervals.length == 1
                ? null
                : () => setState(() => _intervals.removeAt(index)),
            icon: const Icon(Icons.close_rounded),
          ),
      ],
    ),
  );

  Future<void> _pickTime(int index, bool start) async {
    final value = start ? _intervals[index].start : _intervals[index].end;
    final parts = value.split(':');
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      ),
    );
    if (selected == null || !mounted) return;
    final time =
        '${selected.hour.toString().padLeft(2, '0')}:${selected.minute.toString().padLeft(2, '0')}';
    setState(() {
      _intervals[index] = start
          ? _EditableInterval(time, _intervals[index].end)
          : _EditableInterval(_intervals[index].start, time);
    });
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date!,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null && mounted) setState(() => _date = date);
  }

  String _socketName(String? id) =>
      widget.repository.devices
          .where((device) => device.id == id)
          .firstOrNull
          ?.name ??
      'Socket';

  void _save() {
    if (!_form.currentState!.validate()) return;
    if (_applianceId == null) {
      _showValidation('Assign an appliance to an online socket first.');
      return;
    }
    if (_usesDays && _selectedDays.isEmpty) {
      _showValidation('Select at least one day.');
      return;
    }
    final intervals = _kind == 'countdown'
        ? const <_EditableInterval>[]
        : _multiple
        ? _intervals
        : [_intervals.first];
    if (_kind != 'overnight' &&
        intervals.any((item) => _minutes(item.end) <= _minutes(item.start))) {
      _showValidation('Each OFF time must be later than its ON time.');
      return;
    }
    if (!_validateOverlap(intervals)) return;
    final first = intervals.firstOrNull;
    final appliance = widget.repository.appliances
        .where((item) => item.id == _applianceId)
        .firstOrNull;
    final days = switch (_kind) {
      'daily' => _dayValues,
      'countdown' || 'oneTime' => const <String>[],
      _ => _dayValues.where(_selectedDays.contains).toList(),
    };
    final record = ScheduleRecord(
      id: widget.existing?.id ?? RandomIdGenerator().nextId(),
      name: _name.text.trim(),
      applianceId: _applianceId!,
      socketId: appliance?.socketId,
      startTime: first?.start ?? '00:00',
      endTime: first?.end ?? '00:00',
      scheduledDate: _kind == 'oneTime' ? _date!.toIso8601String() : null,
      countdownMinutes: _kind == 'countdown'
          ? int.parse(_countdown.text)
          : null,
      countdownEndsAt: _kind == 'countdown'
          ? DateTime.now()
                .add(Duration(minutes: int.parse(_countdown.text)))
                .toIso8601String()
          : null,
      countdownState: _kind == 'countdown' ? 'running' : 'idle',
      days: days,
      intervals: [
        for (final interval in intervals)
          ScheduleInterval(startTime: interval.start, endTime: interval.end),
      ],
      enabled: _enabled,
      kind: _kind,
      overnight:
          _kind == 'overnight' ||
          intervals.any((item) => _minutes(item.end) <= _minutes(item.start)),
      manualOverride: _resumeAtNextInterval
          ? 'resumeAtNextInterval'
          : 'stayOverridden',
    );
    Navigator.pop(context, record);
  }

  bool _validateOverlap(List<_EditableInterval> intervals) {
    if (_kind == 'countdown' || _kind == 'oneTime') return true;
    final days = _dayNumbers(_kind == 'daily' ? _dayValues : _selectedDays);
    final windows = <ScheduleWindow>[
      for (final interval in intervals)
        ScheduleWindow(
          startMinute: _minutes(interval.start),
          endMinute: _minutes(interval.end),
          days: days,
        ),
    ];
    for (final other in widget.schedules) {
      if (!other.enabled ||
          other.id == widget.existing?.id ||
          other.applianceId != _applianceId ||
          other.kind == 'countdown' ||
          other.kind == 'oneTime') {
        continue;
      }
      final otherIntervals = other.intervals.isEmpty
          ? [
              ScheduleInterval(
                startTime: other.startTime,
                endTime: other.endTime,
              ),
            ]
          : other.intervals;
      for (final interval in otherIntervals) {
        windows.add(
          ScheduleWindow(
            startMinute: _minutes(interval.startTime),
            endMinute: _minutes(interval.endTime),
            days: _dayNumbers(other.days),
          ),
        );
      }
    }
    final validation = validateScheduleWindows(windows);
    if (!validation.isValid) {
      _showValidation(validation.error!);
      return false;
    }
    return true;
  }

  void _showValidation(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _EditableInterval {
  const _EditableInterval(this.start, this.end);

  final String start;
  final String end;
}

class _PauseSelection {
  const _PauseSelection(this.duration);

  final Duration? duration;
}

int _minutes(String time) {
  final parts = time.split(':');
  return int.parse(parts[0]) * 60 + int.parse(parts[1]);
}

Set<int> _dayNumbers(Iterable<String> days) => {
  for (final day in days)
    if (_dayIndex(day) >= 0) _dayIndex(day) + 1,
};

int _dayIndex(String day) => const [
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
  'sunday',
].indexOf(day);

String _daySummary(ScheduleRecord schedule) {
  if (schedule.kind == 'countdown') return 'One-time countdown';
  if (schedule.kind == 'oneTime') return 'One-time';
  if (schedule.days.length == 7) return 'Every day';
  if (schedule.days.length == 5 &&
      schedule.days.take(5).toSet().containsAll(const [
        'monday',
        'tuesday',
        'wednesday',
        'thursday',
        'friday',
      ])) {
    return 'Mon to Fri';
  }
  return schedule.days
      .map((day) => day.substring(0, 1).toUpperCase())
      .join(', ');
}

String _formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

String _formatScheduleDate(String value) {
  final date = DateTime.tryParse(value);
  return date == null ? value : _formatDate(date);
}

String _countdownLabel(ScheduleRecord schedule) {
  switch (schedule.countdownState) {
    case 'completed':
      return 'Countdown complete · socket is off';
    case 'failed':
      return 'Countdown ended · auto-off failed';
    case 'running':
      final endsAt = DateTime.tryParse(schedule.countdownEndsAt ?? '');
      if (endsAt == null) return 'Countdown · time unavailable';
      final seconds = endsAt.difference(DateTime.now()).inSeconds;
      if (seconds <= 0) return 'Turning off…';
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      return 'Turn OFF in ${minutes}m ${remainingSeconds.toString().padLeft(2, '0')}s';
    default:
      return 'Countdown · ${schedule.countdownMinutes ?? 0} min';
  }
}
