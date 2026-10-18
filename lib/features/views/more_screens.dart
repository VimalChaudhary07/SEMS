import 'package:flutter/material.dart';

export 'schedules_screen.dart' show SchedulesScreen;

import '../../core/theme/app_theme.dart';
import '../../data/repositories/sems_repository.dart';
import '../../domain/models/bill_record.dart';
import '../../domain/models/tariff.dart';
import '../../domain/models/tariff_record.dart';
import '../../shared/widgets/sems_widgets.dart';

class BillsScreen extends StatefulWidget {
  const BillsScreen({super.key, this.repository});
  final SemsRepository? repository;
  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> {
  late final SemsRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? MockSemsRepository();
  }

  @override
  Widget build(BuildContext context) {
    final repository = _repository;
    final tariff = _toTariff(repository.tariff);
    final energy = 168.4;
    final estimate = estimateBill(energyKwh: energy, tariff: tariff);
    final previous = repository.bills.isEmpty ? null : repository.bills.first;
    final amount = _money(estimate.total);
    final budgetProgress = tariff.budget == 0
        ? 0.0
        : (estimate.total / tariff.budget).clamp(0.0, 1.0);
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
          const _BillingSectionLabel('Current period'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _BillingMetric(
                  label: 'Measured energy',
                  value: '${energy.toStringAsFixed(1)} kWh',
                  note: 'Measured, so far this period',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _BillingMetric(
                  label: 'Estimated bill',
                  value: amount,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        'Monthly budget (Estimated vs budget)',
                        style: TextStyle(color: SemsColors.muted),
                      ),
                    ),
                    Text(
                      '$amount / ${_money(tariff.budget)}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: budgetProgress,
                  minHeight: 8,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  backgroundColor: SemsColors.mint,
                ),
                const SizedBox(height: 8),
                Text(
                  '${(budgetProgress * 100).round()}% of budget used (Estimated). '
                  'Budget alerts come at 80% and 100%.',
                  style: const TextStyle(color: SemsColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _BillingSectionLabel('Last bill'),
          const SizedBox(height: 10),
          if (previous != null) ...[
            _BilledMetric(record: previous),
            const SizedBox(height: 8),
            _LastBillComparison(record: previous, estimate: estimate.total),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(child: _BillingSectionLabel('Bill records')),
              TextButton(
                onPressed: () => _openBillRecords(context),
                child: const Text('Add bill'),
              ),
            ],
          ),
          const SizedBox(height: 2),
          _InlineBillRecords(records: repository.bills),
          const SizedBox(height: 16),
          const _BillingSectionLabel('Tariff'),
          const SizedBox(height: 10),
          _TariffSummary(tariff: repository.tariff),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => _openTariffEditor(context, repository),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit billing settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _openBillRecords(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => BillRecordsScreen(repository: _repository),
      ),
    );
    if (mounted) setState(() {});
  }

  Future<void> _openTariffEditor(
    BuildContext context,
    SemsRepository repository,
  ) async {
    final budget = TextEditingController(
      text: repository.tariff.budget.toStringAsFixed(0),
    );
    final fixed = TextEditingController(
      text: repository.tariff.fixedCharge.toStringAsFixed(0),
    );
    final duty = TextEditingController(
      text: repository.tariff.dutyPercent.toStringAsFixed(1),
    );
    final firstRate = TextEditingController(
      text:
          repository.tariff.slabs.elementAtOrNull(0)?.rate.toStringAsFixed(2) ??
          '6.00',
    );
    final secondRate = TextEditingController(
      text:
          repository.tariff.slabs.elementAtOrNull(1)?.rate.toStringAsFixed(2) ??
          '8.00',
    );
    final thirdRate = TextEditingController(
      text:
          repository.tariff.slabs.elementAtOrNull(2)?.rate.toStringAsFixed(2) ??
          '9.50',
    );
    final form = GlobalKey<FormState>();
    final result = await showModalBottomSheet<TariffRecord>(
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
                TextFormField(
                  controller: budget,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monthly budget',
                    prefixText: '₹ ',
                  ),
                  validator: _positive,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      'Progressive slabs',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: firstRate,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: '0–100 kWh',
                          prefixText: '₹ ',
                        ),
                        validator: _nonNegative,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: secondRate,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: '100–200 kWh',
                          prefixText: '₹ ',
                        ),
                        validator: _nonNegative,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: thirdRate,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Above 200 kWh',
                    prefixText: '₹ ',
                  ),
                  validator: _nonNegative,
                ),
                TextFormField(
                  controller: fixed,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Fixed charge',
                    prefixText: '₹ ',
                  ),
                  validator: _nonNegative,
                ),
                TextFormField(
                  controller: duty,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Duty / tax',
                    suffixText: '%',
                  ),
                  validator: _nonNegative,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {
                    if (!form.currentState!.validate()) return;
                    Navigator.pop(
                      context,
                      repository.tariff.copyWith(
                        budget: double.parse(budget.text),
                        fixedCharge: double.parse(fixed.text),
                        dutyPercent: double.parse(duty.text),
                        slabs: [
                          TariffSlabRecord(
                            fromKwh: 0,
                            toKwh: 100,
                            rate: double.parse(firstRate.text),
                          ),
                          TariffSlabRecord(
                            fromKwh: 100,
                            toKwh: 200,
                            rate: double.parse(secondRate.text),
                          ),
                          TariffSlabRecord(
                            fromKwh: 200,
                            rate: double.parse(thirdRate.text),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Save settings'),
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
    firstRate.dispose();
    secondRate.dispose();
    thirdRate.dispose();
    if (result != null && mounted) {
      await repository.saveTariff(result);
      setState(() {});
    }
  }

  static String _money(double value) => '₹${value.toStringAsFixed(0)}';
  static String? _positive(String? value) =>
      (double.tryParse(value ?? '') ?? 0) <= 0
      ? 'Enter a value greater than zero'
      : null;
  static String? _nonNegative(String? value) =>
      (double.tryParse(value ?? '') ?? -1) < 0 ? 'Enter zero or more' : null;

  static Tariff _toTariff(TariffRecord record) => Tariff(
    slabs: [
      for (final slab in record.slabs)
        TariffSlab(
          fromKwh: slab.fromKwh,
          toKwh: slab.toKwh,
          ratePerKwh: slab.rate,
        ),
    ],
    fixedCharge: record.fixedCharge,
    dutyPercent: record.dutyPercent,
    budget: record.budget,
  );
}

class _TariffSummary extends StatelessWidget {
  const _TariffSummary({required this.tariff});
  final TariffRecord tariff;
  @override
  Widget build(BuildContext context) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('TARIFF'),
        const SizedBox(height: 8),
        for (final slab in tariff.slabs)
          _BillRow(
            label:
                '${slab.fromKwh.toStringAsFixed(0)}–${slab.toKwh?.toStringAsFixed(0) ?? 'above'} kWh',
            value: '₹${slab.rate.toStringAsFixed(2)} / kWh',
          ),
        _BillRow(
          label: 'Fixed charge',
          value: '₹${tariff.fixedCharge.toStringAsFixed(0)}',
        ),
        _BillRow(
          label: 'Duty / tax',
          value: '${tariff.dutyPercent.toStringAsFixed(1)}%',
        ),
        _BillRow(
          label: 'Billing day',
          value: '${tariff.billingDay} of the month',
        ),
        _BillRow(label: 'Currency', value: tariff.currency),
      ],
    ),
  );
}

