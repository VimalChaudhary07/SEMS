import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/session/demo_session.dart';
import '../../data/repositories/sems_repository.dart';
import '../../domain/models/bill_record.dart';
import '../../domain/models/tariff_record.dart';

/// Implements Figma Screen 111: Billing settings (Node ID: 18:1838)
/// and Screen 112: Billing settings - Family (Node ID: 18:2015).
class BillingSettingsScreen extends StatefulWidget {
  const BillingSettingsScreen({
    super.key,
    this.repository,
    this.readOnly = false,
    this.bottomNavigationBar,
    this.showEditSheetOnStart = false,
    this.showValidationErrorsOnStart = false,
    this.showAddBillSheetOnStart = false,
  });

  final SemsRepository? repository;
  final bool readOnly;
  final Widget? bottomNavigationBar;
  final bool showEditSheetOnStart;
  final bool showValidationErrorsOnStart;
  final bool showAddBillSheetOnStart;

  @override
  State<BillingSettingsScreen> createState() => _BillingSettingsScreenState();
}

class _BillingSettingsScreenState extends State<BillingSettingsScreen> {
  late SemsRepository _repository;
  late TariffRecord _tariff;
  late List<BillRecord> _bills;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? MockSemsRepository();
    _loadData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.showEditSheetOnStart) {
        _openEditSheet(showValidationErrors: widget.showValidationErrorsOnStart);
      } else if (widget.showAddBillSheetOnStart) {
        _openAddBillSheet();
      }
    });
  }

  void _loadData() {
    _tariff = _repository.tariff;
    _bills = List<BillRecord>.from(_repository.bills);
  }

  bool get _isFamily => widget.readOnly || DemoSession.isMember;

  void _openEditSheet({bool showValidationErrors = false}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) => _EditBillingSettingsSheet(
        repository: _repository,
        initialTariff: _tariff,
        showValidationErrors: showValidationErrors,
        onSaved: () {
          setState(() {
            _loadData();
          });
        },
      ),
    );
  }

  void _openAddBillSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) => _AddBillSheet(
        repository: _repository,
        onSaved: () {
          setState(() {
            _loadData();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double estimatedBill = 1292.0;
    const double budget = 1900.0;
    final double budgetProgress = (estimatedBill / budget).clamp(0.0, 1.0);
    final int budgetPercent = (budgetProgress * 100).round();

    // Last bill comparison
    final BillRecord? lastBill = _bills.isNotEmpty ? _bills.first : null;
    const double estimatedForLastBill = 1861.0;
    final double billedAmount = lastBill?.amount ?? 1860.0;
    final double diff = estimatedForLastBill - billedAmount;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      bottomNavigationBar: widget.bottomNavigationBar,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar (56px)
            SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          AppAssets.iconChevLeft,
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF0F1714),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Billing settings',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F1714),
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Example data',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF55625D),
                              height: 1.33,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _RolePill(isFamily: _isFamily),
                  ],
                ),
              ),
            ),

            // Scrollable Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  // Legend Row
                  const _BillingLegend(),
                  const SizedBox(height: 16),

                  // Section: CURRENT PERIOD
                  const _SectionHeader(title: 'CURRENT PERIOD'),
                  const SizedBox(height: 10),

                  // Measured energy & Estimated bill cards
                  Row(
                    children: [
                      // Measured energy card
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFE1E9E5)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Measured energy',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF55625D),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: const [
                                  Text(
                                    '168.4',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0F1714),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'kWh',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF55625D),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              const Text(
                                'Measured, so far this period',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF55625D),
                                  height: 1.27,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Estimated bill card (with dashed border)
                      Expanded(
                        child: CustomPaint(
                          painter: _DashedBorderPainter(
                            color: const Color(0xFF55625D),
                            strokeWidth: 1.0,
                            radius: 12,
                            dashWidth: 4,
                            dashSpace: 3,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      AppAssets.iconSparkle,
                                      width: 11,
                                      height: 11,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFF55625D),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'Estimated bill',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF55625D),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  '₹1,292',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F1714),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                const Text(
                                  'Estimated, if usage stops today',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF55625D),
                                    height: 1.27,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Monthly budget card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE1E9E5)),
                      borderRadius: BorderRadius.circular(12),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Expanded(
                              child: Text(
                                'Monthly budget (Estimated vs budget)',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF55625D),
                                ),
                              ),
                            ),
                            Text(
                              '₹1,292 / ₹1,900',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F1714),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Progress bar
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF1EE),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: budgetProgress,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E9E5B),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$budgetPercent% of budget used (Estimated). Budget alerts come at 80% and 100%.',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF55625D),
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section: LAST BILL
                  const _SectionHeader(title: 'LAST BILL'),
                  const SizedBox(height: 10),

                  // Last bill summary card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF1EE),
                      border: Border.all(color: const Color(0xFFE1E9E5)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppAssets.iconReceipt,
                              width: 11,
                              height: 11,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF55625D),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Billed · Sep 2026',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF55625D),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          '₹1,860',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F1714),
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Billed · 232 kWh · effective rate ₹8.02 per kWh',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF55625D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Comparison card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE1E9E5)),
                      borderRadius: BorderRadius.circular(12),
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
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Expanded(
                              child: Text(
                                'Estimated for 232 kWh',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF55625D),
                                ),
                              ),
                            ),
                            Text(
                              '₹1,861',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF0F1714),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Billed amount',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF55625D),
                                ),
                              ),
                            ),
                            Text(
                              '₹${billedAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF0F1714),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Color(0xFFE1E9E5),
                          ),
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Estimated vs Billed',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF0F1714),
                                ),
                              ),
                            ),
                            Text(
                              diff >= 0
                                  ? '+₹${diff.toStringAsFixed(0)}'
                                  : '-₹${(-diff).toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2E9E5B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section: BILL RECORDS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        const Expanded(
                          child: _SectionHeader(title: 'BILL RECORDS'),
                        ),
                        if (!_isFamily)
                          GestureDetector(
                            onTap: _openAddBillSheet,
                            child: const Text(
                              'Add bill',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0E9F6E),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Bill records list card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE1E9E5)),
                      borderRadius: BorderRadius.circular(12),
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
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        for (int i = 0; i < _bills.length; i++) ...[
                          if (i > 0)
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFE1E9E5),
                            ),
                          _BillItemRow(bill: _bills[i]),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Section: TARIFF
                  const _SectionHeader(title: 'TARIFF'),
                  const SizedBox(height: 10),

                  // Tariff summary card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE1E9E5)),
                      borderRadius: BorderRadius.circular(12),
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
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        _TariffRow(
                          label: 'Currency',
                          subtitle: 'Indian rupee',
                          value: 'INR ₹',
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFE1E9E5),
                        ),
                        _TariffRow(
                          label: '0 to 100 kWh',
                          subtitle: 'Estimated rate',
                          value: '₹6.00/kWh',
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFE1E9E5),
                        ),
                        _TariffRow(
                          label: '100 to 200 kWh',
                          subtitle: 'Estimated rate',
                          value: '₹8.00/kWh',
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFE1E9E5),
                        ),
                        _TariffRow(
                          label: 'Above 200 kWh',
                          subtitle: 'Estimated rate',
                          value: '₹9.50/kWh',
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFE1E9E5),
                        ),
                        _TariffRow(
                          label: 'Fixed charge',
                          subtitle: 'Estimated, per bill',
                          value: '₹${_tariff.fixedCharge.toStringAsFixed(0)}',
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFE1E9E5),
                        ),
                        _TariffRow(
                          label: 'Duty and tax',
                          subtitle: 'Estimated',
                          value: '${_tariff.dutyPercent.toStringAsFixed(0)}%',
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFE1E9E5),
                        ),
                        _TariffRow(
                          label: 'Monthly budget',
                          subtitle: 'Compared with the Estimated bill',
                          value: '₹${_tariff.budget.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFE1E9E5),
                        ),
                        _TariffRow(
                          label: 'Billing day',
                          subtitle: 'Day your billing period starts',
                          value: '${_tariff.billingDay}st of the month',
                        ),
                      ],
                    ),
                  ),

                  // Edit billing settings button (Owner only)
                  if (!_isFamily) ...[
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => _openEditSheet(),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE1E9E5)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppAssets.iconEdit,
                              width: 18,
                              height: 18,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF0F1714),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Edit billing settings',
                              style: TextStyle(
                                fontSize: 15,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Legend item row at top
class _BillingLegend extends StatelessWidget {
  const _BillingLegend();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Measured: solid square outline
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE1E9E5), width: 1.0),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'Measured',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF55625D),
          ),
        ),
        const SizedBox(width: 12),

        // Estimated: dashed square outline
        CustomPaint(
          size: const Size(12, 12),
          painter: _DashedBorderPainter(
            color: const Color(0xFF55625D),
            strokeWidth: 1.0,
            radius: 3,
            dashWidth: 4,
            dashSpace: 3,
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'Estimated',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF55625D),
          ),
        ),
        const SizedBox(width: 12),

        // Billed: filled light gray square
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1EE),
            border: Border.all(color: const Color(0xFFE1E9E5), width: 1.0),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'Billed',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF55625D),
          ),
        ),
      ],
    );
  }
}

