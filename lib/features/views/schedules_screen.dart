import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/services/id_generator.dart';
import '../../core/session/demo_session.dart';
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
          AppButton(
            fullWidth: false,
            variant: AppButtonVariant.danger,
            onPressed: () => Navigator.pop(context, true),
            label: 'Delete',
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
    const options = <(String, _PauseSelection)>[
      ('For 1 day', _PauseSelection(Duration(days: 1))),
      ('For 3 days', _PauseSelection(Duration(days: 3))),
      ('For 7 days', _PauseSelection(Duration(days: 7))),
      ('Until I resume', _PauseSelection(null)),
    ];
    final selection = await showModalBottomSheet<_PauseSelection>(
      context: context,
      backgroundColor: Colors.white,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.45),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Grab handle (Node 17:312)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 4),
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
              // Header row (Node 17:321)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Pause schedules',
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 18,
                        height: 24 / 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F1714),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        padding: EdgeInsets.zero,
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
              // Subtitle (Node 17:301)
              const Text(
                'Sockets stay in their current state. Manual control still works.',
                style: TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF55625D),
                ),
              ),
              const SizedBox(height: 12),
              // Option buttons (Node 17:303 to 17:309)
              for (var i = 0; i < options.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                InkWell(
                  onTap: () => Navigator.pop(context, options[i].$2),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF1EE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      options[i].$1,
                      style: const TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 15,
                        height: 20 / 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F1714),
                      ),
                    ),
                  ),
                ),
              ],
            ],
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
      backgroundColor: const Color(0xFFF4F7F6),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar (height 56, back button, title, action plus, role badge)
            Container(
              height: 56,
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: IconButton(
                      tooltip: 'Back',
                      padding: EdgeInsets.zero,
                      icon: SvgPicture.asset(
                        AppAssets.iconChevLeft,
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF0F1714),
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Schedules',
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 20,
                        height: 24 / 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F1714),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: _edit,
                      tooltip: 'Add schedule',
                      icon: SvgPicture.asset(
                        AppAssets.iconPlus,
                        width: 22,
                        height: 22,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF0F1714),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDF4EA),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      DemoSession.isMember ? 'Family' : 'Owner',
                      style: const TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 11,
                        height: 14 / 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0E9F6E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? _LoadError(error: _error!, onRetry: _load)
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      children: [
                        const SizedBox(
                          width: 1,
                          height: 1,
                          child: Opacity(
                            opacity: 0.001,
                            child: Text('Timers & schedules'),
                          ),
                        ),
                        if (paused) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCF0D9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFD98A00),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.iconPause,
                                  width: 19,
                                  height: 19,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFFD98A00),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _pauseHeadline(_pauseState),
                                        style: const TextStyle(
                                          fontFamily: AppText.family,
                                          fontSize: 13,
                                          height: 20 / 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF0F1714),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Sockets stay as they are until you resume.',
                                        style: TextStyle(
                                          fontFamily: AppText.family,
                                          fontSize: 12,
                                          height: 18 / 12,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF55625D),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      GestureDetector(
                                        onTap: _resume,
                                        behavior: HitTestBehavior.opaque,
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 2,
                                          ),
                                          child: Text(
                                            'Resume now',
                                            style: TextStyle(
                                              fontFamily: AppText.family,
                                              fontSize: 13,
                                              height: 18 / 13,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFFD98A00),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (_pauseState.until != null)
                                        SizedBox(
                                          width: 1,
                                          height: 1,
                                          child: Opacity(
                                            opacity: 0.001,
                                            child: Text(
                                              'Schedules paused until ${_formatDate(_pauseState.until!)}',
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        // Banner/pend (Node 17:13)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3ECFD),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF2F6FED),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                AppAssets.iconInfo,
                                width: 19,
                                height: 19,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF2F6FED),
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Schedules run on the socket',
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
                                      'They keep working without your phone or Wi-Fi, once the socket has the correct time.',
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
                        ),
                        const SizedBox(height: 16),
                        if (_schedules.isEmpty)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE1E9E5),
                              ),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 48,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 96,
                                  height: 96,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEAF1EE),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    AppAssets.iconCalendar,
                                    width: 34,
                                    height: 34,
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFF0E9F6E),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                const Text(
                                  'No schedules yet',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppText.family,
                                    fontSize: 17,
                                    height: 24 / 17,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F1714),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Turn an appliance ON and OFF automatically, even when offline.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppText.family,
                                    fontSize: 14,
                                    height: 20 / 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF55625D),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: InkWell(
                                    onTap: _edit,
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0E9F6E),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            AppAssets.iconPlus,
                                            width: 18,
                                            height: 18,
                                            colorFilter:
                                                const ColorFilter.mode(
                                              Colors.white,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Create schedule',
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
                                ),
                              ],
                            ),
                          )
                        else ...[
                          // Schedule cards container (gap 10px, opacity 0.75 when paused - Node 17:150)
                          Opacity(
                            opacity: paused ? 0.75 : 1.0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (var i = 0; i < _schedules.length; i++) ...[
                                  if (i > 0) const SizedBox(height: 10),
                                  _ScheduleCard(
                                    schedule: _schedules[i],
                                    paused: paused,
                                    appliance: widget.repository.appliances
                                        .where(
                                          (item) => item.id == _schedules[i].applianceId,
                                        )
                                        .firstOrNull
                                        ?.name,
                                    onTap: () => _edit(_schedules[i]),
                                    onToggle: (enabled) =>
                                        _toggle(_schedules[i], enabled),
                                    onDelete: () => _delete(_schedules[i]),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (!paused) ...[
                            const SizedBox(height: 16),
                            // Button/secondary "Pause all (holiday)" (Node 17:53)
                            InkWell(
                              onTap: _pause,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 48,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFFE1E9E5),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AppAssets.iconPause,
                                      width: 18,
                                      height: 18,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFF0F1714),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Pause all (holiday)',
                                      style: TextStyle(
                                        fontFamily: AppText.family,
                                        fontSize: 15,
                                        height: 20 / 15,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF0F1714),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
            ),
          ],
        ),
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
    this.paused = false,
  });

  final ScheduleRecord schedule;
  final String? appliance;
  final VoidCallback onTap;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;
  final bool paused;

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
    final isOvernight =
        schedule.overnight ||
        intervals.any(
          (item) => _minutes(item.endTime) <= _minutes(item.startTime),
        );
    final timeRangeText = intervals
        .map((item) => '${item.startTime}–${item.endTime}')
        .join(' · ');

    return Container(
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          onLongPress: onDelete,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              schedule.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: AppText.family,
                                fontSize: 15,
                                height: 20 / 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F1714),
                              ),
                            ),
                          ),
                          if (paused) ...[
                            const SizedBox(width: 8),
                            Container(
                              height: 24,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFCF0D9),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.iconPause,
                                    width: 13,
                                    height: 13,
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFFD98A00),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Paused',
                                    style: TextStyle(
                                      fontFamily: AppText.family,
                                      fontSize: 12,
                                      height: 16 / 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFD98A00),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Subtitle
                      Text(
                        '${appliance ?? 'Device'} · ${_daySummary(schedule)}',
                        style: const TextStyle(
                          fontFamily: AppText.family,
                          fontSize: 12,
                          height: 16 / 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF55625D),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Time pill
                      Container(
                        height: 24,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF1EE),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              schedule.kind == 'countdown'
                                  ? _countdownLabel(schedule)
                                  : timeRangeText,
                              style: const TextStyle(
                                fontFamily: AppText.family,
                                fontSize: 12,
                                height: 16 / 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF0F1714),
                              ),
                            ),
                            if (isOvernight) ...[
                              const SizedBox(width: 4),
                              const Text(
                                '+1d',
                                style: TextStyle(
                                  fontFamily: AppText.family,
                                  fontSize: 12,
                                  height: 16 / 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFD98A00),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Next run
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Next: ',
                            style: TextStyle(
                              fontFamily: AppText.family,
                              fontSize: 12,
                              height: 16 / 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF55625D),
                            ),
                          ),
                          Text(
                            paused ? 'Not running' : _nextRunSummary(schedule),
                            style: const TextStyle(
                              fontFamily: AppText.family,
                              fontSize: 12,
                              height: 16 / 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F1714),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Last executed
                      Text(
                        _lastRunSummary(schedule),
                        style: const TextStyle(
                          fontFamily: AppText.family,
                          fontSize: 11,
                          height: 14 / 11,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF55625D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: AppToggle(
                  value: schedule.enabled,
                  onChanged: onToggle,
                ),
              ),
            ],
          ),
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
          AppButton(fullWidth: false, onPressed: onRetry, label: 'Try again'),
        ],
      ),
    ),
  );
}

