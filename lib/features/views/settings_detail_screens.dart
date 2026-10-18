import 'package:flutter/material.dart';

import '../../core/session/demo_session.dart';
import '../../core/theme/app_theme.dart';
import '../../data/repositories/sems_repository.dart';
import '../../domain/models/bill_record.dart';
import '../../domain/models/tariff.dart';
import '../../domain/models/tariff_record.dart';
import '../../shared/widgets/sems_widgets.dart';

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
        Center(
          child: CircleAvatar(
            radius: 42,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Text(
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
        AppButton(
          label: 'Save changes',
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
        ),
        const SizedBox(height: 16),
        const AppBanner(
          tone: StatusTone.brand,
          title: 'Password changes and account verification are not connected to an identity service.',
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
        const AppBanner(
          tone: StatusTone.brand,
          title: 'Notification preferences are local demo state only. No push notification service is active.',
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
                backgroundColor: ComponentTheme.colors(context).brandTint,
                child: Text(
                  members[i].$1.substring(0, 1),
                  style: TextStyle(
                    color: ComponentTheme.colors(context).brandPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              title: Text(
                members[i].$1,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(members[i].$2),
              trailing: i == 0
                  ? const RoleBadge(isFamily: false)
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RoleBadge(isFamily: members[i].$2 == 'Member'),
                        if (!DemoSession.isMember)
                          PopupMenuButton<String>(
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
            AppButton(
              label: 'Invite',
              onPressed: () {
                if (form.currentState!.validate()) {
                  Navigator.pop(context, (email.text.trim(), role));
                }
              },
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
          AppButton(
            label: 'Remove',
            variant: AppButtonVariant.danger,
            onPressed: () => Navigator.pop(context, true),
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
  late final SemsRepository _repository;
  late TariffRecord _tariff;
  late List<BillRecord> _bills;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? MockSemsRepository();
    _tariff = _repository.tariff;
    _bills = List<BillRecord>.from(_repository.bills);
  }

  @override
  Widget build(BuildContext context) {
    final tariffValue = _tariff;
    final estimate = estimateBill(
      energyKwh: 232,
      tariff: Tariff(
        slabs: [
          for (final slab in tariffValue.slabs)
            TariffSlab(
              fromKwh: slab.fromKwh,
              toKwh: slab.toKwh,
              ratePerKwh: slab.rate,
            ),
        ],
        fixedCharge: tariffValue.fixedCharge,
        dutyPercent: tariffValue.dutyPercent,
        budget: tariffValue.budget,
      ),
    );
    final mainBill = _bills.isNotEmpty ? _bills.first : null;
    final value = mainBill == null
        ? '₹0'
        : '₹${mainBill.amount.toStringAsFixed(0)}';
    final diff = mainBill == null ? 0.0 : estimate.total - mainBill.amount;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Billing settings'),
            Text(
              'Example data',
              style: TextStyle(fontSize: 12, color: SemsColors.muted),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          const _BillingLegend(),
          const SizedBox(height: 16),
          const _SectionLabel('Current period'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  title: 'Measured energy',
                  value: '168.4 kWh',
                  note: 'Measured, so far this period',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricCard(
                  title: 'Estimated bill',
                  value: '₹1,292',
                  note: 'Estimated, if usage stops today',
                  estimated: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Monthly budget (Estimated vs budget)',
                  style: TextStyle(color: SemsColors.muted, fontSize: 12),
                ),
                const SizedBox(height: 3),
                const Text(
                  '₹1,292 / ₹1,900',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const AppProgressBar(value: 0.68, height: 8),
                const SizedBox(height: 5),
                const Text(
                  '68% of budget used (Estimated). Budget alerts come at 80% and 100%.',
                  style: TextStyle(color: SemsColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _SectionLabel('Last bill'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ComponentTheme.colors(context).brandTint,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ComponentTheme.colors(context).border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Billed · Sep 2026',
                  style: TextStyle(color: SemsColors.muted, fontSize: 12),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'Billed · 232 kWh · effective rate ₹8.02 per kWh',
                  style: TextStyle(color: SemsColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          AppCard(
            child: Column(
              children: [
                _BillingRow(label: 'Estimated for 232 kWh', value: '₹1,861'),
                _BillingRow(
                  label: 'Billed amount',
                  value: mainBill == null
                      ? '₹0'
                      : '₹${mainBill.amount.toStringAsFixed(0)}',
                ),
                const Divider(height: 12),
                _BillingRow(
                  label: 'Estimated vs Billed',
                  value:
                      '${diff >= 0 ? '+' : ''}₹${diff.abs().toStringAsFixed(0)}',
                  bold: true,
                  valueColor: diff >= 0 ? SemsColors.green : SemsColors.red,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(child: _SectionLabel('Bill records')),
              TextButton(onPressed: _addBill, child: const Text('Add bill')),
            ],
          ),
          const SizedBox(height: 2),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < _bills.length; i++) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: ComponentTheme.colors(context).brandTint,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.receipt_long_outlined,
                            size: 19,
                            color: ComponentTheme.colors(context).brandPrimary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _bills[i].period,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                '${_bills[i].energyKwh.toStringAsFixed(0)} kWh · '
                                '₹${(_bills[i].effectiveRate ?? (_bills[i].amount / _bills[i].energyKwh)).toStringAsFixed(2)}/kWh billed rate',
                                style: const TextStyle(
                                  color: SemsColors.muted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₹${_bills[i].amount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const StatusBadge(
                              label: 'Billed',
                              tone: StatusTone.brand,
                              compact: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (i < _bills.length - 1)
                    const Divider(height: 1, indent: 64),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _SectionLabel('Tariff'),
          const SizedBox(height: 10),
          AppCard(
            child: Column(
              children: [
                _BillingRow(label: 'Currency', value: 'INR'),
                _BillingRow(label: '0 to 100 kWh', value: '₹6.00/kWh'),
                _BillingRow(label: '100 to 200 kWh', value: '₹8.00/kWh'),
                _BillingRow(label: 'Above 200 kWh', value: '₹9.50/kWh'),
                _BillingRow(label: 'Fixed charge', value: '₹120'),
                _BillingRow(label: 'Duty and tax', value: '2%'),
                _BillingRow(label: 'Monthly budget', value: '₹1,900'),
                _BillingRow(label: 'Billing day', value: '1st of the month'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppButton(
            label: 'Edit billing settings',
            leadingIcon: Icons.edit_outlined,
            variant: AppButtonVariant.secondary,
            onPressed: _editBillingSettings,
          ),
        ],
      ),
    );
  }

  Future<void> _editBillingSettings() async {
    final budget = TextEditingController(
      text: _tariff.budget.toStringAsFixed(0),
    );
    final fixed = TextEditingController(
      text: _tariff.fixedCharge.toStringAsFixed(0),
    );
    final duty = TextEditingController(
      text: _tariff.dutyPercent.toStringAsFixed(0),
    );
    final first = TextEditingController(
      text: _tariff.slabs.isNotEmpty
          ? _tariff.slabs[0].rate.toStringAsFixed(2)
          : '6.00',
    );
    final second = TextEditingController(
      text: _tariff.slabs.length > 1
          ? _tariff.slabs[1].rate.toStringAsFixed(2)
          : '8.00',
    );
    final third = TextEditingController(
      text: _tariff.slabs.length > 2
          ? _tariff.slabs[2].rate.toStringAsFixed(2)
          : '9.50',
    );
    final form = GlobalKey<FormState>();
    final updated = await showModalBottomSheet<TariffRecord>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          MediaQuery.viewInsetsOf(sheetContext).bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Edit billing settings',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: budget,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monthly budget',
                    prefixText: '₹ ',
                  ),
                  validator: _positive,
                ),
                TextFormField(
                  controller: fixed,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Fixed charge',
                    prefixText: '₹ ',
                  ),
                  validator: _zeroOrPositive,
                ),
                TextFormField(
                  controller: duty,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Duty and tax',
                    suffixText: '%',
                  ),
                  validator: _zeroOrPositive,
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Progressive slabs',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: first,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: '0–100 kWh',
                          prefixText: '₹ ',
                        ),
                        validator: _zeroOrPositive,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: second,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: '100–200 kWh',
                          prefixText: '₹ ',
                        ),
                        validator: _zeroOrPositive,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: third,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Above 200 kWh',
                    prefixText: '₹ ',
                  ),
                  validator: _zeroOrPositive,
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Save billing settings',
                  onPressed: () {
                    if (!form.currentState!.validate()) return;
                    Navigator.pop(
                      sheetContext,
                      _tariff.copyWith(
                        budget: double.parse(budget.text),
                        fixedCharge: double.parse(fixed.text),
                        dutyPercent: double.parse(duty.text),
                        slabs: [
                          TariffSlabRecord(
                            fromKwh: 0,
                            toKwh: 100,
                            rate: double.parse(first.text),
                          ),
                          TariffSlabRecord(
                            fromKwh: 100,
                            toKwh: 200,
                            rate: double.parse(second.text),
                          ),
                          TariffSlabRecord(
                            fromKwh: 200,
                            rate: double.parse(third.text),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    budget.dispose();
    fixed.dispose();
    duty.dispose();
    first.dispose();
    second.dispose();
    third.dispose();

    if (updated != null && mounted) {
      await _repository.saveTariff(updated);
      setState(() {
        _tariff = updated;
      });
    }
  }

  Future<void> _addBill() async {
    final period = TextEditingController();
    final energy = TextEditingController();
    final amount = TextEditingController();
    final form = GlobalKey<FormState>();
    final bill = await showModalBottomSheet<BillRecord>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          MediaQuery.viewInsetsOf(sheetContext).bottom + 20,
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
              const SizedBox(height: 12),
              AppButton(
                label: 'Save bill',
                onPressed: () {
                  if (!form.currentState!.validate()) return;
                  Navigator.pop(
                    sheetContext,
                    BillRecord(
                      id: 'bill-${DateTime.now().microsecondsSinceEpoch}',
                      period: period.text.trim(),
                      energyKwh: double.parse(energy.text),
                      amount: double.parse(amount.text),
                      effectiveRate:
                          double.parse(amount.text) / double.parse(energy.text),
                      status: 'billed',
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
    period.dispose();
    energy.dispose();
    amount.dispose();

    if (bill != null && mounted) {
      await _repository.saveBill(bill);
      setState(() => _bills.insert(0, bill));
    }
  }

  static String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Required' : null;

  static String? _positive(String? value) =>
      (double.tryParse(value ?? '') ?? 0) <= 0
      ? 'Enter a value greater than zero'
      : null;

  static String? _zeroOrPositive(String? value) =>
      (double.tryParse(value ?? '') ?? -1) < 0 ? 'Enter zero or more' : null;
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Text(
      label.toUpperCase(),
      style: const TextStyle(
        color: SemsColors.muted,
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: .8,
      ),
    ),
  );
}

class _BillingLegend extends StatelessWidget {
  const _BillingLegend();

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return Row(
      children: [
        _LegendPill(label: 'Measured', color: colors.card),
        const SizedBox(width: 12),
        _LegendPill(label: 'Estimated', color: colors.card, dashed: true),
        const SizedBox(width: 12),
        _LegendPill(label: 'Billed', color: colors.brandTint),
      ],
    );
  }
}

class _LegendPill extends StatelessWidget {
  const _LegendPill({
    required this.label,
    required this.color,
    this.dashed = false,
  });
  final String label;
  final Color color;
  final bool dashed;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: dashed ? SemsColors.muted : SemsColors.line,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      const SizedBox(width: 6),
      Text(
        label,
        style: const TextStyle(color: SemsColors.muted, fontSize: 12),
      ),
    ],
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.note,
    this.estimated = false,
  });
  final String title;
  final String value;
  final String note;
  final bool estimated;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.card,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (estimated)
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.auto_awesome_outlined,
                    size: 12,
                    color: SemsColors.muted,
                  ),
                ),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: SemsColors.muted, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 3),
          Text(
            note,
            style: const TextStyle(color: SemsColors.muted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _BillingRow extends StatelessWidget {
  const _BillingRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: bold ? colors.textPrimary : SemsColors.muted,
                fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color: valueColor ?? colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
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
        const AppBanner(
          tone: StatusTone.ai,
          title: 'The design describes on-device analysis. This preview uses static sample recommendations and does not run an AI model.',
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
              const AppProgressBar(value: .28, height: 6),
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
        AppButton(
          label: 'Clear local data',
          leadingIcon: Icons.delete_outline,
          variant: AppButtonVariant.danger,
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
        ),
        const SizedBox(height: 8),
        const AppBanner(
          tone: StatusTone.brand,
          title: 'Storage figures and history controls are illustrative. The preview does not write energy telemetry to disk.',
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
        AppButton(
          label: 'Export data as CSV',
          leadingIcon: Icons.download_outlined,
          onPressed: () => _export(context, 'CSV'),
        ),
        const SizedBox(height: 8),
        AppButton(
          label: 'Export data as JSON',
          leadingIcon: Icons.data_object_outlined,
          variant: AppButtonVariant.secondary,
          onPressed: () => _export(context, 'JSON'),
        ),
        const SizedBox(height: 8),
        AppButton(
          label: 'Export data as PDF',
          leadingIcon: Icons.picture_as_pdf_outlined,
          variant: AppButtonVariant.secondary,
          onPressed: () => _export(context, 'PDF'),
        ),
        const SizedBox(height: 14),
        const AppBanner(
          tone: StatusTone.brand,
          title: 'Export actions demonstrate the UI only. No file is created in the app sandbox.',
        ),
      ],
    ),
  );
  static void _export(BuildContext context, String format) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$format export prepared for this preview.')),
      );
}