/// Role pill in header: Owner or Family
class _RolePill extends StatelessWidget {
  const _RolePill({required this.isFamily});
  final bool isFamily;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isFamily ? const Color(0xFFEBF5FF) : const Color(0xFFDDF4EA),
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: Alignment.center,
      child: Text(
        isFamily ? 'Family' : 'Owner',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isFamily ? const Color(0xFF1E429F) : const Color(0xFF0E9F6E),
        ),
      ),
    );
  }
}

/// All-caps section header
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF55625D),
          letterSpacing: 0.06 * 13,
        ),
      ),
    );
  }
}

/// Single row item in Bill Records
class _BillItemRow extends StatelessWidget {
  const _BillItemRow({required this.bill});
  final BillRecord bill;

  @override
  Widget build(BuildContext context) {
    final rateStr = bill.effectiveRate != null
        ? '₹${bill.effectiveRate!.toStringAsFixed(2)}/kWh billed rate'
        : 'billed';
    final amountStr = '₹${bill.amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1EE),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppAssets.iconReceipt,
              width: 19,
              height: 19,
              colorFilter: const ColorFilter.mode(
                Color(0xFF55625D),
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
                  bill.period,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F1714),
                    height: 1.33,
                  ),
                ),
                Text(
                  '${bill.energyKwh.toStringAsFixed(0)} kWh · $rateStr',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amountStr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F1714),
                ),
              ),
              const SizedBox(height: 2),
              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1EE),
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Billed',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF55625D),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Single row item in Tariff card
class _TariffRow extends StatelessWidget {
  const _TariffRow({
    required this.label,
    required this.subtitle,
    required this.value,
  });

