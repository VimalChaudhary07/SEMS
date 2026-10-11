import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/repositories/sems_repository.dart';
import '../../data/simulators/pairing_simulator.dart';
import '../../domain/models/simulation_results.dart';
import '../../shared/widgets/sems_widgets.dart';

class DevicePairingScreen extends StatefulWidget {
  const DevicePairingScreen({
    super.key,
    required this.repository,
    required this.onAdded,
  });
  final SemsRepository repository;
  final VoidCallback onAdded;
  @override
  State<DevicePairingScreen> createState() => _DevicePairingScreenState();
}

class _DevicePairingScreenState extends State<DevicePairingScreen> {
  int step = 0;
  bool busy = false, scanning = false, hidePassword = true;
  PairingError? simulatedFailure;
  String? errorTitle, errorMessage;
  final name = TextEditingController(text: 'New smart plug');
  final appliance = TextEditingController(text: 'Smart appliance');
  final room = TextEditingController(text: 'Living room');
  final wifi = TextEditingController();
  final password = TextEditingController();
  final claimCode = TextEditingController();
  final form = GlobalKey<FormState>();
  final wifiForm = GlobalKey<FormState>();

  @override
  void dispose() {
    name.dispose();
    appliance.dispose();
    room.dispose();
    wifi.dispose();
    password.dispose();
    claimCode.dispose();
    super.dispose();
  }

