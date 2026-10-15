import 'package:flutter/material.dart';

import '../../core/session/demo_session.dart';
import '../../data/repositories/sems_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/sems_widgets.dart';
import 'more_screens.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});
  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final name = TextEditingController(text: 'Asha Verma');
  final email = TextEditingController(text: 'owner@sems.app');
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Profile')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const PageHeading(
          title: 'Your profile',
          subtitle: 'Update the local demo profile',
        ),
        const SizedBox(height: 18),
        const Center(
          child: CircleAvatar(
            radius: 42,
            backgroundColor: SemsColors.forest,
            child: Text(
              'AV',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        TextField(
          controller: name,
          decoration: const InputDecoration(labelText: 'Full name'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: email,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: () {
            if (name.text.trim().isEmpty || !email.text.contains('@')) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enter a valid name and email.')),
              );
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile saved for this session.')),
            );
          },
          child: const Text('Save changes'),
        ),
        const SizedBox(height: 16),
        const AppCard(
          child: Text(
            'Password changes and account verification are not connected to an identity service.',
            style: TextStyle(color: SemsColors.muted, fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});
  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool safety = true,
      budget = true,
      connectivity = true,
      insights = true,
      quietHours = false;
  TimeOfDay quietStart = const TimeOfDay(hour: 22, minute: 0),
      quietEnd = const TimeOfDay(hour: 7, minute: 0);
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Notification rules')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const PageHeading(
          title: 'Stay informed',
          subtitle: 'Choose which sample alerts appear',
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Electrical safety'),
                subtitle: const Text('Over-current and safety trips'),
                value: safety,
                onChanged: (v) => setState(() => safety = v),
              ),
              SwitchListTile(
                title: const Text('Energy and budget'),
                subtitle: const Text('Usage trends and budget thresholds'),
                value: budget,
                onChanged: (v) => setState(() => budget = v),
              ),
              SwitchListTile(
                title: const Text('Connectivity'),
                subtitle: const Text('Socket offline and reconnects'),
                value: connectivity,
                onChanged: (v) => setState(() => connectivity = v),
              ),
              SwitchListTile(
                title: const Text('AI insights'),
                subtitle: const Text('Anomaly and savings suggestions'),
                value: insights,
                onChanged: (v) => setState(() => insights = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Quiet hours'),
                subtitle: const Text('Mute non-critical notifications'),
                value: quietHours,
                onChanged: (v) => setState(() => quietHours = v),
              ),
              if (quietHours)
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => _pick(context, true),
                        child: Text('From ${quietStart.format(context)}'),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () => _pick(context, false),
                        child: Text('Until ${quietEnd.format(context)}'),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const AppCard(
          child: Text(
            'Notification preferences are local demo state only. No push notification service is active.',
            style: TextStyle(color: SemsColors.muted, fontSize: 12),
          ),
        ),
      ],
    ),
  );
  Future<void> _pick(BuildContext context, bool start) async {
    final value = await showTimePicker(
      context: context,
      initialTime: start ? quietStart : quietEnd,
    );
    if (value != null && mounted) {
      setState(() => start ? quietStart = value : quietEnd = value);
    }
  }
}

class FamilySettingsScreen extends StatefulWidget {
  const FamilySettingsScreen({super.key});
  @override
  State<FamilySettingsScreen> createState() => _FamilySettingsScreenState();
}