  final String label;
  final String subtitle;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F1714),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F1714),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for dashed rounded rectangles
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashWidth;
  final double dashSpace;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.radius = 12.0,
    this.dashWidth = 4.0,
    this.dashSpace = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final extractLength = (distance + dashWidth <= metric.length)
            ? dashWidth
            : metric.length - distance;
        final extractPath = metric.extractPath(
          distance,
          distance + extractLength,
        );
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      radius != oldDelegate.radius ||
      dashWidth != oldDelegate.dashWidth ||
      dashSpace != oldDelegate.dashSpace;
}

/// Bottom Sheet: Edit billing settings (Screen 113: 18:2197 & Screen 114: 18:2465)
class _EditBillingSettingsSheet extends StatefulWidget {
  const _EditBillingSettingsSheet({
    required this.repository,
    required this.initialTariff,
    this.showValidationErrors = false,
    required this.onSaved,
  });

  final SemsRepository repository;
  final TariffRecord initialTariff;
  final bool showValidationErrors;
  final VoidCallback onSaved;

  @override
  State<_EditBillingSettingsSheet> createState() =>
      _EditBillingSettingsSheetState();
}

class _EditBillingSettingsSheetState extends State<_EditBillingSettingsSheet> {
  String _currency = 'INR';
  bool _useSlabs = true;
  late TextEditingController _slab1;
  late TextEditingController _rate1;
  late TextEditingController _slab2;
  late TextEditingController _rate2;
  late TextEditingController _rateRemaining;
  late TextEditingController _fixedCharge;
  late TextEditingController _duty;
  late TextEditingController _budget;
  late TextEditingController _billingDay;