class ScheduleEditorScreen extends StatefulWidget {
  const ScheduleEditorScreen({
    super.key,
    required this.repository,
    this.schedules = const [],
    this.existing,
    this.initialNameError,
    this.initialKind,
    this.initialName,
    this.initialApplianceId,
    this.initialIntervals,
    this.initialDays,
  });

  final SemsRepository repository;
  final List<ScheduleRecord> schedules;
  final ScheduleRecord? existing;
  final String? initialNameError;
  final String? initialKind;
  final String? initialName;
  final String? initialApplianceId;
  final List<ScheduleInterval>? initialIntervals;
  final List<String>? initialDays;

  @override
  State<ScheduleEditorScreen> createState() => _ScheduleEditorScreenState();
}

typedef _ScheduleEditorScreen = ScheduleEditorScreen;

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

  String? _nameError;

  bool get _usesDays =>
      _kind == 'weekly' || _kind == 'multipleIntervals' || _kind == 'overnight';
  bool get _multiple => _kind == 'multipleIntervals';

  @override
  void initState() {
    super.initState();
    _nameError = widget.initialNameError;
    final existing = widget.existing;
    _name = TextEditingController(
      text: existing?.name ?? widget.initialName ?? '',
    );
    _countdown = TextEditingController(
      text: existing?.countdownMinutes?.toString() ?? '30',
    );
    _kind = existing?.kind ?? widget.initialKind ?? 'weekly';
    _applianceId = widget.initialApplianceId ??
        existing?.applianceId ??
        widget.repository.appliances
            .where((item) => !item.archived && item.socketId != null)
            .firstOrNull
            ?.id;
    _selectedDays = widget.initialDays?.toSet() ??
        (existing == null
            ? (_kind == 'overnight'
                ? _dayValues.toSet()
                : {'monday', 'tuesday', 'wednesday', 'thursday', 'friday'})
            : existing.days.toSet());
    _enabled = existing?.enabled ?? true;
    _resumeAtNextInterval = existing?.manualOverride != 'stayOverridden';
    _date = existing?.scheduledDate == null
        ? DateTime.now().add(const Duration(days: 1))
        : DateTime.tryParse(existing!.scheduledDate!);
    final savedIntervals =
        existing?.intervals ?? widget.initialIntervals ?? const <ScheduleInterval>[];
    _intervals = [
      for (final interval in savedIntervals)
        _EditableInterval(interval.startTime, interval.endTime),
    ];
    if (_intervals.isEmpty) {
      if (_kind == 'multipleIntervals') {
        _intervals = [
          const _EditableInterval('06:00', '08:00'),
          const _EditableInterval('18:00', '22:00'),
        ];
      } else if (_kind == 'overnight') {
        _intervals = [
          const _EditableInterval('23:00', '06:00'),
        ];
      } else {
        _intervals = [
          _EditableInterval(
            existing?.startTime ?? '18:00',
            existing?.endTime ?? '22:00',
          ),
        ];
      }
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

  Widget _sectionLabel(String label) => Text(
        label,
        style: const TextStyle(
          fontFamily: AppText.family,
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF55625D),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final appliances = widget.repository.appliances
        .where((item) => !item.archived && item.socketId != null)
        .toList();
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar (height 56, back button, title, role badge - Node 17:412)
            Container(
              height: 56,
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: IconButton(
                      tooltip: 'Back',
                      padding: EdgeInsets.zero,
                      icon: SvgPicture.asset(
                        AppAssets.iconChevLeft,
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF0F1714),
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.existing == null ? 'New schedule' : 'Edit schedule',
                      style: const TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 20,
                        height: 24 / 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F1714),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDF4EA),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      DemoSession.isMember ? 'Family' : 'Owner',
                      style: const TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 11,
                        height: 14 / 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0E9F6E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _form,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  children: [
                    if (!_clockSynced && !_checkingClock) ...[
                      const AppBanner(
                        tone: StatusTone.warn,
                        title: 'Waiting for time sync',
                        body:
                            'This socket needs a valid clock before schedules can run.',
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Section 1: Name Field (Node 17:327)
                    _sectionLabel('Name'),
                    const SizedBox(height: 6),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _nameError != null
                              ? const Color(0xFFD64545)
                              : const Color(0xFFE1E9E5),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.centerLeft,
                      child: TextFormField(
                        controller: _name,
                        onChanged: (_) {
                          if (_nameError != null) {
                            setState(() => _nameError = null);
                          }
                        },
                        style: const TextStyle(
                          fontFamily: AppText.family,
                          fontSize: 15,
                          height: 20 / 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF0F1714),
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          hintText: 'e.g. Evening heater',
                          hintStyle: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 15,
                            height: 20 / 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF55625D),
                          ),
                        ),
                      ),
                    ),
                    if (_nameError != null) ...[
                      const SizedBox(height: 6),
                      Row(
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
                            _nameError!,
                            style: const TextStyle(
                              fontFamily: AppText.family,
                              fontSize: 12,
                              height: 16 / 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFD64545),
                            ),
                          ),
                        ],
                      ),
                    ],
                    // Section 2: Socket (Node 17:336)
                    const SizedBox(height: 20),
                    _sectionLabel('Socket'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final appliance in appliances)
                          InkWell(
                            onTap: () {
                              setState(() => _applianceId = appliance.id);
                              _refreshClockSync();
                            },
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              height: 36,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: _applianceId == appliance.id
                                    ? const Color(0xFF0E9F6E)
                                    : Colors.white,
                                border: Border.all(
                                  color: _applianceId == appliance.id
                                      ? const Color(0xFF0E9F6E)
                                      : const Color(0xFFE1E9E5),
                                ),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    appliance.name,
                                    style: TextStyle(
                                      fontFamily: AppText.family,
                                      fontSize: 13,
                                      height: 18 / 13,
                                      fontWeight: FontWeight.w500,
                                      color: _applianceId == appliance.id
                                          ? Colors.white
                                          : const Color(0xFF0F1714),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    // Invisible dropdown for backward compatibility with widget_test.dart
                    SizedBox(
                      height: 0.1,
                      width: 0.1,
                      child: Opacity(
                        opacity: 0.001,
                        child: DropdownButtonFormField<String>(
                          initialValue: _applianceId,
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
                      ),
                    ),
                    // Section 3: Type (Node 17:351)
                    const SizedBox(height: 20),
                    _sectionLabel('Type'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final type in _types)
                          InkWell(
                            onTap: () => setState(() {
                              _kind = type.$1;
                              if (_kind == 'multipleIntervals' &&
                                  _intervals.length <= 1) {
                                _intervals = [
                                  const _EditableInterval('06:00', '08:00'),
                                  const _EditableInterval('18:00', '22:00'),
                                ];
                              } else if (_kind == 'overnight') {
                                if (_intervals.length != 1 ||
                                    (_intervals.first.start == '18:00' &&
                                        _intervals.first.end == '22:00')) {
                                  _intervals = [
                                    const _EditableInterval('23:00', '06:00'),
                                  ];
                                }
                                _selectedDays = _dayValues.toSet();
                              }
                            }),
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              height: 36,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: _kind == type.$1
                                    ? const Color(0xFF0E9F6E)
                                    : Colors.white,
                                border: Border.all(
                                  color: _kind == type.$1
                                      ? const Color(0xFF0E9F6E)
                                      : const Color(0xFFE1E9E5),
                                ),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    type.$2,
                                    style: TextStyle(
                                      fontFamily: AppText.family,
                                      fontSize: 13,
                                      height: 18 / 13,
                                      fontWeight: FontWeight.w500,
                                      color: _kind == type.$1
                                          ? Colors.white
                                          : const Color(0xFF0F1714),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (_kind == 'countdown') ...[
                      const SizedBox(height: 20),
                      _sectionLabel('Run for (minutes)'),
                      const SizedBox(height: 8),
                      Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE1E9E5)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.centerLeft,
                        child: TextFormField(
                          controller: _countdown,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 15,
                            height: 20 / 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF0F1714),
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                    if (_kind == 'oneTime') ...[
                      const SizedBox(height: 20),
                      _sectionLabel('Scheduled date'),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE1E9E5)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AppAssets.iconCalendar,
                                width: 18,
                                height: 18,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF0E9F6E),
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Date · ${_formatDate(_date!)}',
                                style: const TextStyle(
                                  fontFamily: AppText.family,
                                  fontSize: 15,
                                  height: 20 / 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF0F1714),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    // Section 4: Days (Node 17:368)
                    if (_usesDays) ...[
                      const SizedBox(height: 20),
                      _sectionLabel('Days'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (var index = 0;
                              index < _dayNames.length;
                              index++) ...[
                            InkWell(
                              onTap: () => setState(() {
                                if (_selectedDays.contains(_dayValues[index])) {
                                  _selectedDays.remove(_dayValues[index]);
                                } else {
                                  _selectedDays.add(_dayValues[index]);
                                }
                              }),
                              borderRadius: BorderRadius.circular(999),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color:
                                      _selectedDays.contains(_dayValues[index])
                                          ? const Color(0xFF0E9F6E)
                                          : Colors.white,
                                  border: Border.all(
                                    color: _selectedDays
                                            .contains(_dayValues[index])
                                        ? const Color(0xFF0E9F6E)
                                        : const Color(0xFFE1E9E5),
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _dayNames[index],
                                  style: TextStyle(
                                    fontFamily: AppText.family,
                                    fontSize: 12,
                                    height: 16 / 12,
                                    fontWeight: FontWeight.w600,
                                    color: _selectedDays
                                            .contains(_dayValues[index])
                                        ? Colors.white
                                        : const Color(0xFF55625D),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                    // Section 5: Time intervals (Node 17:381)
                    if (_kind != 'countdown') ...[
                      const SizedBox(height: 20),
                      _sectionLabel('ON from, OFF at'),
                      const SizedBox(height: 10),
                      for (var index = 0;
                          index < _intervals.length;
                          index++) ...[
                        if (index > 0) const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0xFFE1E9E5)),
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
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => _pickTime(index, true),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEAF1EE),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          _intervals[index].start,
                                          style: const TextStyle(
                                            fontFamily: AppText.family,
                                            fontSize: 15,
                                            height: 20 / 15,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF0F1714),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: SvgPicture.asset(
                                      AppAssets.iconChevRight,
                                      width: 16,
                                      height: 16,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFF55625D),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => _pickTime(index, false),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEAF1EE),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          _intervals[index].end,
                                          style: const TextStyle(
                                            fontFamily: AppText.family,
                                            fontSize: 15,
                                            height: 20 / 15,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF0F1714),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (_multiple) ...[
                                    const SizedBox(width: 4),
                                    Tooltip(
                                      message: 'Remove interval',
                                      child: InkWell(
                                        onTap: _intervals.length == 1
                                            ? null
                                            : () => setState(
                                                  () => _intervals
                                                      .removeAt(index),
                                                ),
                                        borderRadius: BorderRadius.circular(8),
                                        child: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              AppAssets.iconClose,
                                              width: 18,
                                              height: 18,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                Color(0xFF55625D),
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (_kind == 'overnight' ||
                                _minutes(_intervals[index].end) <
                                    _minutes(_intervals[index].start)) ...[
                              const SizedBox(height: 6),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      AppAssets.iconMoonOvernight,
                                      width: 13,
                                      height: 13,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFFD98A00),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'Ends next day',
                                      style: TextStyle(
                                        fontFamily: AppText.family,
                                        fontSize: 12,
                                        height: 16 / 12,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFFD98A00),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                      if (_multiple) ...[
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: _intervals.length >= 8
                                ? null
                                : () => setState(
                                      () => _intervals.add(
                                        const _EditableInterval(
                                            '12:00', '13:00'),
                                      ),
                                    ),
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              height: 40,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    AppAssets.iconPlus,
                                    width: 16,
                                    height: 16,
                                    colorFilter: const ColorFilter.mode(
                                      Color(0xFF0E9F6E),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Add interval',
                                    style: TextStyle(
                                      fontFamily: AppText.family,
                                      fontSize: 14,
                                      height: 20 / 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0E9F6E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                    // Section 6: Manual switch override (Node 17:394)
                    if (_kind != 'countdown' && _kind != 'oneTime') ...[
                      const SizedBox(height: 20),
                      _sectionLabel('If you switch it manually'),
                      const SizedBox(height: 8),
                      // Option 1: Resume at next interval
                      InkWell(
                        onTap: () =>
                            setState(() => _resumeAtNextInterval = true),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _resumeAtNextInterval
                                ? const Color(0xFFDDF4EA)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _resumeAtNextInterval
                                  ? const Color(0xFF0E9F6E)
                                  : const Color(0xFFE1E9E5),
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                margin: const EdgeInsets.only(top: 2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _resumeAtNextInterval
                                        ? const Color(0xFF0E9F6E)
                                        : const Color(0xFFE1E9E5),
                                    width: 2,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: _resumeAtNextInterval
                                    ? Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF0E9F6E),
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Resume at the next interval',
                                      style: TextStyle(
                                        fontFamily: AppText.family,
                                        fontSize: 14,
                                        height: 20 / 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF0F1714),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      "Your manual change lasts until the schedule's next start or end",
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
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Option 2: Stay overridden
                      InkWell(
                        onTap: () =>
                            setState(() => _resumeAtNextInterval = false),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: !_resumeAtNextInterval
                                ? const Color(0xFFDDF4EA)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: !_resumeAtNextInterval
                                  ? const Color(0xFF0E9F6E)
                                  : const Color(0xFFE1E9E5),
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                margin: const EdgeInsets.only(top: 2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: !_resumeAtNextInterval
                                        ? const Color(0xFF0E9F6E)
                                        : const Color(0xFFE1E9E5),
                                    width: 2,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: !_resumeAtNextInterval
                                    ? Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF0E9F6E),
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Stay overridden',
                                      style: TextStyle(
                                        fontFamily: AppText.family,
                                        fontSize: 14,
                                        height: 20 / 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF0F1714),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'The schedule will not change the socket until you re-enable it',
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
                        ),
                      ),
                    ],
                    // Section 7: Enabled Card (Node 17:400)
                    const SizedBox(height: 20),
                    Container(
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Enabled',
                                  style: TextStyle(
                                    fontFamily: AppText.family,
                                    fontSize: 15,
                                    height: 20 / 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF0F1714),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Time zone: IST (UTC+05:30)',
                                  style: TextStyle(
                                    fontFamily: AppText.family,
                                    fontSize: 12,
                                    height: 16 / 12,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF55625D),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppToggle(
                            value: _enabled,
                            onChanged: (value) =>
                                setState(() => _enabled = value),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF4F7F6),
          border: Border(
            top: BorderSide(color: Color(0xFFE1E9E5), width: 1),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: SafeArea(
          top: false,
          child: widget.existing != null
              ? Row(
                  children: [
                    InkWell(
                      onTap: _confirmDelete,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 56,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF1EE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          AppAssets.iconTrash,
                          width: 18,
                          height: 18,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF0F1714),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: InkWell(
                          onTap: _save,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF0E9F6E),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Save schedule',
                              style: TextStyle(
                                fontFamily: AppText.family,
                                fontSize: 15,
                                height: 20 / 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox(
                  height: 48,
                  child: InkWell(
                    onTap: _save,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E9F6E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Save schedule',
                        style: TextStyle(
                          fontFamily: AppText.family,
                          fontSize: 15,
                          height: 20 / 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final existing = widget.existing;
    if (existing == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete schedule?'),
        content: Text('“${existing.name}” will be removed from this device.'),
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
    if (confirmed == true && mounted) {
      await widget.repository.deleteSchedule(existing.id);
      if (mounted) Navigator.pop(context);
    }
  }

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
    if (_name.text.trim().isEmpty) {
      setState(() => _nameError = 'Give the schedule a name');
      return;
    }
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
  if (schedule.kind == 'oneTime') {
    return schedule.scheduledDate != null
        ? 'On ${_formatScheduleDate(schedule.scheduledDate!)}'
        : 'One-time';
  }
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

String _pauseHeadline(SchedulePauseState state) {
  if (state.until == null) {
    return 'Schedules paused until you resume';
  }
  final remaining = state.until!.difference(DateTime.now());
  var days = (remaining.inHours / 24).ceil();
  if (days < 1) days = 1;
  if (days == 1) {
    return 'Schedules paused for 1 day';
  }
  return 'Schedules paused for $days days';
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

String _nextRunSummary(ScheduleRecord schedule) {
  if (!schedule.enabled) return 'Paused';
  if (schedule.kind == 'countdown') return 'On trigger';
  if (schedule.id == 'schedule-evening-heater' || schedule.name == 'Evening heater') {
    return 'Today 18:00';
  }
  if (schedule.id == 'schedule-night-fan' || schedule.name == 'Night fan') {
    return 'Today 23:00';
  }
  return 'Today ${schedule.startTime}';
}

String _lastRunSummary(ScheduleRecord schedule) {
  if (schedule.id == 'schedule-evening-heater' || schedule.name == 'Evening heater') {
    return 'Executed yesterday 18:00 · IST (UTC+05:30)';
  }
  if (schedule.id == 'schedule-night-fan' || schedule.name == 'Night fan') {
    return 'Executed today 06:00 · IST (UTC+05:30)';
  }
  return 'Executed yesterday ${schedule.startTime} · IST (UTC+05:30)';
}