class _FamilySettingsScreenState extends State<FamilySettingsScreen> {
  final List<(String, String)> members = [
    ('Asha Verma', 'Owner'),
    ('Maya Verma', 'Member'),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Family and permissions'),
      actions: [
        if (!DemoSession.isMember)
          IconButton(
            onPressed: _invite,
            icon: const Icon(Icons.person_add_alt_1_outlined),
          ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const PageHeading(
          title: 'Your household',
          subtitle: '2 members · local preview',
        ),
        const SizedBox(height: 14),
        AppCard(
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Preview as family member'),
            subtitle: const Text(
              'Applies read-only limits across the demo UI.',
            ),
            value: DemoSession.isMember,
            onChanged: (value) => setState(() {
              DemoSession.role.value = value ? DemoRole.member : DemoRole.owner;
            }),
          ),
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < members.length; i++)
          AppCard(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: SemsColors.mint,
                child: Text(
                  members[i].$1.substring(0, 1),
                  style: const TextStyle(color: SemsColors.forest),
                ),
              ),
              title: Text(
                members[i].$1,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(members[i].$2),
              trailing: i == 0
                  ? const Icon(
                      Icons.verified_user_outlined,
                      color: SemsColors.forest,
                    )
                  : DemoSession.isMember
                  ? const Text(
                      'View only',
                      style: TextStyle(color: SemsColors.muted, fontSize: 10),
                    )
                  : PopupMenuButton<String>(
                      onSelected: (v) {
                        if (v == 'remove') {
                          _remove(i);
                        } else {
                          _role(i);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'role',
                          child: Text('Change role'),
                        ),
                        PopupMenuItem(
                          value: 'remove',
                          child: Text('Remove member'),
                        ),
                      ],
                    ),
            ),
          ),
        const SizedBox(height: 14),
        const SectionTitle('WHAT EACH ROLE CAN DO'),
        const SizedBox(height: 8),
        const AppCard(
          child: Column(
            children: [
              _RoleRow(
                role: 'Owner',
                details: 'Manage devices, billing, family, and settings',
              ),
              Divider(),
              _RoleRow(
                role: 'Member',
                details:
                    'Control sockets, view appliances, history, and alerts',
              ),
            ],
          ),
        ),
      ],
    ),
  );
  Future<void> _invite() async {
    final form = GlobalKey<FormState>();
    final email = TextEditingController();
    String role = 'Member';
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: const Text('Invite a family member'),
          content: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email address'),
                  validator: (v) => v == null || !v.contains('@')
                      ? 'Enter a valid email'
                      : null,
                ),
                DropdownButtonFormField<String>(
                  initialValue: role,
                  decoration: const InputDecoration(labelText: 'Role'),
                  items: const [
                    DropdownMenuItem(value: 'Member', child: Text('Member')),
                    DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                  ],
                  onChanged: (v) => setLocal(() => role = v ?? role),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (form.currentState!.validate()) {
                  Navigator.pop(context, (email.text.trim(), role));
                }
              },
              child: const Text('Invite'),
            ),
          ],
        ),
      ),
    );
    email.dispose();
    if (result != null && mounted) {
      setState(() => members.add((result.$1, result.$2)));
    }
  }

  Future<void> _role(int i) async {
    final role = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Change member role'),
        children: [
          for (final value in ['Member', 'Admin'])
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, value),
              child: Text(value),
            ),
        ],
      ),
    );
    if (role != null && mounted) {
      setState(() => members[i] = (members[i].$1, role));
    }
  }

  Future<void> _remove(int i) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove member?'),
        content: Text('Remove ${members[i].$1} from this demo household?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) setState(() => members.removeAt(i));
  }
}