  bool _showErrors = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _showErrors = widget.showValidationErrors;
    final t = widget.initialTariff;
    _currency = t.currency;

    if (_showErrors) {
      // Seed values from Figma Screen 114 (Validation errors)
      _slab1 = TextEditingController(text: '200');
      _rate1 = TextEditingController(text: '6');
      _slab2 = TextEditingController(text: '100');
      _rate2 = TextEditingController(text: '-8');
      _rateRemaining = TextEditingController(text: '9.5');
      _fixedCharge = TextEditingController(text: '120');
      _duty = TextEditingController(text: '2');
      _budget = TextEditingController(text: '0');
      _billingDay = TextEditingController(text: '31');
    } else {
      // Seed normal values from Figma Screen 113
      _slab1 = TextEditingController(
        text: t.slabs.isNotEmpty ? t.slabs[0].toKwh?.toStringAsFixed(0) ?? '100' : '100',
      );
      _rate1 = TextEditingController(
        text: t.slabs.isNotEmpty ? t.slabs[0].rate.toStringAsFixed(0) : '6',
      );
      _slab2 = TextEditingController(
        text: t.slabs.length > 1 ? t.slabs[1].toKwh?.toStringAsFixed(0) ?? '200' : '200',
      );
      _rate2 = TextEditingController(
        text: t.slabs.length > 1 ? t.slabs[1].rate.toStringAsFixed(0) : '8',
      );
      _rateRemaining = TextEditingController(
        text: t.slabs.length > 2 ? t.slabs[2].rate.toStringAsFixed(1) : '9.5',
      );
      _fixedCharge = TextEditingController(
        text: t.fixedCharge.toStringAsFixed(0),
      );
      _duty = TextEditingController(
        text: t.dutyPercent.toStringAsFixed(0),
      );
      _budget = TextEditingController(
        text: t.budget.toStringAsFixed(0),
      );
      _billingDay = TextEditingController(
        text: t.billingDay.toString(),
      );
    }
  }

  @override
  void dispose() {
    _slab1.dispose();
    _rate1.dispose();
    _slab2.dispose();
    _rate2.dispose();
    _rateRemaining.dispose();
    _fixedCharge.dispose();
    _duty.dispose();
    _budget.dispose();
    _billingDay.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final s1 = double.tryParse(_slab1.text) ?? 100;
    final s2 = double.tryParse(_slab2.text) ?? 200;
    final r1 = double.tryParse(_rate1.text) ?? 6;
    final r2 = double.tryParse(_rate2.text) ?? 8;
    final rRem = double.tryParse(_rateRemaining.text) ?? 9.5;
    final fixed = double.tryParse(_fixedCharge.text) ?? 120;
    final duty = double.tryParse(_duty.text) ?? 2;
    final budgetVal = double.tryParse(_budget.text) ?? 1900;
    final day = int.tryParse(_billingDay.text) ?? 1;

    final hasSlabError = s2 <= s1 || r1 < 0 || r2 < 0;
    final hasBudgetError = budgetVal <= 0;
    final hasDayError = day < 1 || day > 28;

    if (hasSlabError || hasBudgetError || hasDayError) {
      setState(() {
        _showErrors = true;
      });
      return;
    }

    setState(() => _saving = true);
    final updatedTariff = widget.initialTariff.copyWith(
      currency: _currency,
      slabs: [
        TariffSlabRecord(fromKwh: 0, toKwh: s1, rate: r1),
        TariffSlabRecord(fromKwh: s1, toKwh: s2, rate: r2),
        TariffSlabRecord(fromKwh: s2, rate: rRem),
      ],
      fixedCharge: fixed,
      dutyPercent: duty,
      budget: budgetVal,
      billingDay: day,
    );
    await widget.repository.saveTariff(updatedTariff);
    widget.onSaved();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final s1 = double.tryParse(_slab1.text) ?? 0;
    final s2 = double.tryParse(_slab2.text) ?? 0;
    final budgetVal = double.tryParse(_budget.text) ?? 0;
    final day = int.tryParse(_billingDay.text) ?? 0;

    final hasSlabError = _showErrors && (s2 <= s1);
    final hasBudgetError = _showErrors && (budgetVal <= 0);
    final hasDayError = _showErrors && (day < 1 || day > 28);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag Handle
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 4),
                child: Center(
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

              // Title and close button
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Edit billing settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F1714),
                          height: 1.33,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        splashRadius: 20,
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

              // Currency pills
              if (!_showErrors) ...[
                const Text(
                  'Currency',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF55625D),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _CurrencyPill(
                      label: 'INR ₹',
                      selected: _currency == 'INR',
                      onTap: () => setState(() => _currency = 'INR'),
                    ),
                    const SizedBox(width: 8),
                    _CurrencyPill(
                      label: 'USD \$',
                      selected: _currency == 'USD',
                      onTap: () => setState(() => _currency = 'USD'),
                    ),
                    const SizedBox(width: 8),
                    _CurrencyPill(
                      label: 'EUR €',
                      selected: _currency == 'EUR',
                      onTap: () => setState(() => _currency = 'EUR'),
                    ),
                    const SizedBox(width: 8),
                    _CurrencyPill(
                      label: 'GBP £',
                      selected: _currency == 'GBP',
                      onTap: () => setState(() => _currency = 'GBP'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Only the symbol changes. Amounts are not converted, so update the rates below to match.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                    height: 1.33,
                  ),
                ),
                const SizedBox(height: 16),

                // Use slabs card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE1E9E5)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Use slabs',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0F1714),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Different rates as usage grows',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF55625D),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _useSlabs = !_useSlabs),
                        child: Container(
                          width: 46,
                          height: 28,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: _useSlabs
                                ? const Color(0xFF0E9F6E)
                                : const Color(0xFFE1E9E5),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          alignment: _useSlabs
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Slab 1 row
              Row(
                children: [
                  Expanded(
                    child: _FieldColumn(
                      label: 'Slab 1 up to',
                      controller: _slab1,
                      suffix: 'kWh',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _FieldColumn(
                      label: 'Rate (Estimated)',
                      controller: _rate1,
                      suffix: '₹/kWh',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Slab 2 row
              Row(
                children: [
                  Expanded(
                    child: _FieldColumn(
                      label: 'Slab 2 up to',
                      controller: _slab2,
                      suffix: 'kWh',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _FieldColumn(
                      label: 'Rate (Estimated)',
                      controller: _rate2,
                      suffix: '₹/kWh',
                    ),
                  ),
                ],
              ),
              if (hasSlabError) ...[
                const SizedBox(height: 6),
                const Text(
                  'Each slab must end above the previous one',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFE02424),
                  ),
                ),
              ],
              const SizedBox(height: 12),

              // Remaining units row (Screen 113)
              if (!_showErrors) ...[
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Remaining units',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF55625D),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: const [
                                Expanded(
                                  child: Text(
                                    '∞',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF55625D),
                                    ),
                                  ),
                                ),
                                Text(
                                  'kWh',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF55625D),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _FieldColumn(
                        label: 'Rate (Estimated)',
                        controller: _rateRemaining,
                        suffix: '₹/kWh',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Fixed charge
                _FieldColumn(
                  label: 'Fixed charge (Estimated, per bill)',
                  controller: _fixedCharge,
                  suffix: '₹',
                ),
                const SizedBox(height: 12),

                // Duty and tax
                _FieldColumn(
                  label: 'Duty and tax',
                  controller: _duty,
                  suffix: '%',
                ),
                const SizedBox(height: 12),
              ],

              // Monthly budget
              _FieldColumn(
                label: 'Monthly budget (compared with Estimated)',
                controller: _budget,
                suffix: '₹',
                isError: hasBudgetError,
              ),
              if (hasBudgetError) ...[
                const SizedBox(height: 6),
                Row(
                  children: const [
                    Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFE02424)),
                    SizedBox(width: 4),
                    Text(
                      'Enter a budget above 0',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFE02424),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),

              // Billing day of month
              _FieldColumn(
                label: 'Billing day of month',
                controller: _billingDay,
                isError: hasDayError,
              ),
              if (hasDayError) ...[
                const SizedBox(height: 6),
                Row(
                  children: const [
                    Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFE02424)),
                    SizedBox(width: 4),
                    Text(
                      'Enter a day from 1 to 28',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFE02424),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                const SizedBox(height: 4),
                const Text(
                  '1 to 28, the day your bill period starts',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Save Button
              GestureDetector(
                onTap: _saving ? null : _save,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: _showErrors
                        ? const Color(0xFF84E1BC)
                        : const Color(0xFF0E9F6E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _saving ? 'Saving…' : 'Save billing settings',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Input field column for sheets
class _FieldColumn extends StatelessWidget {
  const _FieldColumn({
    required this.label,
    required this.controller,
    this.suffix,
    this.isError = false,
  });

  final String label;
  final TextEditingController controller;
  final String? suffix;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF55625D),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: isError ? const Color(0xFFE02424) : const Color(0xFFE1E9E5),
              width: isError ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF0F1714),
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (suffix != null) ...[
                const SizedBox(width: 8),
                Text(
                  suffix!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Currency selector pill
class _CurrencyPill extends StatelessWidget {
  const _CurrencyPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0E9F6E) : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFF0E9F6E) : const Color(0xFFE1E9E5),
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : const Color(0xFF0F1714),
          ),
        ),
      ),
    );
  }
}

/// Bottom Sheet: Add actual bill (Screen 115: 18:2708)
class _AddBillSheet extends StatefulWidget {
  const _AddBillSheet({
    required this.repository,
    required this.onSaved,
  });

  final SemsRepository repository;
  final VoidCallback onSaved;

  @override
  State<_AddBillSheet> createState() => _AddBillSheetState();
}

class _AddBillSheetState extends State<_AddBillSheet> {
  final TextEditingController _period = TextEditingController(text: 'Oct 2026');
  final TextEditingController _energy = TextEditingController(text: '240');
  final TextEditingController _amount = TextEditingController(text: '1950');
  bool _saving = false;

  @override
  void dispose() {
    _period.dispose();
    _energy.dispose();
    _amount.dispose();
    super.dispose();
  }

  double get _billedRate {
    final e = double.tryParse(_energy.text) ?? 0;
    final a = double.tryParse(_amount.text) ?? 0;
    if (e <= 0) return 0;
    return a / e;
  }

  Future<void> _save() async {
    final e = double.tryParse(_energy.text) ?? 0;
    final a = double.tryParse(_amount.text) ?? 0;
    if (e <= 0 || a <= 0) return;

    setState(() => _saving = true);
    final bill = BillRecord(
      id: 'bill-${_period.text.toLowerCase().replaceAll(' ', '-')}',
      period: _period.text,
      energyKwh: e,
      amount: a,
      effectiveRate: e > 0 ? a / e : null,
    );
    await widget.repository.saveBill(bill);
    widget.onSaved();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final rate = _billedRate;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag Handle
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 4),
                child: Center(
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

              // Title and close button
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Add actual bill',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F1714),
                          height: 1.33,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        splashRadius: 20,
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

              // Billing period
              _FieldColumn(
                label: 'Billing period',
                controller: _period,
              ),
              const SizedBox(height: 12),

              // Energy on the bill
              _FieldColumn(
                label: 'Energy on the bill',
                controller: _energy,
                suffix: 'kWh',
              ),
              const SizedBox(height: 12),

              // Amount paid (Billed)
              _FieldColumn(
                label: 'Amount paid (Billed)',
                controller: _amount,
                suffix: '₹',
              ),
              const SizedBox(height: 6),

              // Billed rate calculated text
              Text(
                'Billed rate ₹${rate.toStringAsFixed(2)} per kWh',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF55625D),
                ),
              ),
              const SizedBox(height: 20),

              // Save bill button
              GestureDetector(
                onTap: _saving ? null : _save,
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E9F6E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _saving ? 'Saving…' : 'Save bill',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
