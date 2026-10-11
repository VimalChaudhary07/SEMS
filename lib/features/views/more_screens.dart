import 'package:flutter/material.dart';

export 'schedules_screen.dart' show SchedulesScreen;

import '../../core/theme/app_theme.dart';
import '../../data/repositories/sems_repository.dart';
import '../../shared/widgets/sems_widgets.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key});
  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  int period = 0;
  @override
  Widget build(BuildContext context) {
    final amount = period == 0
        ? '₹1,284'
        : period == 1
        ? '₹1,462'
        : '₹1,318';
    return Scaffold(
      appBar: AppBar(title: const Text('Estimated bill')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const PageHeading(
            title: 'Your energy bill',
            subtitle: 'Estimate based on sample usage',
          ),
          const SizedBox(height: 18),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('This month')),
              ButtonSegment(value: 1, label: Text('Last month')),
              ButtonSegment(value: 2, label: Text('2 months ago')),
            ],
            selected: {period},
            onSelectionChanged: (v) => setState(() => period = v.first),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ESTIMATED TOTAL',
                  style: TextStyle(
                    color: SemsColors.muted,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Estimated from 151 kWh at ₹8.50 per kWh',
                  style: TextStyle(color: SemsColors.muted, fontSize: 12),
                ),
                const SizedBox(height: 18),
                const LinearProgressIndicator(
                  value: .72,
                  minHeight: 8,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  backgroundColor: SemsColors.mint,
                ),
                const SizedBox(height: 8),
                const Text(
                  '72% of your ₹1,800 monthly budget',
                  style: TextStyle(color: SemsColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionTitle('Bill breakdown'),
          const SizedBox(height: 10),
          const _BillRow(label: 'Energy charges', value: '₹1,283.50'),
          const _BillRow(label: 'Fixed charge', value: '₹75.00'),
          const _BillRow(label: 'Taxes and adjustments', value: '₹108.00'),
          const Divider(height: 24),
          const _BillRow(
            label: 'Estimated total',
            value: '₹1,466.50',
            bold: true,
          ),
          const SizedBox(height: 16),
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
                    'This is an illustrative estimate using sample readings and a sample tariff. It is not a utility bill.',
                    style: TextStyle(
                      color: SemsColors.muted,
                      fontSize: 12,
                      height: 1.4,
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
}

class _BillRow extends StatelessWidget {
  const _BillRow({required this.label, required this.value, this.bold = false});
  final String label, value;
  final bool bold;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: bold ? SemsColors.ink : SemsColors.muted,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class BillRecordsScreen extends StatefulWidget {
  const BillRecordsScreen({super.key});
  @override
  State<BillRecordsScreen> createState() => _BillRecordsScreenState();
}

class _BillRecordsScreenState extends State<BillRecordsScreen> {
  final records = <(String, String, String)>[
    ('Sep 2026', '232 kWh · ₹8.02/kWh', '₹1,860'),
    ('Aug 2026', '251 kWh · ₹8.14/kWh', '₹2,043'),
    ('Jul 2026', '214 kWh · ₹7.85/kWh', '₹1,679'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Bill records'),
      actions: [
        IconButton(
          onPressed: _add,
          tooltip: 'Add bill',
          icon: const Icon(Icons.add_rounded),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const PageHeading(
          title: 'Bill records',
          subtitle: 'Sample utility bill history',
        ),
        const SizedBox(height: 14),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < records.length; i++)
                Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: SemsColors.mint,
                        child: Icon(
                          Icons.receipt_long_outlined,
                          color: SemsColors.forest,
                          size: 18,
                        ),
                      ),
                      title: Text(
                        records[i].$1,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      subtitle: Text(
                        records[i].$2,
                        style: const TextStyle(
                          color: SemsColors.muted,
                          fontSize: 10,
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            records[i].$3,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const Text(
                            'Billed',
                            style: TextStyle(
                              color: SemsColors.muted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (i < records.length - 1)
                      const Divider(height: 1, indent: 58),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const AppCard(
          child: Text(
            'Past bills are example records. Adding a bill only updates this screen session.',
            style: TextStyle(color: SemsColors.muted, fontSize: 12),
          ),
        ),
      ],
    ),
  );

  Future<void> _add() async {
    final period = TextEditingController();
    final energy = TextEditingController();
    final amount = TextEditingController();
    final form = GlobalKey<FormState>();
    final entry = await showModalBottomSheet<(String, String, String)>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 20,
        ),
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Add actual bill',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: period,
                decoration: const InputDecoration(
                  labelText: 'Billing period',
                  hintText: 'Oct 2026',
                ),
                validator: _required,
              ),
              TextFormField(
                controller: energy,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Energy used',
                  suffixText: 'kWh',
                ),
                validator: _positive,
              ),
              TextFormField(
                controller: amount,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Bill amount',
                  prefixText: '₹ ',
                ),
                validator: _positive,
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: () {
                  if (form.currentState!.validate()) {
                    Navigator.pop(context, (
                      period.text.trim(),
                      '${energy.text.trim()} kWh · actual bill',
                      '₹${amount.text.trim()}',
                    ));
                  }
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Save bill'),
              ),
            ],
          ),
        ),
      ),
    );
    period.dispose();
    energy.dispose();
    amount.dispose();
    if (entry != null && mounted) setState(() => records.insert(0, entry));
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Required' : null;
  String? _positive(String? value) => (double.tryParse(value ?? '') ?? 0) <= 0
      ? 'Enter a value greater than zero'
      : null;
}

class DeviceSetupScreen extends StatefulWidget {
  const DeviceSetupScreen({
    super.key,
    required this.repository,
    required this.onAdded,
  });
  final SemsRepository repository;
  final VoidCallback onAdded;
  @override
  State<DeviceSetupScreen> createState() => _DeviceSetupScreenState();
}

class _DeviceSetupScreenState extends State<DeviceSetupScreen> {
  int step = 0;
  final name = TextEditingController();
  final room = TextEditingController();
  final appliance = TextEditingController();
  final form = GlobalKey<FormState>();
  bool scanning = false;
  @override
  void dispose() {
    name.dispose();
    room.dispose();
    appliance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Set up a device')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        PageHeading(
          title: step == 0 ? 'Connect your smart plug' : 'Name your device',
          subtitle: 'Step ${step + 1} of 2',
        ),
        const SizedBox(height: 20),
        if (step == 0) ...[
          AppCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 132,
                  height: 132,
                  decoration: BoxDecoration(
                    color: SemsColors.mint,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    scanning
                        ? Icons.radar_rounded
                        : Icons.qr_code_scanner_rounded,
                    size: 74,
                    color: SemsColors.forest,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  scanning
                      ? 'Looking for a nearby SEMS plug…'
                      : 'Scan your device QR code',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Camera access is not enabled in this preview. Use the simulated scan to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: SemsColors.muted,
                    fontSize: 12,
                    height: 1.4,
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
                  child: const Text('Enter setup manually'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const AppCard(
            child: Row(
              children: [
                Icon(Icons.wifi_rounded, color: SemsColors.forest),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Connect your phone to the 2.4 GHz Wi-Fi network used by the plug.',
                    style: TextStyle(color: SemsColors.muted, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ] else
          Form(
            key: form,
            child: Column(
              children: [
                const AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Device found',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'SEMS Smart Plug · Demo ID: SEMS-0042',
                        style: TextStyle(color: SemsColors.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                    labelText: 'Device name',
                    hintText: 'e.g. Living room plug',
                  ),
                  validator: _required,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: appliance,
                  decoration: const InputDecoration(
                    labelText: 'Appliance',
                    hintText: 'e.g. Television',
                  ),
                  validator: _required,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: room,
                  decoration: const InputDecoration(
                    labelText: 'Room',
                    hintText: 'e.g. Living room',
                  ),
                  validator: _required,
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: _finish,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Add to my devices'),
                ),
                TextButton(
                  onPressed: () => setState(() => step = 0),
                  child: const Text('Back'),
                ),
              ],
            ),
          ),
      ],
    ),
  );
  String? _required(String? v) =>
      v == null || v.trim().isEmpty ? 'This field is required' : null;
  Future<void> _simulateScan() async {
    setState(() => scanning = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      scanning = false;
      step = 1;
      name.text = 'New smart plug';
      appliance.text = 'Smart appliance';
    });
  }

  Future<void> _finish() async {
    if (!form.currentState!.validate()) return;
    await widget.repository.addDevice(
      name: name.text.trim(),
      room: room.text.trim(),
      appliance: appliance.text.trim(),
    );
    widget.onAdded();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo device added. No hardware was paired.'),
      ),
    );
    Navigator.pop(context);
  }
}

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});
  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  String? lastAction;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Backup and restore')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const PageHeading(
          title: 'Your data, your choice',
          subtitle: 'Preview local backup actions',
        ),
        const SizedBox(height: 18),
        const AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.cloud_outlined, color: SemsColors.forest, size: 32),
              SizedBox(height: 12),
              Text(
                'Backup is not connected',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
              ),
              SizedBox(height: 5),
              Text(
                'This demo does not sign in to Google Drive or write backup files. These buttons demonstrate the intended interaction only.',
                style: TextStyle(
                  color: SemsColors.muted,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => setState(
            () => lastAction = 'Backup prepared locally for this preview.',
          ),
          icon: const Icon(Icons.backup_outlined),
          label: const Text('Create a backup'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => _restore(context),
          icon: const Icon(Icons.restore_rounded),
          label: const Text('Restore from backup'),
        ),
        if (lastAction != null) ...[
          const SizedBox(height: 14),
          AppCard(
            child: Text(
              lastAction!,
              style: const TextStyle(
                color: SemsColors.forest,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    ),
  );
  Future<void> _restore(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore preview data?'),
        content: const Text(
          'This demo has no backup file to restore. Return to the sample data?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      setState(
        () => lastAction =
            'Sample preview data is already active. No file was changed.',
      );
    }
  }
}

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});
  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  String query = '';
  final entries = const [
    (
      'How do I add a smart plug?',
      'Open Devices, choose Set up a device, then scan the QR code or enter the details manually. Scanning is simulated in this preview.',
    ),
    (
      'Are the readings real?',
      'No. All readings in this frontend are sample values stored locally.',
    ),
    (
      'Does turning a device on control hardware?',
      'No. Switches update the local demo state only; no MQTT command is sent.',
    ),
    (
      'How is the bill estimated?',
      'The estimate uses sample energy totals and the local tariff value shown in Settings.',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final visible = entries
        .where(
          (e) => '${e.$1} ${e.$2}'.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Help and support')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const PageHeading(
            title: 'How can we help?',
            subtitle: 'Quick answers for the SEMS preview',
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded),
              hintText: 'Search help topics',
            ),
            onChanged: (v) => setState(() => query = v),
          ),
          const SizedBox(height: 14),
          for (final e in visible)
            Card(
              child: ExpansionTile(
                title: Text(
                  e.$1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Text(
                    e.$2,
                    style: const TextStyle(
                      color: SemsColors.muted,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          if (visible.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text('No help topics match that search.'),
            ),
        ],
      ),
    );
  }
}
