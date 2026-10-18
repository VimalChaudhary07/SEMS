// Implements Figma frames: Remote control and its command states.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/sems_models.dart';
import '../../data/repositories/sems_repository.dart';
import '../../domain/models/command_progress.dart';
import '../../shared/widgets/sems_widgets.dart';

enum _CommandPhase {
  idle,
  pending,
  acknowledged,
  executed,
  failed,
  expired,
  blocked,
}

class ControlScreen extends StatefulWidget {
  const ControlScreen({
    super.key,
    required this.device,
    required this.repository,
    required this.onChanged,
  });
  final SemsDevice device;
  final SemsRepository repository;
  final VoidCallback onChanged;
  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen>
    with SingleTickerProviderStateMixin {
  late SemsDevice device = widget.device;
  _CommandPhase phase = _CommandPhase.idle;
  String? timerLabel;
  DateTime? _timerEndsAt;
  Timer? _timer;
  bool working = false;
  late bool safetyTrip = widget.device.safetyTrip;
  bool? lastRequestedOn;
  late final AnimationController _powerPulse;
  final List<String> commandHistory = [
    'Turn ON · Schedule · Yesterday 18:00 · Executed',
    'Turn OFF · Family · Yesterday 12:10 · Executed',
    'Turn OFF · Owner · Yesterday 08:05 · Failed',
  ];

  @override
  void initState() {
    super.initState();
    _powerPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      lowerBound: 0.94,
      upperBound: 1,
      value: 1,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _powerPulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offline = !device.online;
    final motionDuration = MediaQuery.of(context).disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 360);
    final quickMotionDuration = MediaQuery.of(context).disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 180);
    final locked = offline || (safetyTrip && !device.isOn);
    final waiting =
        phase == _CommandPhase.pending || phase == _CommandPhase.acknowledged;
    final ringColor = waiting
        ? const Color(0xFFE4ECFD)
        : safetyTrip
        ? const Color(0xFFFBE6E6)
        : offline || !device.isOn
        ? const Color(0xFFEAF1EE)
        : SemsColors.mint;
    final powerColor = offline
        ? const Color(0xFF7A8594)
        : safetyTrip
        ? SemsColors.red
        : device.isOn
        ? SemsColors.forest
        : const Color(0xFFEAF1EE);
    final powerForeground = device.isOn && !offline
        ? Colors.white
        : const Color(0xFF55625D);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              device.appliance,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              '${device.room} · ${device.id}',
              style: const TextStyle(fontSize: 11, color: SemsColors.muted),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (safetyTrip)
            const AppBanner(
              tone: StatusTone.fault,
              icon: Icons.warning_amber_rounded,
              title: 'Safety trip',
              body: 'The sample socket blocked ON control after an over-current event.',
            ),
          AppCard(
            padding: const EdgeInsets.fromLTRB(16, 28, 16, 20),
            child: Column(
              children: [
                SizedBox(
                  width: 188,
                  height: 188,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedContainer(
                        duration: motionDuration,
                        curve: Curves.easeInOutCubic,
                        width: 188,
                        height: 188,
                        decoration: BoxDecoration(
                          color: ringColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (waiting)
                        SizedBox(
                          width: 188,
                          height: 188,
                          child: CircularProgressIndicator(
                            value: 0.34,
                            strokeWidth: 3,
                            color: const Color(0xFF2F6FED),
                            backgroundColor: const Color(0xFFD7E3FC),
                          ),
                        ),
                      ScaleTransition(
                        scale: _powerPulse,
                        child: Tooltip(
                          message:
                              'Turn ${device.isOn ? 'off' : 'on'} ${device.appliance}',
                          child: InkWell(
                            onTap: locked || working
                                ? null
                                : () => _request(!device.isOn),
                            borderRadius: BorderRadius.circular(100),
                            child: AnimatedContainer(
                              duration: motionDuration,
                              curve: Curves.easeInOutCubic,
                              width: 148,
                              height: 148,
                              decoration: BoxDecoration(
                                color: powerColor,
                                shape: BoxShape.circle,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x0D101614),
                                    blurRadius: 14,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedSwitcher(
                                    duration: quickMotionDuration,
                                    switchInCurve: Curves.easeOut,
                                    switchOutCurve: Curves.easeIn,
                                    transitionBuilder: (child, animation) =>
                                        FadeTransition(
                                          opacity: animation,
                                          child: ScaleTransition(
                                            scale: animation,
                                            child: child,
                                          ),
                                        ),
                                    child: SvgPicture.asset(
                                      AppAssets.controlPower,
                                      key: ValueKey('${device.isOn}_$offline'),
                                      width: 44,
                                      height: 44,
                                      colorFilter: ColorFilter.mode(
                                        powerForeground,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  AnimatedSwitcher(
                                    duration: quickMotionDuration,
                                    transitionBuilder: (child, animation) =>
                                        FadeTransition(
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
                                      offline
                                          ? 'OFFLINE'
                                          : device.isOn
                                          ? 'ON'
                                          : 'OFF',
                                      key: ValueKey('${device.isOn}_$offline'),
                                      style: TextStyle(
                                        color: powerForeground,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                AnimatedSwitcher(
                  duration: MediaQuery.of(context).disableAnimations
                      ? Duration.zero
                      : const Duration(milliseconds: 220),
                  child: Text(
                    offline
                        ? 'Last known reading · ${device.watts} W'
                        : waiting
                        ? 'Control locked until the socket confirms'
                        : safetyTrip
                        ? 'Safety protection is active'
                        : device.isOn
                        ? 'Tap to turn OFF'
                        : 'Tap to turn ON',
                    key: ValueKey(
                      '${offline}_${waiting}_${safetyTrip}_${device.isOn}',
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: SemsColors.muted,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedSwitcher(
                  duration: quickMotionDuration,
                  child: Text(
                    '${device.watts} W now',
                    key: ValueKey(device.watts),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: MediaQuery.of(context).disableAnimations
                      ? Duration.zero
                      : const Duration(milliseconds: 260),
                  curve: Curves.easeInOutCubic,
                  child: phase == _CommandPhase.idle && !safetyTrip && !offline
                      ? const SizedBox(width: double.infinity)
                      : Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: AnimatedSwitcher(
                            duration: quickMotionDuration,
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, .12),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                ),
                            child: _CommandBanner(
                              key: ValueKey(
                                '${phase}_${offline}_${safetyTrip}_${device.isOn}',
                              ),
                              phase: phase,
                              offline: offline,
                              safetyTrip: safetyTrip,
                              isOn: device.isOn,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (offline)
            const AppCard(
              child: Text(
                'This socket is offline. Its last known state is shown; control is unavailable until it reconnects.',
                style: TextStyle(
                  color: SemsColors.muted,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: offline || working ? null : _setTimer,
                  icon: SvgPicture.asset(
                    AppAssets.controlTimer,
                    width: 18,
                    height: 18,
                  ),
                  label: Text(timerLabel == null ? 'Timer' : timerLabel!),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: offline || working || !device.isOn
                      ? null
                      : () => _request(false, emergency: true),
                  icon: SvgPicture.asset(
                    AppAssets.controlAlert,
                    width: 18,
                    height: 18,
                  ),
                  label: const Text('Emergency OFF'),
                  style: FilledButton.styleFrom(
                    backgroundColor: SemsColors.red,
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const SectionTitle('LAST COMMAND'),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: quickMotionDuration,
            child: _LastCommandCard(
              key: ValueKey('${phase}_${offline}_$lastRequestedOn'),
              phase: phase,
              offline: offline,
              requestedOn: lastRequestedOn,
              onRetry:
                  phase == _CommandPhase.failed ||
                      phase == _CommandPhase.expired
                  ? () => _request(lastRequestedOn ?? device.isOn)
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          const SectionTitle('CONTROL HISTORY'),
          const SizedBox(height: 8),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < commandHistory.length; i++) ...[
                  ListTile(
                    leading: Icon(
                      commandHistory[i].contains('Failed')
                          ? Icons.cancel_outlined
                          : Icons.power_settings_new_rounded,
                      color: commandHistory[i].contains('Failed')
                          ? SemsColors.red
                          : SemsColors.forest,
                    ),
                    title: Text(
                      commandHistory[i].split(' · ').first,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      commandHistory[i].split(' · ').skip(1).join(' · '),
                      style: const TextStyle(
                        fontSize: 10,
                        color: SemsColors.muted,
                      ),
                    ),
                  ),
                  if (i < commandHistory.length - 1)
                    const Divider(height: 1, indent: 56),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          const AppCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: SemsColors.forest),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Demo only: each command updates local sample data. It does not communicate with a physical socket.',
                    style: TextStyle(
                      color: SemsColors.muted,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _request(bool turnOn, {bool emergency = false}) async {
    if (emergency) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Emergency OFF?'),
          content: Text(
            'Send a high-priority OFF command to ${device.appliance}? This changes local demo state only.',
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
              label: 'Send OFF',
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }
    setState(() {
      working = true;
      phase = _CommandPhase.pending;
      lastRequestedOn = turnOn;
    });
    try {
      await for (final progress in widget.repository.runCommand(
        socketId: device.id,
        targetRelay: turnOn,
        emergency: emergency,
      )) {
        if (!mounted) return;
        setState(() {
          phase = switch (progress.state) {
            CommandState.pending => _CommandPhase.pending,
            CommandState.acknowledged => _CommandPhase.acknowledged,
            CommandState.executed => _CommandPhase.executed,
            CommandState.failed => _CommandPhase.failed,
            CommandState.expired => _CommandPhase.expired,
            CommandState.blocked => _CommandPhase.blocked,
          };
          if (progress.state == CommandState.executed) {
            device = widget.repository.devices.firstWhere(
              (item) => item.id == device.id,
            );
          }
        });
      }
      if (!mounted) return;
      final outcome = switch (phase) {
        _CommandPhase.executed => 'Executed',
        _CommandPhase.expired => 'Expired',
        _CommandPhase.blocked => 'Blocked',
        _ => 'Failed',
      };
      setState(() {
        working = false;
        commandHistory.insert(
          0,
          'Turn ${turnOn ? 'ON' : 'OFF'} · ${emergency ? 'Emergency' : 'Owner'} · Just now · $outcome',
        );
      });
      if (phase == _CommandPhase.executed) {
        if (MediaQuery.of(context).disableAnimations) {
          _powerPulse.value = 1;
        } else {
          _powerPulse.forward(from: _powerPulse.lowerBound);
        }
        widget.onChanged();
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        working = false;
        phase = _CommandPhase.failed;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Command could not be completed: $error')),
      );
    }
  }

  Future<void> _setTimer() async {
    final customController = TextEditingController();
    final selected = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: StatefulBuilder(
          builder: (context, setSheetState) {
            final customMinutes = int.tryParse(customController.text);
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              shrinkWrap: true,
              children: [
                const Text(
                  'Turn off after',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                for (final minutes in [15, 30, 60, 120])
                  ListTile(
                    leading: const Icon(Icons.timer_outlined),
                    title: Text(_durationLabel(minutes)),
                    onTap: () => Navigator.pop(context, minutes),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: customController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Custom duration',
                          suffixText: 'minutes',
                        ),
                        onChanged: (_) => setSheetState(() {}),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filled(
                      tooltip: 'Start custom timer',
                      onPressed:
                          customMinutes == null ||
                              customMinutes <= 0 ||
                              customMinutes > 1440
                          ? null
                          : () => Navigator.pop(context, customMinutes),
                      icon: const Icon(Icons.check_rounded),
                    ),
                  ],
                ),
                if (timerLabel != null)
                  ListTile(
                    leading: const Icon(Icons.close_rounded),
                    title: const Text('Remove timer'),
                    onTap: () => Navigator.pop(context, -1),
                  ),
              ],
            );
          },
        ),
      ),
    );
    customController.dispose();
    if (selected == null || !mounted) return;
    _timer?.cancel();
    if (selected == -1) {
      setState(() {
        timerLabel = null;
        _timerEndsAt = null;
      });
      return;
    }
    final duration = Duration(minutes: selected);
    setState(() {
      _timerEndsAt = DateTime.now().add(duration);
      timerLabel = _durationLabel(selected);
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final endsAt = _timerEndsAt;
      if (endsAt == null || !mounted) return;
      if (DateTime.now().isBefore(endsAt)) {
        setState(
          () => timerLabel = _durationLabel(
            endsAt.difference(DateTime.now()).inSeconds,
            seconds: true,
          ),
        );
        return;
      }
      _timer?.cancel();
      setState(() {
        timerLabel = null;
        _timerEndsAt = null;
      });
      _request(false);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Auto-off timer set for ${_durationLabel(selected)}.'),
      ),
    );
  }

  static String _durationLabel(int value, {bool seconds = false}) {
    if (seconds) {
      final minutes = value ~/ 60;
      final remainingSeconds = value % 60;
      return '${minutes}m ${remainingSeconds.toString().padLeft(2, '0')}s';
    }
    if (value < 60) return '$value minutes';
    if (value % 60 == 0) return '${value ~/ 60} hour${value == 60 ? '' : 's'}';
    return '${value ~/ 60} h ${value % 60} min';
  }
}

class _CommandBanner extends StatelessWidget {
  const _CommandBanner({
    super.key,
    required this.phase,
    required this.offline,
    required this.safetyTrip,
    required this.isOn,
  });
  final _CommandPhase phase;
  final bool offline, safetyTrip, isOn;

  @override
  Widget build(BuildContext context) {
    final (text, icon, color, background) = offline
        ? (
            'Socket offline',
            Icons.wifi_off_rounded,
            SemsColors.muted,
            const Color(0xFFECEEF0),
          )
        : safetyTrip
        ? (
            'Over-current protection tripped',
            Icons.warning_amber_rounded,
            SemsColors.red,
            const Color(0xFFFBE6E6),
          )
        : switch (phase) {
            _CommandPhase.pending => (
              'Sending to socket',
              Icons.sync_rounded,
              const Color(0xFF2F6FED),
              const Color(0xFFE3ECFD),
            ),
            _CommandPhase.acknowledged => (
              'Socket received the command',
              Icons.check_circle_outline_rounded,
              SemsColors.green,
              SemsColors.mint,
            ),
            _CommandPhase.executed => (
              'Socket confirmed ${isOn ? 'ON' : 'OFF'}',
              Icons.check_circle_outline_rounded,
              SemsColors.green,
              SemsColors.mint,
            ),
            _CommandPhase.failed => (
              'Command failed · retry or read the reason',
              Icons.cancel_outlined,
              SemsColors.red,
              const Color(0xFFFBE6E6),
            ),
            _CommandPhase.expired => (
              'Command expired · no acknowledgement',
              Icons.schedule_rounded,
              SemsColors.amber,
              const Color(0xFFFFF3DF),
            ),
            _CommandPhase.blocked => (
              'Command blocked by safety protection',
              Icons.warning_amber_rounded,
              SemsColors.red,
              const Color(0xFFFBE6E6),
            ),
            _CommandPhase.idle => (
              'Ready',
              Icons.check_circle_outline_rounded,
              SemsColors.green,
              SemsColors.mint,
            ),
          };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (phase == _CommandPhase.pending && !offline && !safetyTrip)
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: color),
            )
          else
            Icon(icon, color: color, size: 18),
          const SizedBox(width: 9),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Text(
                text,
                key: ValueKey(text),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LastCommandCard extends StatelessWidget {
  const _LastCommandCard({
    super.key,
    required this.phase,
    required this.offline,
    required this.requestedOn,
    required this.onRetry,
  });
  final _CommandPhase phase;
  final bool offline;
  final bool? requestedOn;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (phase == _CommandPhase.idle && requestedOn == null) {
      return const AppCard(
        child: Text(
          'No commands yet from this app.',
          style: TextStyle(color: SemsColors.muted, fontSize: 14),
        ),
      );
    }
    final (result, color, tint) = offline
        ? ('Offline', SemsColors.muted, const Color(0xFFECEEF0))
        : switch (phase) {
            _CommandPhase.pending => (
              'Pending',
              const Color(0xFF2F6FED),
              const Color(0xFFE3ECFD),
            ),
            _CommandPhase.acknowledged => (
              'Acknowledged',
              const Color(0xFF2F6FED),
              const Color(0xFFE3ECFD),
            ),
            _CommandPhase.executed => (
              'Executed',
              SemsColors.green,
              SemsColors.mint,
            ),
            _CommandPhase.failed => (
              'Failed',
              SemsColors.red,
              const Color(0xFFFBE6E6),
            ),
            _CommandPhase.expired => (
              'Expired',
              SemsColors.amber,
              const Color(0xFFFFF3DF),
            ),
            _CommandPhase.blocked => (
              'Blocked',
              SemsColors.red,
              const Color(0xFFFBE6E6),
            ),
            _CommandPhase.idle => (
              'Ready',
              SemsColors.muted,
              const Color(0xFFECEEF0),
            ),
          };
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _CommandInfoRow(
            label: 'Requested',
            value: requestedOn == true ? 'ON' : 'OFF',
            tint: SemsColors.mint,
            color: SemsColors.forest,
          ),
          _CommandInfoRow(
            label: 'Result',
            value: result,
            tint: tint,
            color: color,
          ),
          const _CommandInfoRow(label: 'Source', value: 'Owner'),
          const _CommandInfoRow(label: 'Time', value: 'Just now', isLast: true),
          if (onRetry != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onRetry,
                child: const Text('Retry command'),
              ),
            ),
        ],
      ),
    );
  }
}

class _CommandInfoRow extends StatelessWidget {
  const _CommandInfoRow({
    required this.label,
    required this.value,
    this.tint,
    this.color,
    this.isLast = false,
  });
  final String label, value;
  final Color? tint, color;
  final bool isLast;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
            if (tint != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              Text(value, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
      if (!isLast) const Divider(height: 1),
    ],
  );
}