  static const steps = [
    'Scan QR code',
    'Confirm socket',
    'Secure pairing',
    'Wi-Fi for the socket',
    'Pairing mode',
    'Connecting',
    'Name your socket',
    'Done',
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Add a socket')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        PageHeading(
          title: errorTitle ?? steps[step],
          subtitle: errorTitle == null
              ? 'Step ${step + 1} of ${steps.length}'
              : 'Setup needs attention',
        ),
        const SizedBox(height: 18),
        if (errorTitle != null) _errorView(),
        if (errorTitle == null) ...[
          LinearProgressIndicator(
            value: (step + 1) / steps.length,
            minHeight: 4,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 16),
          _stepContent(),
        ],
      ],
    ),
  );

  Widget _stepContent() => switch (step) {
    0 => _scanStep(),
    1 => _confirmStep(),
    2 => _securityStep(),
    3 => _wifiStep(),
    4 => _pairingStep(),
    5 => _progressStep(),
    6 => _nameStep(),
    _ => _doneStep(),
  };

  Widget _scanStep() => Column(
    children: [
      AppCard(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: SemsColors.mint,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                scanning ? Icons.radar_rounded : Icons.qr_code_scanner_rounded,
                color: SemsColors.forest,
                size: 72,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              scanning ? 'Reading QR code…' : 'Scan the label on your socket',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'Scan a demo identity or enter its six-digit setup code.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SemsColors.muted,
                fontSize: 12,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: scanning ? null : _simulateScan,
              icon: const Icon(Icons.center_focus_strong_rounded),
              label: Text(scanning ? 'Scanning…' : 'Simulate QR scan'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => step = 1),
              child: const Text('Continue with setup code'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: claimCode,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Six-digit setup code',
                counterText: '',
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      TextButton.icon(
        onPressed: _chooseError,
        icon: const Icon(Icons.help_outline_rounded),
        label: const Text('Preview a setup error'),
      ),
    ],
  );

  Widget _confirmStep() => Column(
    children: [
      const AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.power_rounded, color: SemsColors.forest, size: 34),
            SizedBox(height: 10),
            Text(
              'SEMS Smart Plug',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
            ),
            SizedBox(height: 4),
            Text(
              'Demo identity · SEMS-000004',
              style: TextStyle(color: SemsColors.muted, fontSize: 12),
            ),
            SizedBox(height: 12),
            Text(
              'Make sure this is the socket you want to add.',
              style: TextStyle(color: SemsColors.muted, fontSize: 12),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      _primary('Confirm socket', () => setState(() => step++)),
      TextButton(
        onPressed: () => setState(() => step = 0),
        child: const Text('Scan again'),
      ),
    ],
  );

  Widget _securityStep() => Column(
    children: [
      const AppCard(
        child: Column(
          children: [
            Icon(Icons.shield_outlined, color: SemsColors.forest, size: 46),
            SizedBox(height: 10),
            Text(
              'Pairing stays secure',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
            ),
            SizedBox(height: 8),
            Text(
              'The setup code is used only during pairing. It is not a password and should not be shared.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SemsColors.muted,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _primary('Continue', () => setState(() => step++)),
    ],
  );

  Widget _wifiStep() => Form(
    key: wifiForm,
    child: Column(
      children: [
        const AppCard(
          child: Row(
            children: [
              Icon(Icons.wifi_rounded, color: SemsColors.forest),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'The socket connects to your home Wi-Fi. Use a 2.4 GHz network.',
                  style: TextStyle(color: SemsColors.muted, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: wifi,
          decoration: const InputDecoration(
            labelText: 'Wi-Fi network name',
            prefixIcon: Icon(Icons.wifi_rounded),
          ),
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Enter a network name' : null,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: password,
          obscureText: hidePassword,
          decoration: InputDecoration(
            labelText: 'Wi-Fi password',
            suffixIcon: IconButton(
              onPressed: () => setState(() => hidePassword = !hidePassword),
              icon: Icon(
                hidePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
          validator: (v) =>
              v == null || v.length < 8 ? 'Use at least 8 characters' : null,
        ),
        const SizedBox(height: 18),
        _primary('Continue', () {
          if (wifiForm.currentState!.validate()) setState(() => step++);
        }),
      ],
    ),
  );

  Widget _pairingStep() => Column(
    children: [
      const AppCard(
        child: Column(
          children: [
            Icon(
              Icons.lightbulb_outline_rounded,
              color: SemsColors.forest,
              size: 44,
            ),
            SizedBox(height: 10),
            Text(
              'Put the socket in pairing mode',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
            ),
            SizedBox(height: 8),
            Text(
              'Press and hold the socket button until its indicator starts blinking. Keep your phone nearby.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SemsColors.muted,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _primary('Indicator is blinking', _connect),
      TextButton(
        onPressed: _chooseError,
        child: const Text('Troubleshoot pairing'),
      ),
    ],
  );

  Widget _progressStep() => AppCard(
    child: Column(
      children: [
        const SizedBox(height: 10),
        const CircularProgressIndicator(),
        const SizedBox(height: 18),
        Text(
          busy ? 'Connecting to ${wifi.text}…' : 'Claiming this socket…',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        const SizedBox(height: 8),
        const Text(
          'This is a simulated connection. The preview does not use Bluetooth or Wi-Fi.',
          textAlign: TextAlign.center,
          style: TextStyle(color: SemsColors.muted, fontSize: 12, height: 1.45),
        ),
        const SizedBox(height: 18),
      ],
    ),
  );

  Widget _nameStep() => Form(
    key: form,
    child: Column(
      children: [
        const AppCard(
          child: Row(
            children: [
              Icon(Icons.check_circle_outline_rounded, color: SemsColors.green),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Socket connected in the local preview',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: name,
          decoration: const InputDecoration(labelText: 'Socket name'),
          validator: _required,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: appliance,
          decoration: const InputDecoration(labelText: 'Connected appliance'),
          validator: _required,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: room,
          decoration: const InputDecoration(labelText: 'Room'),
          validator: _required,
        ),
        const SizedBox(height: 18),
        _primary('Add to my devices', _finish),
      ],
    ),
  );

  Widget _doneStep() => Column(
    children: [
      const AppCard(
        child: Column(
          children: [
            Icon(Icons.check_circle_rounded, color: SemsColors.green, size: 56),
            SizedBox(height: 10),
            Text(
              'Your socket is ready',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            SizedBox(height: 6),
            Text(
              'The claimed socket is now in your device list.',
              textAlign: TextAlign.center,
              style: TextStyle(color: SemsColors.muted, fontSize: 12),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _primary('Done', () => Navigator.pop(context)),
    ],
  );

  Widget _errorView() => Column(
    children: [
      AppCard(
        child: Column(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: SemsColors.red,
              size: 48,
            ),
            const SizedBox(height: 10),
            Text(
              errorTitle!,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: SemsColors.muted,
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _primary(
        'Try again',
        () => setState(() {
          errorTitle = null;
          simulatedFailure = null;
          step = 0;
        }),
      ),
      TextButton(
        onPressed: () => setState(() {
          errorTitle = null;
          simulatedFailure = null;
          step = 1;
        }),
        child: const Text('Enter setup manually'),
      ),
    ],
  );

  Widget _primary(String label, VoidCallback onPressed) => SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      child: Text(label),
    ),
  );
  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;

  Future<void> _simulateScan() async {
    setState(() => scanning = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      scanning = false;
      claimCode.text = widget.repository.pendingClaimCode ?? '';
      step = 1;
    });
  }

  Future<void> _connect() async {
    setState(() {
      step = 5;
      busy = true;
    });
    final simulator = PairingSimulator(
      validateClaimCode: widget.repository.validateClaimCode,
    );
    await for (final progress in simulator.run(
      failAt: simulatedFailure,
      claimCode: claimCode.text.trim(),
    )) {
      if (!mounted) return;
      if (progress.error case final error?) {
        final failure = _failureDetails[error]!;
        setState(() {
          busy = false;
          errorTitle = failure.$1;
          errorMessage = failure.$2;
        });
        return;
      }
      setState(() {
        busy = progress.step != PairingStep.claiming;
        step = progress.step == PairingStep.nameSocket
            ? 6
            : progress.step == PairingStep.claiming
            ? 5
            : progress.step.index.clamp(0, 5);
      });
    }
    if (!mounted) return;
    setState(() {
      busy = false;
      simulatedFailure = null;
      step = 6;
    });
  }

  Future<void> _finish() async {
    if (!form.currentState!.validate()) return;
    await widget.repository.claimSocket(
      claimCode: claimCode.text.trim(),
      name: name.text.trim(),
      room: room.text.trim(),
      appliance: appliance.text.trim(),
    );
    widget.onAdded();
    if (!mounted) return;
    setState(() => step = 7);
  }

  Future<void> _chooseError() async {
    final title = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            const ListTile(title: Text('Preview an error state')),
            for (final failure in _failureDetails.values)
              ListTile(
                title: Text(failure.$1),
                onTap: () => Navigator.pop(context, failure.$1),
              ),
          ],
        ),
      ),
    );
    if (title != null && mounted) {
      simulatedFailure = _failureDetails.entries
          .firstWhere((entry) => entry.value.$1 == title)
          .key;
      claimCode.text = widget.repository.pendingClaimCode ?? claimCode.text;
      await _connect();
    }
  }

  static const _failureDetails = <PairingError, (String, String)>{
    PairingError.invalidQr: (
      'Invalid QR code',
      'The QR code could not be read. Check that it is clear and belongs to a SEMS socket.',
    ),
    PairingError.bluetoothNotFound: (
      'Bluetooth not found',
      'Bluetooth pairing is unavailable in this local preview.',
    ),
    PairingError.wifiJoinFailed: (
      'Socket could not join Wi-Fi',
      'The sample socket could not join the selected network. Check the network details and retry.',
    ),
    PairingError.claimUsed: (
      'Claim code already used',
      'This demo claim code has already been used.',
    ),
    PairingError.alreadyClaimed: (
      'Socket already claimed',
      'This socket is already registered in the demo household.',
    ),
    PairingError.tooManyAttempts: (
      'Too many attempts',
      'Setup has paused after repeated attempts. Wait before trying again.',
    ),
    PairingError.pairingWindowClosed: (
      'Pairing window closed',
      'The socket pairing window has closed. Put it back into pairing mode.',
    ),
    PairingError.claimFailed: (
      'Claim failed',
      'The local demo could not claim the socket. You can restart setup.',
    ),
  };
}
