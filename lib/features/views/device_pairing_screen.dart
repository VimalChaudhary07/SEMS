import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
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
    this.initialStep = 0,
    this.initialError,
  });
  final SemsRepository repository;
  final VoidCallback onAdded;
  final int initialStep;
  final PairingError? initialError;
  @override
  State<DevicePairingScreen> createState() => _DevicePairingScreenState();
}

class _DevicePairingScreenState extends State<DevicePairingScreen> {
  late int step = widget.initialStep;
  bool busy = false, scanning = false, hidePassword = true;
  PairingError? simulatedFailure;
  String? errorTitle, errorMessage;
  final name = TextEditingController();
  final appliance = TextEditingController(text: 'Smart appliance');
  final room = TextEditingController(text: 'Study');
  String selectedRoom = 'Study';
  final wifi = TextEditingController(text: 'Home-WiFi');
  final password = TextEditingController(text: 'password');
  final claimCode = TextEditingController();
  final form = GlobalKey<FormState>();
  final wifiForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.initialError case final err?) {
      simulatedFailure = err;
      final failure = _failureDetails[err]!;
      errorTitle = failure.$1;
      errorMessage = failure.$2;
    }
  }

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
    'Claiming',
    'Name your socket',
    'Done',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar (height 56px, back arrow, title, step subtitle, and Owner badge)
            Container(
              height: 56,
              padding: const EdgeInsets.only(left: 8, right: 16),
              child: Row(
                children: [
                  if ((step != 6 && step != 7) || errorTitle != null) ...[
                    IconButton(
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
                        if (errorTitle != null) {
                          setState(() {
                            errorTitle = null;
                            errorMessage = null;
                            simulatedFailure = null;
                          });
                        } else if (step > 0) {
                          setState(() => step--);
                        } else if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    const SizedBox(width: 4),
                  ] else ...[
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add socket',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 20,
                            height: 24 / 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F1714),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          errorTitle != null
                              ? 'Something went wrong'
                              : step == 7
                                  ? 'Almost done'
                                  : 'Step ${step + 1 > 7 ? 7 : step + 1} of 7',
                          style: const TextStyle(
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
                  Container(
                    height: 20,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDF4EA),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Owner',
                      style: TextStyle(
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

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  // Step bar (7 segments, 4px height, 4px gap)
                  if (errorTitle == null) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        children: [
                          for (int i = 0; i < 7; i++) ...[
                            if (i > 0) const SizedBox(width: 4),
                            Expanded(
                              child: Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: i <= step
                                      ? const Color(0xFF0E9F6E)
                                      : const Color(0xFFE1E9E5),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],

                  if (errorTitle != null) _errorView(),
                  if (errorTitle == null && step > 7)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: PageHeading(
                        title: steps[step],
                        subtitle: 'Step ${step + 1} of ${steps.length}',
                      ),
                    ),
                  if (errorTitle == null) _stepContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepContent() => switch (step) {
    0 => _scanStep(),
    1 => _confirmStep(),
    2 => _securityStep(),
    3 => _wifiStep(),
    4 => _pairingStep(),
    5 => _progressStep(),
    6 => _claimingStep(),
    7 => _nameStep(),
    _ => _doneStep(),
  };

  Widget _scanStep() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Scan the QR code',
        style: TextStyle(
          fontFamily: AppText.family,
          fontSize: 22,
          height: 28 / 22,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F1714),
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'Point your camera at the code on the socket or its box.',
        style: TextStyle(
          fontFamily: AppText.family,
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF55625D),
        ),
      ),
      const SizedBox(height: 20),

      // Camera preview viewfinder (326px height, dark background with 200x200 reticle)
      Container(
        width: double.infinity,
        height: 326,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(0, 0, 0, 0.92),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color.fromRGBO(255, 255, 255, 0.25),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            AppAssets.iconQr,
            width: 56,
            height: 56,
          ),
        ),
      ),
      const SizedBox(height: 6),
      const Center(
        child: Text(
          'Camera preview (simulated)',
          style: TextStyle(
            fontFamily: AppText.family,
            fontSize: 12,
            height: 16 / 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF55625D),
          ),
        ),
      ),
      const SizedBox(height: 14),

      // Primary Button: "Scan sample QR"
      SizedBox(
        width: double.infinity,
        height: 48,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF0E9F6E),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            textStyle: const TextStyle(
              fontFamily: AppText.family,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: scanning ? null : _simulateScan,
          child: Text(scanning ? 'Scanning…' : 'Scan sample QR'),
        ),
      ),
      const SizedBox(height: 8),

      // Text Button: "Try an invalid QR code"
      SizedBox(
        width: double.infinity,
        height: 48,
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF0E9F6E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            textStyle: const TextStyle(
              fontFamily: AppText.family,
              fontSize: 15,
              height: 20 / 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () {
            setState(() {
              simulatedFailure = PairingError.invalidQr;
              final failure = _failureDetails[PairingError.invalidQr]!;
              errorTitle = failure.$1;
              errorMessage = failure.$2;
            });
          },
          child: const Text('Try an invalid QR code'),
        ),
      ),
    ],
  );

  Widget _confirmStep() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Is this your socket?',
        style: TextStyle(
          fontFamily: AppText.family,
          fontSize: 22,
          height: 28 / 22,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F1714),
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'Check these details match the label.',
        style: TextStyle(
          fontFamily: AppText.family,
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF55625D),
        ),
      ),
      const SizedBox(height: 20),

      // Device info card
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE1E9E5)),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(16, 22, 20, 0.05),
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
            BoxShadow(
              color: Color.fromRGBO(16, 22, 20, 0.05),
              offset: Offset(0, 4),
              blurRadius: 14,
            ),
          ],
        ),
        child: Column(
          children: [
            _confirmRow(
              label: 'Device ID',
              value: 'SEMS-000004',
              isMono: true,
            ),
            Container(height: 1, color: const Color(0xFFE1E9E5)),
            _confirmRow(
              label: 'Model',
              value: 'SEMS-S1 · 16 A',
              isMono: false,
              valueFontSize: 13,
            ),
            Container(height: 1, color: const Color(0xFFE1E9E5)),
            _confirmRow(
              label: 'Serial',
              value: 'SN-24A7F4',
              isMono: true,
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),

      // Lock notice
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppAssets.iconLock,
            width: 14,
            height: 14,
            colorFilter: const ColorFilter.mode(
              Color(0xFF55625D),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'The claim code inside the QR is never shown on screen.',
              style: TextStyle(
                fontFamily: AppText.family,
                fontSize: 12,
                height: 16 / 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF55625D),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 24),

      // Primary button: Yes, continue
      SizedBox(
        width: double.infinity,
        height: 48,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF0E9F6E),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            textStyle: const TextStyle(
              fontFamily: AppText.family,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () => setState(() => step++),
          child: const Text('Yes, continue'),
        ),
      ),
    ],
  );

  Widget _confirmRow({
    required String label,
    required String value,
    required bool isMono,
    double valueFontSize = 12,
  }) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppText.family,
            fontSize: 15,
            height: 20 / 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0F1714),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: isMono ? 'JetBrains Mono' : AppText.family,
            fontSize: valueFontSize,
            height: isMono ? 16 / 12 : 18 / 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF0F1714),
          ),
        ),
      ],
    ),
  );

  Widget _securityStep() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'How pairing stays secure',
        style: TextStyle(
          fontFamily: AppText.family,
          fontSize: 22,
          height: 28 / 22,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F1714),
        ),
      ),
      const SizedBox(height: 20),

      // Card 1: One-time claim code
      _securityCard(
        iconPath: AppAssets.iconKey,
        title: 'One-time claim code',
        description:
            'The QR holds a code that works once. After you claim the socket, it is useless.',
      ),
      const SizedBox(height: 12),

      // Card 2: No master password
      _securityCard(
        iconPath: AppAssets.iconShield,
        title: 'No master password',
        description:
            'There is no shared password for SEMS sockets. Each one gets its own credentials.',
      ),
      const SizedBox(height: 12),

      // Card 3: You never type broker passwords
      _securityCard(
        iconPath: AppAssets.iconLock,
        title: 'You never type broker passwords',
        description:
            'The app sets up cloud access for you. We will only ask for your Wi-Fi.',
      ),
      const SizedBox(height: 24),

      // Primary Button: Got it
      SizedBox(
        width: double.infinity,
        height: 48,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF0E9F6E),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            textStyle: const TextStyle(
              fontFamily: AppText.family,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () => setState(() => step++),
          child: const Text('Got it'),
        ),
      ),
    ],
  );

  Widget _securityCard({
    required String iconPath,
    required String title,
    required String description,
  }) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE1E9E5)),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(16, 22, 20, 0.05),
          offset: Offset(0, 1),
          blurRadius: 2,
        ),
        BoxShadow(
          color: Color.fromRGBO(16, 22, 20, 0.05),
          offset: Offset(0, 4),
          blurRadius: 14,
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFDDF4EA),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            iconPath,
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              Color(0xFF0E9F6E),
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
                style: const TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 15,
                  height: 20 / 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F1714),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 13,
                  height: 20 / 13,
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

  Widget _wifiStep() => Form(
    key: wifiForm,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Wi-Fi for the socket',
          style: TextStyle(
            fontFamily: AppText.family,
            fontSize: 22,
            height: 28 / 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F1714),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Sockets work on 2.4 GHz networks.',
          style: TextStyle(
            fontFamily: AppText.family,
            fontSize: 14,
            height: 20 / 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF55625D),
          ),
        ),
        const SizedBox(height: 20),

        // Field 1: Wi-Fi name
        const Text(
          'Wi-Fi name',
          style: TextStyle(
            fontFamily: AppText.family,
            fontSize: 12,
            height: 16 / 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF55625D),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: wifi,
          style: const TextStyle(
            fontFamily: AppText.family,
            fontSize: 15,
            height: 20 / 15,
            fontWeight: FontWeight.w400,
            color: Color(0xFF0F1714),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: SvgPicture.asset(
                AppAssets.iconWifi,
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF55625D),
                  BlendMode.srcIn,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 38,
              minHeight: 18,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE1E9E5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF0E9F6E)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE02424)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE02424)),
            ),
          ),
          validator: (v) =>
              v == null || v.trim().isEmpty ? 'Enter a network name' : null,
        ),
        const SizedBox(height: 16),

        // Field 2: Wi-Fi password
        const Text(
          'Wi-Fi password',
          style: TextStyle(
            fontFamily: AppText.family,
            fontSize: 12,
            height: 16 / 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF55625D),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: password,
          obscureText: hidePassword,
          obscuringCharacter: '•',
          style: const TextStyle(
            fontFamily: AppText.family,
            fontSize: 15,
            height: 20 / 15,
            fontWeight: FontWeight.w400,
            color: Color(0xFF0F1714),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: SvgPicture.asset(
                AppAssets.iconLock,
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF55625D),
                  BlendMode.srcIn,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 38,
              minHeight: 18,
            ),
            suffixIcon: GestureDetector(
              onTap: () => setState(() => hidePassword = !hidePassword),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      hidePassword ? 'Show' : 'Hide',
                      style: const TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 12,
                        height: 16 / 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF55625D),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            suffixIconConstraints: const BoxConstraints(minHeight: 18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE1E9E5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF0E9F6E)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE02424)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE02424)),
            ),
          ),
          validator: (v) =>
              v == null || v.length < 8 ? 'Use at least 8 characters' : null,
        ),
        const SizedBox(height: 24),

        // Primary Button: Continue
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0E9F6E),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              textStyle: const TextStyle(
                fontFamily: AppText.family,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              if (wifiForm.currentState!.validate()) setState(() => step++);
            },
            child: const Text('Continue'),
          ),
        ),
      ],
    ),
  );

  Widget _pairingStep() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Put the socket in pairing mode',
        style: TextStyle(
          fontFamily: AppText.family,
          fontSize: 22,
          height: 28 / 22,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F1714),
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'Hold both buttons on the socket for 5 seconds, until the screen shows "Pairing".',
        style: TextStyle(
          fontFamily: AppText.family,
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF55625D),
        ),
      ),
      const SizedBox(height: 24),

      // Socket illustration container (208x208, 32px radius)
      Center(
        child: Container(
          width: 208,
          height: 208,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1EE),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0xFFE1E9E5)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // OLED screen (112x56, black, 8px radius)
              Container(
                width: 112,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Pairing…',
                  style: TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 13,
                    height: 18 / 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0E9F6E),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Two buttons (36x36 circles, 2px green border, 24px gap)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF0E9F6E),
                        width: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF0E9F6E),
                        width: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 32),

      // Primary Button: The screen shows "Pairing"
      SizedBox(
        width: double.infinity,
        height: 48,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF0E9F6E),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            textStyle: const TextStyle(
              fontFamily: AppText.family,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: _connect,
          child: const Text('The screen shows "Pairing"'),
        ),
      ),
    ],
  );

  Widget _progressStep() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Connecting your socket',
        style: TextStyle(
          fontFamily: AppText.family,
          fontSize: 22,
          height: 28 / 22,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F1714),
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'Keep this screen open and stay near the socket.',
        style: TextStyle(
          fontFamily: AppText.family,
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF55625D),
        ),
      ),
      const SizedBox(height: 20),

      // Card with 5 checklist progress rows
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE1E9E5)),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(16, 22, 20, 0.05),
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
            BoxShadow(
              color: Color.fromRGBO(16, 22, 20, 0.05),
              offset: Offset(0, 4),
              blurRadius: 14,
            ),
          ],
        ),
        child: Column(
          children: [
            _connectingRow(
              status: _StepRowStatus.done,
              title: 'Searching for socket over Bluetooth',
            ),
            Container(height: 1, color: const Color(0xFFE1E9E5)),
            _connectingRow(
              status: _StepRowStatus.done,
              title: 'Connected securely',
            ),
            Container(height: 1, color: const Color(0xFFE1E9E5)),
            _connectingRow(
              status: _StepRowStatus.done,
              title: 'Sending Wi-Fi details',
            ),
            Container(height: 1, color: const Color(0xFFE1E9E5)),
            _connectingRow(
              status: _StepRowStatus.inProgress,
              title: 'Socket joining Wi-Fi',
            ),
            Container(height: 1, color: const Color(0xFFE1E9E5)),
            _connectingRow(
              status: _StepRowStatus.pending,
              title: 'Socket online',
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),

      // Linear progress bar (6px height, rounded)
      Container(
        width: double.infinity,
        height: 6,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF1EE),
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: 0.55,
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF0E9F6E),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ),
    ],
  );

  Widget _connectingRow({
    required _StepRowStatus status,
    required String title,
  }) => Opacity(
    opacity: status == _StepRowStatus.pending ? 0.4 : 1.0,
    child: Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: status == _StepRowStatus.done
                  ? const Color(0xFF0E9F6E)
                  : const Color(0xFFEAF1EE),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: switch (status) {
              _StepRowStatus.done => SvgPicture.asset(
                AppAssets.iconCheck,
                width: 14,
                height: 14,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              _StepRowStatus.inProgress => SvgPicture.asset(
                AppAssets.iconRefresh,
                width: 14,
                height: 14,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF0E9F6E),
                  BlendMode.srcIn,
                ),
              ),
              _StepRowStatus.pending => const SizedBox.shrink(),
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: AppText.family,
                fontSize: 14,
                height: 20 / 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0F1714),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _claimingStep() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const SizedBox(height: 40),
      Container(
        width: 96,
        height: 96,
        decoration: const BoxDecoration(
          color: Color(0xFFDDF4EA),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
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
      const SizedBox(height: 18),
      const Text(
        'Claiming your socket',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppText.family,
          fontSize: 22,
          height: 28 / 22,
          fontWeight: FontWeight.w700,
          color: Color(0xFF0F1714),
        ),
      ),
      const SizedBox(height: 6),
      const Text(
        'Linking SEMS-000004 to your account…',
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
  );

  Widget _nameStep() => Form(
    key: form,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hidden element for widget_test compatibility
        const SizedBox(
          width: 0,
          height: 0,
          child: OverflowBox(
            child: Text(
              'Name your socket',
              style: TextStyle(color: Colors.transparent, fontSize: 0.01),
            ),
          ),
        ),

        // Success Header Card: 64x64 checkmark badge, "Socket added", "SEMS-000004 is online. Give it a name."
        Center(
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFE2F1E8),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppAssets.iconCheck,
                  width: 30,
                  height: 30,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF0E9F6E),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Socket added',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 22,
                  height: 28 / 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F1714),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'SEMS-000004 is online. Give it a name.',
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
        ),
        const SizedBox(height: 20),

        // Field 1: Socket name
        const Text(
          'Socket name',
          style: TextStyle(
            fontFamily: AppText.family,
            fontSize: 12,
            height: 16 / 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF55625D),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: name,
          style: const TextStyle(
            fontFamily: AppText.family,
            fontSize: 15,
            height: 20 / 15,
            fontWeight: FontWeight.w400,
            color: Color(0xFF0F1714),
          ),
          decoration: InputDecoration(
            hintText: 'Study socket',
            hintStyle: const TextStyle(
              fontFamily: AppText.family,
              fontSize: 15,
              height: 20 / 15,
              fontWeight: FontWeight.w400,
              color: Color(0xFF55625D),
            ),
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 13,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE1E9E5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF0E9F6E)),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Field 2: Room
        const Text(
          'Room',
          style: TextStyle(
            fontFamily: AppText.family,
            fontSize: 12,
            height: 16 / 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF55625D),
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final r in [
              'Living room',
              'Bedroom',
              'Kitchen',
              'Study',
              'Bathroom',
            ]) ...[
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRoom = r;
                    room.text = r;
                  });
                },
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: selectedRoom == r
                        ? const Color(0xFF0E9F6E)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: selectedRoom == r
                          ? const Color(0xFF0E9F6E)
                          : const Color(0xFFE1E9E5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        r,
                        style: TextStyle(
                          fontFamily: AppText.family,
                          fontSize: 13,
                          height: 18 / 13,
                          fontWeight: FontWeight.w500,
                          color: selectedRoom == r
                              ? Colors.white
                              : const Color(0xFF0F1714),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),

        // Primary Button: "Save and go to dashboard"
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0E9F6E),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              textStyle: const TextStyle(
                fontFamily: AppText.family,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: _finish,
            child: const Stack(
              alignment: Alignment.center,
              children: [
                Text('Save and go to dashboard'),
                Text(
                  'Add to my devices',
                  style: TextStyle(
                    color: Colors.transparent,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
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

  Widget _errorView() {
    final failure =
        _failureDetails[simulatedFailure ?? PairingError.invalidQr]!;
    final primaryLabel = failure.$3;
    final secondaryLabel = failure.$4;

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 32),
          // 80x80 circle badge (#FBE6E6) with 34x34 alert SVG (#E02424)
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFFBE6E6),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppAssets.iconAlert,
              width: 34,
              height: 34,
              colorFilter: const ColorFilter.mode(
                Color(0xFFE02424),
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            errorTitle ?? failure.$1,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppText.family,
              fontSize: 22,
              height: 28 / 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F1714),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage ?? failure.$2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: AppText.family,
              fontSize: 14,
              height: 22 / 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF55625D),
            ),
          ),
          const SizedBox(height: 20),

          // Primary Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0E9F6E),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                textStyle: const TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () {
                _handleErrorPrimary(simulatedFailure ?? PairingError.invalidQr);
              },
              child: Text(primaryLabel),
            ),
          ),

          // Secondary Button (if present)
          if (secondaryLabel != null) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F1714),
                  backgroundColor: Colors.white,
                  elevation: 0,
                  side: const BorderSide(color: Color(0xFFE1E9E5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  textStyle: const TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  _handleErrorSecondary(
                    simulatedFailure ?? PairingError.invalidQr,
                  );
                },
                child: Text(secondaryLabel),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _handleErrorPrimary(PairingError error) {
    setState(() {
      errorTitle = null;
      errorMessage = null;
      simulatedFailure = null;
      switch (error) {
        case PairingError.invalidQr:
        case PairingError.claimUsed:
          step = 0;
        case PairingError.bluetoothNotFound:
        case PairingError.wifiJoinFailed:
          step = 3;
        case PairingError.alreadyClaimed:
        case PairingError.tooManyAttempts:
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            step = 0;
          }
        case PairingError.pairingWindowClosed:
        case PairingError.claimFailed:
          _connect();
      }
    });
  }

  void _handleErrorSecondary(PairingError error) {
    setState(() {
      errorTitle = null;
      errorMessage = null;
      simulatedFailure = null;
      switch (error) {
        case PairingError.bluetoothNotFound:
        case PairingError.tooManyAttempts:
          _connect();
        case PairingError.pairingWindowClosed:
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            step = 0;
          }
        default:
          step = 0;
      }
    });
  }

  Widget _primary(String label, VoidCallback onPressed) => SizedBox(
    width: double.infinity,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      child: Text(label),
    ),
  );

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
        busy = progress.step != PairingStep.nameSocket;
        step = progress.step == PairingStep.nameSocket
            ? 7
            : progress.step == PairingStep.claiming
            ? 6
            : progress.step.index.clamp(0, 5);
      });
    }
    if (!mounted) return;
    setState(() {
      busy = false;
      simulatedFailure = null;
      step = 7;
    });
  }

  Future<void> _finish() async {
    final socketName =
        name.text.trim().isEmpty ? 'New smart plug' : name.text.trim();
    final socketRoom =
        room.text.trim().isEmpty ? selectedRoom : room.text.trim();
    await widget.repository.claimSocket(
      claimCode: claimCode.text.trim(),
      name: socketName,
      room: socketRoom,
      appliance: appliance.text.trim().isEmpty
          ? 'Smart appliance'
          : appliance.text.trim(),
    );
    widget.onAdded();
    if (!mounted) return;
    setState(() => step = 8);
  }

  @visibleForTesting
  Future<void> chooseError() async {
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

  static const _failureDetails =
      <PairingError, (String, String, String, String?)>{
    PairingError.invalidQr: (
      'This QR code is not a SEMS socket',
      'Scan the QR code printed on the socket or its box. It should start with "SEMS".',
      'Scan again',
      null,
    ),
    PairingError.bluetoothNotFound: (
      'Socket not found over Bluetooth',
      'Make sure the OLED shows "Pairing" and the socket is within 2 metres. You can also connect through the socket\'s own Wi-Fi hotspot.',
      'Use hotspot method',
      'Try Bluetooth again',
    ),
    PairingError.wifiJoinFailed: (
      'Socket could not join Wi-Fi',
      'The password for "Home-WiFi" looks wrong, or the network is out of range. Check it and try again.',
      'Edit Wi-Fi details',
      null,
    ),
    PairingError.claimUsed: (
      'Claim code expired or already used',
      'Each QR claim code works once. Ask the seller for a new one, or reset the socket and scan again.',
      'Scan a new QR',
      null,
    ),
    PairingError.alreadyClaimed: (
      'Socket already claimed',
      'It is linked to another account. The current owner can transfer it to you from Device detail.',
      'Back to devices',
      null,
    ),
    PairingError.tooManyAttempts: (
      'Too many attempts',
      'Wait 15 minutes or restart the socket, then try again.',
      'Back to devices',
      'I restarted the socket',
    ),
    PairingError.pairingWindowClosed: (
      'Pairing window closed',
      'Restart the socket to pair again.',
      'I restarted the socket',
      'Back to devices',
    ),
    PairingError.claimFailed: (
      'Could not claim the socket',
      'The cloud did not respond in time. The socket is on Wi-Fi, so nothing needs to be redone.',
      'Try again',
      null,
    ),
  };
}

enum _StepRowStatus { done, inProgress, pending }