class _BillingLegend extends StatelessWidget {
  const _BillingLegend();

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 12,
    runSpacing: 6,
    children: const [
      _LegendItem('Measured', Colors.white, dashed: false),
      _LegendItem('Estimated', Colors.white, dashed: true),
      _LegendItem('Billed', SemsColors.mint, dashed: false),
    ],
  );
}

class _LegendItem extends StatelessWidget {
  const _LegendItem(this.label, this.color, {required this.dashed});
  final String label;
  final Color color;
  final bool dashed;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: dashed ? SemsColors.muted : SemsColors.line,
            style: dashed ? BorderStyle.solid : BorderStyle.solid,
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

class _BillingSectionLabel extends StatelessWidget {
  const _BillingSectionLabel(this.label);
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

class _BillingMetric extends StatelessWidget {
  const _BillingMetric({
    required this.label,
    required this.value,
    required this.note,
    this.estimated = false,
  });
  final String label;
  final String value;
  final String note;
  final bool estimated;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: estimated ? SemsColors.muted : SemsColors.line),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (estimated) ...[
              const Text('✦', style: TextStyle(color: SemsColors.muted)),
              const SizedBox(width: 4),
            ],
            Expanded(
              child: Text(
                label,
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

class _BilledMetric extends StatelessWidget {
  const _BilledMetric({required this.record});
  final BillRecord record;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: SemsColors.mint,
      border: Border.all(color: SemsColors.line),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '▣  Billed · ${record.period}',
          style: const TextStyle(color: SemsColors.muted, fontSize: 12),
        ),
        const SizedBox(height: 3),
        Text(
          '₹${record.amount.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        Text(
          'Billed · ${record.energyKwh.toStringAsFixed(0)} kWh · '
          'effective rate ₹${(record.effectiveRate ?? record.amount / record.energyKwh).toStringAsFixed(2)} per kWh',
          style: const TextStyle(color: SemsColors.muted, fontSize: 11),
        ),
      ],
    ),
  );
}

