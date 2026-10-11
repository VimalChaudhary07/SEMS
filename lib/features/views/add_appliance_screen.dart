import 'package:flutter/material.dart';

import '../../core/session/demo_session.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/sems_models.dart';
import '../../data/repositories/sems_repository.dart';
import '../../shared/widgets/sems_widgets.dart';

class AddApplianceScreen extends StatefulWidget {
  const AddApplianceScreen({super.key, required this.repository});

  final SemsRepository repository;

  @override
  State<AddApplianceScreen> createState() => _AddApplianceScreenState();
}

class _AddApplianceScreenState extends State<AddApplianceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ratedPowerController = TextEditingController();
  String _category = 'Heater';
  String? _socketId;
  bool _saving = false;

  static const _categories = <(String, IconData)>[
    ('Heater', Icons.local_fire_department_outlined),
    ('Fan', Icons.toys_outlined),
    ('Fridge', Icons.kitchen_outlined),
    ('Water htr', Icons.water_drop_outlined),
    ('AC', Icons.ac_unit_rounded),
    ('Lighting', Icons.lightbulb_outline_rounded),
    ('Television', Icons.tv_outlined),
    ('Other', Icons.bolt_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _nameController.text = 'Room heater';
    for (final device in widget.repository.devices) {
      if (device.online) {
        _socketId = device.id;
        break;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ratedPowerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sockets = widget.repository.devices;
    SemsDevice? selectedSocket;
    for (final socket in sockets) {
      if (socket.id == _socketId) selectedSocket = socket;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add appliance'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Chip(label: Text(DemoSession.isMember ? 'Member' : 'Owner')),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            const SectionTitle('NAME'),
            const SizedBox(height: 7),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(hintText: 'Room heater'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Name is required'
                  : null,
            ),
            const SizedBox(height: 18),
            const SectionTitle('CATEGORY'),
            const SizedBox(height: 7),
            GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: .92,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final category in _categories)
                  _CategoryTile(
                    label: category.$1,
                    icon: category.$2,
                    selected: _category == category.$1,
                    enabled: !_saving,
                    onTap: () => setState(() => _category = category.$1),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            const SectionTitle('RATED POWER (OPTIONAL)'),
            const SizedBox(height: 7),
            TextFormField(
              controller: _ratedPowerController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(suffixText: 'W'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return null;
                final watts = int.tryParse(value.trim());
                return watts == null || watts <= 0
                    ? 'Enter a power greater than 0'
                    : null;
              },
            ),
            const SizedBox(height: 5),
            const Text(
              'Used to flag unusual power draw',
              style: TextStyle(color: SemsColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 18),
            const SectionTitle('CONNECT TO SOCKET'),
            const SizedBox(height: 7),
            RadioGroup<String?>(
              groupValue: _socketId,
              onChanged: (value) {
                if (!_saving) setState(() => _socketId = value);
              },
              child: Column(
                children: [
                  for (final socket in sockets)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: _socketId == socket.id
                              ? SemsColors.mint
                              : Colors.white,
                          border: Border.all(
                            color: _socketId == socket.id
                                ? SemsColors.green
                                : const Color(0xFFDDE5E1),
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: RadioListTile<String?>(
                          value: socket.id,
                          enabled: !_saving && socket.online,
                          title: Text(socket.name),
                          subtitle: Text(
                            '${socket.id} · ${socket.online ? 'currently ${socket.appliance}' : 'Offline'}',
                          ),
                          secondary: const Icon(Icons.power_rounded),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: _socketId == null
                            ? SemsColors.mint
                            : Colors.white,
                        border: Border.all(
                          color: _socketId == null
                              ? SemsColors.green
                              : const Color(0xFFDDE5E1),
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const RadioListTile<String?>(
                        value: null,
                        title: Text('Assign later'),
                        subtitle: Text('Create it now, connect it later'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (selectedSocket != null &&
                selectedSocket.appliance != 'Unassigned') ...[
              AppCard(
                color: const Color(0xFFFFF3DF),
                child: Text(
                  '${selectedSocket.appliance} will be unassigned. Its session closes at the current meter reading and its history stays.',
                  style: const TextStyle(height: 1.4),
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (selectedSocket != null)
              Text(
                'Creating it opens a new usage session starting at meter ${selectedSocket.meterKwh.toStringAsFixed(1)} kWh.',
                style: const TextStyle(
                  color: SemsColors.muted,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            if (DemoSession.isMember) ...[
              const SizedBox(height: 12),
              const AppCard(
                child: Text(
                  'Family members can view appliances. Ask the owner to add or assign one.',
                  style: TextStyle(color: SemsColors.muted),
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton(
            onPressed: _saving || DemoSession.isMember ? null : _save,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: Text(_saving ? 'Adding…' : 'Create appliance'),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await widget.repository.addAppliance(
        name: _nameController.text.trim(),
        category: _category,
        ratedPowerW: int.tryParse(_ratedPowerController.text.trim()),
        socketId: _socketId,
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not add appliance: $error')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: enabled ? onTap : null,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      decoration: BoxDecoration(
        color: selected ? SemsColors.mint : Colors.white,
        border: Border.all(
          color: selected ? SemsColors.green : const Color(0xFFDDE5E1),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: selected ? SemsColors.forest : SemsColors.muted),
          const SizedBox(height: 5),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    ),
  );
}