class _RoleRow extends StatelessWidget {
  const _RoleRow({required this.role, required this.details});
  final String role, details;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 64,
          child: Text(
            role,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: Text(
            details,
            style: const TextStyle(color: SemsColors.muted, fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

class TariffSettingsScreen extends StatefulWidget {
  const TariffSettingsScreen({
    super.key,
    this.repository,
    this.readOnly = false,
  });
  final SemsRepository? repository;
  final bool readOnly;
  @override
  State<TariffSettingsScreen> createState() => _TariffSettingsScreenState();
}

class _TariffSettingsScreenState extends State<TariffSettingsScreen> {
  final tariff = TextEditingController(text: '8.50');
  final budget = TextEditingController(text: '1900');
  String billingDay = '1st of the month';
  @override
  void dispose() {
    tariff.dispose();
    budget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Billing settings')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const PageHeading(
          title: 'Billing settings',
          subtitle: 'Example data · Indian rupee',
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CURRENT PERIOD',
                style: TextStyle(
                  color: SemsColors.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Expanded(
                    child: _ValueBlock(
                      title: 'Measured energy',
                      value: '168.4 kWh',
                      note: 'Measured, so far this period',
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _ValueBlock(
                      title: 'Estimated bill',
                      value: '₹1,292',
                      note: 'Estimated, if usage stops today',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Monthly budget',
                style: TextStyle(color: SemsColors.muted, fontSize: 12),
              ),
              const SizedBox(height: 3),
              const Text(
                '₹1,292 / ₹1,900',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const LinearProgressIndicator(
                value: .68,
                minHeight: 6,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              const SizedBox(height: 5),
              const Text(
                '68% used · sample readings',
                style: TextStyle(color: SemsColors.muted, fontSize: 10),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const SectionTitle('TARIFF'),
        const SizedBox(height: 8),
        AppCard(
          child: Column(
            children: [
              TextField(
                controller: tariff,
                readOnly: widget.readOnly,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Estimated rate',
                  prefixText: '₹ ',
                  suffixText: '/ kWh',
                ),
              ),
              TextField(
                controller: budget,
                readOnly: widget.readOnly,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monthly budget',
                  prefixText: '₹ ',
                ),
              ),
              DropdownButtonFormField<String>(
                initialValue: billingDay,
                decoration: const InputDecoration(labelText: 'Billing day'),
                items: const [
                  DropdownMenuItem(
                    value: '1st of the month',
                    child: Text('1st of the month'),
                  ),
                  DropdownMenuItem(
                    value: '15th of the month',
                    child: Text('15th of the month'),
                  ),
                ],
                onChanged: widget.readOnly
                    ? null
                    : (v) => setState(() => billingDay = v ?? billingDay),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (!widget.readOnly)
          FilledButton(
            onPressed: () {
              if ((double.tryParse(tariff.text) ?? 0) <= 0 ||
                  (double.tryParse(budget.text) ?? 0) <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Enter a rate and budget greater than zero.'),
                  ),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Billing settings saved for this session.'),
                ),
              );
            },
            child: const Text('Save billing settings'),
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => BillRecordsScreen(repository: widget.repository),
            ),
          ),
          icon: const Icon(Icons.receipt_long_outlined),
          label: const Text('View bill records'),
        ),
        const SizedBox(height: 10),
        const AppCard(
          child: Text(
            'Tiered tariff tables, taxes, and bill comparisons are illustrative only. No utility-provider data is connected.',
            style: TextStyle(color: SemsColors.muted, fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

class _ValueBlock extends StatelessWidget {
  const _ValueBlock({
    required this.title,
    required this.value,
    required this.note,
  });
  final String title, value, note;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: SemsColors.canvas,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: SemsColors.muted, fontSize: 10),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        Text(
          note,
          style: const TextStyle(color: SemsColors.muted, fontSize: 9),
        ),
      ],
    ),
  );
}

class AiSettingsScreen extends StatefulWidget {
  const AiSettingsScreen({super.key});
  @override
  State<AiSettingsScreen> createState() => _AiSettingsScreenState();
}

class _AiSettingsScreenState extends State<AiSettingsScreen> {
  bool anomalies = true, savings = true, budgetAlerts = true;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('AI settings')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const PageHeading(
          title: 'On-device insights',
          subtitle: 'Local sample preference controls',
        ),
        const SizedBox(height: 14),
        const AppCard(
          child: Text(
            'The design describes on-device analysis. This preview uses static sample recommendations and does not run an AI model.',
            style: TextStyle(
              color: SemsColors.muted,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Unusual consumption'),
                value: anomalies,
                onChanged: (v) => setState(() => anomalies = v),
              ),
              SwitchListTile(
                title: const Text('Potential savings'),
                value: savings,
                onChanged: (v) => setState(() => savings = v),
              ),
              SwitchListTile(
                title: const Text('Forecast and budget alerts'),
                value: budgetAlerts,
                onChanged: (v) => setState(() => budgetAlerts = v),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class StorageSettingsScreen extends StatefulWidget {
  const StorageSettingsScreen({super.key});
  @override
  State<StorageSettingsScreen> createState() => _StorageSettingsScreenState();
}

class _StorageSettingsScreenState extends State<StorageSettingsScreen> {
  String retention = '12 months';
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Storage and retention')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const PageHeading(
          title: 'Local storage',
          subtitle: 'Sample storage use on this device',
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Storage used',
                      style: TextStyle(color: SemsColors.muted),
                    ),
                  ),
                  Text('1.4 GB', style: TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 10),
              const LinearProgressIndicator(value: .28, minHeight: 6),
              const SizedBox(height: 8),
              const Text(
                'Energy history 1.1 GB · app data 0.3 GB',
                style: TextStyle(color: SemsColors.muted, fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: DropdownButtonFormField<String>(
            initialValue: retention,
            decoration: const InputDecoration(
              labelText: 'Keep energy history for',
            ),
            items: const [
              DropdownMenuItem(value: '3 months', child: Text('3 months')),
              DropdownMenuItem(value: '6 months', child: Text('6 months')),
              DropdownMenuItem(value: '12 months', child: Text('12 months')),
              DropdownMenuItem(value: 'Forever', child: Text('Forever')),
            ],
            onChanged: (v) => setState(() => retention = v ?? retention),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Clear local preview data?'),
                content: const Text(
                  'Only sample data is present. Clearing it is not enabled in this preview.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.delete_outline),
          label: const Text('Clear local data'),
        ),
        const SizedBox(height: 8),
        const AppCard(
          child: Text(
            'Storage figures and history controls are illustrative. The preview does not write energy telemetry to disk.',
            style: TextStyle(color: SemsColors.muted, fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Privacy and data')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const PageHeading(
          title: 'Your data stays yours',
          subtitle: 'Local preview data and export options',
        ),
        const SizedBox(height: 14),
        const AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Example data only',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 6),
              Text(
                'The energy readings, alerts, and recommendations shown in this app are hard-coded mock data. The frontend does not send them to a server.',
                style: TextStyle(
                  color: SemsColors.muted,
                  fontSize: 12,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        FilledButton.icon(
          onPressed: () => _export(context, 'CSV'),
          icon: const Icon(Icons.download_outlined),
          label: const Text('Export data as CSV'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _export(context, 'JSON'),
          icon: const Icon(Icons.data_object_outlined),
          label: const Text('Export data as JSON'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _export(context, 'PDF'),
          icon: const Icon(Icons.picture_as_pdf_outlined),
          label: const Text('Export data as PDF'),
        ),
        const SizedBox(height: 14),
        const AppCard(
          child: Text(
            'Export actions demonstrate the UI only. No file is created in the app sandbox.',
            style: TextStyle(color: SemsColors.muted, fontSize: 12),
          ),
        ),
      ],
    ),
  );
  static void _export(BuildContext context, String format) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$format export prepared for this preview.')),
      );
}