class _LastBillComparison extends StatelessWidget {
  const _LastBillComparison({required this.record, required this.estimate});
  final BillRecord record;
  final double estimate;

  @override
  Widget build(BuildContext context) {
    final difference = estimate - record.amount;
    return AppCard(
      child: Column(
        children: [
          _BillRow(
            label: 'Estimated for ${record.energyKwh.toStringAsFixed(0)} kWh',
            value: '₹${estimate.toStringAsFixed(0)}',
          ),
          _BillRow(
            label: 'Billed amount',
            value: '₹${record.amount.toStringAsFixed(0)}',
          ),
          const Divider(height: 12),
          _BillRow(
            label: 'Estimated vs Billed',
            value:
                '${difference >= 0 ? '+' : ''}₹${difference.toStringAsFixed(0)}',
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _InlineBillRecords extends StatelessWidget {
  const _InlineBillRecords({required this.records});
  final List<BillRecord> records;

  @override
  Widget build(BuildContext context) => AppCard(
    padding: EdgeInsets.zero,
    child: Column(
      children: [
        for (var i = 0; i < records.length; i++) ...[
          _InlineBillRecord(record: records[i]),
          if (i < records.length - 1) const Divider(height: 1, indent: 64),
        ],
      ],
    ),
  );
}

class _InlineBillRecord extends StatelessWidget {
  const _InlineBillRecord({required this.record});
  final BillRecord record;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: SemsColors.mint,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.receipt_long_outlined,
            size: 19,
            color: SemsColors.muted,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                record.period,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${record.energyKwh.toStringAsFixed(0)} kWh · '
                '₹${(record.effectiveRate ?? record.amount / record.energyKwh).toStringAsFixed(2)}/kWh billed rate',
                style: const TextStyle(color: SemsColors.muted, fontSize: 12),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${record.amount.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Container(
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: SemsColors.mint,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Text(
                'Billed',
                style: TextStyle(color: SemsColors.muted, fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    ),
  );
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
  const BillRecordsScreen({super.key, this.repository});
  final SemsRepository? repository;
  @override
  State<BillRecordsScreen> createState() => _BillRecordsScreenState();
}

class _BillRecordsScreenState extends State<BillRecordsScreen> {
  late final SemsRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? MockSemsRepository();
  }

  @override
  Widget build(BuildContext context) {
    final repository = _repository;
    final records = repository.bills;
    return Scaffold(
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
                          records[i].period,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        subtitle: Text(
                          '${records[i].energyKwh.toStringAsFixed(0)} kWh · '
                          '${records[i].effectiveRate == null ? 'actual bill' : '₹${records[i].effectiveRate!.toStringAsFixed(2)}/kWh'}',
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
                              '₹${records[i].amount.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
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
              'Past bills are local example records. No utility-provider data is connected.',
              style: TextStyle(color: SemsColors.muted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _add() async {
    final period = TextEditingController();
    final energy = TextEditingController();
    final amount = TextEditingController();
    final form = GlobalKey<FormState>();
    final entry = await showModalBottomSheet<BillRecord>(
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
                      BillRecord(
                        id: 'bill-${DateTime.now().microsecondsSinceEpoch}',
                        period: period.text.trim(),
                        energyKwh: double.parse(energy.text),
                        amount: double.parse(amount.text),
                        status: 'billed',
                      ),
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
    if (entry != null && mounted) {
      await _repository.saveBill(entry);
      setState(() {});
    }
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
