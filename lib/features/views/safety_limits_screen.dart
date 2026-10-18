import 'package:flutter/material.dart';

import '../../core/session/demo_session.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/sems_models.dart';
import '../../data/repositories/sems_repository.dart';
import '../../shared/widgets/sems_widgets.dart';

class SafetyLimitsScreen extends StatefulWidget {
  const SafetyLimitsScreen({super.key, required this.device, this.repository});

  final SemsDevice device;
  final SemsRepository? repository;

  @override
  State<SafetyLimitsScreen> createState() => _SafetyLimitsScreenState();
}

class _SafetyLimitsScreenState extends State<SafetyLimitsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _maxCurrent = TextEditingController(text: '16');
  final _maxPower = TextEditingController(text: '3680');
  final _minVoltage = TextEditingController(text: '200');
  final _maxVoltage = TextEditingController(text: '250');

  bool get _readOnly => DemoSession.isMember;

  @override
  void initState() {
    super.initState();
    _maxCurrent.text = _formatLimit(widget.device.safetyLimits.maxCurrentA);
    _maxPower.text = _formatLimit(widget.device.safetyLimits.maxPowerW);
    _minVoltage.text = _formatLimit(widget.device.safetyLimits.minVoltageV);
    _maxVoltage.text = _formatLimit(widget.device.safetyLimits.maxVoltageV);
  }

  @override
  void dispose() {
    _maxCurrent.dispose();
    _maxPower.dispose();
    _minVoltage.dispose();
    _maxVoltage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Safety limits'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Center(child: RoleBadge(isFamily: _readOnly)),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            '${widget.device.name} · ${widget.device.id}',
            style: const TextStyle(color: SemsColors.muted, fontSize: 12),
          ),
        ),
        const AppBanner(
          tone: StatusTone.brand,
          icon: Icons.shield_outlined,
          title: 'Applies on the socket',
          body: 'It recovers by itself after 60 s, up to 3 times.',
        ),
        const SizedBox(height: 16),
        if (_readOnly)
          _readOnlyValues()
        else
          Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _limitField(
                        label: 'Max current',
                        controller: _maxCurrent,
                        unit: 'A',
                        max: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _limitField(
                        label: 'Max power',
                        controller: _maxPower,
                        unit: 'W',
                        max: 3680,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _limitField(
                        label: 'Min voltage',
                        controller: _minVoltage,
                        unit: 'V',
                        min: 100,
                        max: 250,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _limitField(
                        label: 'Max voltage',
                        controller: _maxVoltage,
                        unit: 'V',
                        min: 100,
                        max: 250,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                AppButton(label: 'Save limits', onPressed: _save),
              ],
            ),
          ),
        if (_readOnly) ...[
          const SizedBox(height: 14),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 14,
                color: SemsColors.muted,
              ),
              SizedBox(width: 5),
              Text(
                'Only the Owner can change this',
                style: TextStyle(color: SemsColors.muted, fontSize: 12),
              ),
            ],
          ),
        ],
      ],
    ),
  );

  Widget _limitField({
    required String label,
    required TextEditingController controller,
    required String unit,
    required double max,
    double min = 1,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: SemsColors.muted, fontSize: 12),
      ),
      const SizedBox(height: 5),
      TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          suffixText: unit,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
        validator: (value) {
          final number = double.tryParse(value ?? '');
          if (number == null || number < min || number > max) {
            return 'Enter ${_formatLimit(min)} to ${_formatLimit(max)} $unit';
          }
          return null;
        },
      ),
    ],
  );

  Widget _readOnlyValues() {
    final values = [
      ('Max current', _maxCurrent.text, 'A'),
      ('Max power', _maxPower.text, 'W'),
      ('Min voltage', _minVoltage.text, 'V'),
      ('Max voltage', _maxVoltage.text, 'V'),
    ];
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < values.length; i++) ...[
            if (i > 0) const Divider(height: 1),
            ListTile(
              title: Text(values[i].$1),
              trailing: Text(
                '${values[i].$2} ${values[i].$3}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final minVoltage = double.parse(_minVoltage.text);
    final maxVoltage = double.parse(_maxVoltage.text);
    if (minVoltage >= maxVoltage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Minimum voltage must be below maximum voltage.'),
        ),
      );
      return;
    }
    final limits = SemsSafetyLimits(
      maxCurrentA: double.parse(_maxCurrent.text),
      maxPowerW: double.parse(_maxPower.text),
      minVoltageV: minVoltage,
      maxVoltageV: maxVoltage,
    );
    final repository = widget.repository;
    if (repository != null) {
      await repository.saveSafetyLimits(widget.device.id, limits);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Safety limits saved for this socket.')),
    );
  }

  static String _formatLimit(double value) =>
      value == value.roundToDouble() ? value.toInt().toString() : '$value';
}
