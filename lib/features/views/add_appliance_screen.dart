import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/session/demo_session.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/sems_models.dart';
import '../../data/repositories/sems_repository.dart';

class AddApplianceScreen extends StatefulWidget {
  const AddApplianceScreen({
    super.key,
    required this.repository,
    this.initialName,
    this.showInitialError = false,
  });

  final SemsRepository repository;
  final String? initialName;
  final bool showInitialError;

  @override
  State<AddApplianceScreen> createState() => _AddApplianceScreenState();
}

class _AddApplianceScreenState extends State<AddApplianceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ratedPowerController = TextEditingController();
  String _category = 'Heater';
  String? _socketId;
  String? _nameError;
  bool _saving = false;

  static const _categories = <(String, String)>[
    ('Heater', AppAssets.iconFlame),
    ('Fan', AppAssets.iconFan),
    ('Fridge', AppAssets.iconFridge),
    ('Water htr', AppAssets.iconDroplet),
    ('AC', AppAssets.iconSnow),
    ('Lighting', AppAssets.iconBulb),
    ('Television', AppAssets.iconTv),
    ('Other', AppAssets.iconZap),
  ];

  @override
  void initState() {
    super.initState();
    _nameController.text =
        widget.initialName ?? (widget.showInitialError ? '' : 'Room heater');
    if (widget.showInitialError) {
      _nameError = 'Give the appliance a name';
    }
    _nameController.addListener(() {
      if (_nameError != null && _nameController.text.trim().isNotEmpty) {
        setState(() => _nameError = null);
      }
    });
    _ratedPowerController.text = '2000';
    final sockets = widget.repository.devices;
    if (sockets.isNotEmpty) {
      _socketId = sockets.first.id;
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
      backgroundColor: const Color(0xFFF4F7F6),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar (height 56, back button, title, role badge)
            Container(
              height: 56,
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: IconButton(
                      tooltip: 'Back',
                      padding: EdgeInsets.zero,
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
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Add appliance',
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 20,
                        height: 24 / 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F1714),
                      ),
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
                    child: Text(
                      DemoSession.isMember ? 'Family' : 'Owner',
                      style: const TextStyle(
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
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  children: [
                    // Field 1: Name
                    const Text(
                      'Name',
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 12,
                        height: 16 / 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF55625D),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _nameError != null
                              ? const Color(0xFFD64545)
                              : const Color(0xFFE1E9E5),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.centerLeft,
                      child: TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        style: const TextStyle(
                          fontFamily: AppText.family,
                          fontSize: 15,
                          height: 20 / 15,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF0F1714),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'e.g. Room heater',
                          hintStyle: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 15,
                            height: 20 / 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF55625D),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          filled: false,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          errorStyle: TextStyle(fontSize: 0, height: 0),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '';
                          }
                          return null;
                        },
                      ),
                    ),
                    if (_nameError != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppAssets.iconAlert,
                            width: 13,
                            height: 13,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFD64545),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _nameError!,
                            style: const TextStyle(
                              fontFamily: AppText.family,
                              fontSize: 12,
                              height: 16 / 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFD64545),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Field 2: Category
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: const [
                        Opacity(
                          opacity: 0.0,
                          child: Text('CATEGORY'),
                        ),
                        Text(
                          'Category',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 12,
                            height: 16 / 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF55625D),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (int i = 0; i < 4; i++) ...[
                          if (i > 0) const SizedBox(width: 8),
                          Expanded(
                            child: SizedBox(
                              height: 74,
                              child: _buildCategoryTile(
                                label: _categories[i].$1,
                                svgAsset: _categories[i].$2,
                                selected: _category == _categories[i].$1,
                                onTap: () {
                                  if (!_saving) {
                                    setState(() => _category = _categories[i].$1);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        for (int i = 4; i < 8; i++) ...[
                          if (i > 4) const SizedBox(width: 8),
                          Expanded(
                            child: SizedBox(
                              height: 74,
                              child: _buildCategoryTile(
                                label: _categories[i].$1,
                                svgAsset: _categories[i].$2,
                                selected: _category == _categories[i].$1,
                                onTap: () {
                                  if (!_saving) {
                                    setState(() => _category = _categories[i].$1);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Field 3: Rated power (optional)
                    const Text(
                      'Rated power (optional)',
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 12,
                        height: 16 / 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF55625D),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE1E9E5)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _ratedPowerController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                fontFamily: AppText.family,
                                fontSize: 15,
                                height: 20 / 15,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF0F1714),
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                filled: false,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return null;
                                }
                                final watts = int.tryParse(value.trim());
                                return watts == null || watts <= 0
                                    ? 'Enter a power greater than 0'
                                    : null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'W',
                            style: TextStyle(
                              fontFamily: AppText.family,
                              fontSize: 13,
                              height: 18 / 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF55625D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Used to flag unusual power draw',
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 12,
                        height: 16 / 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF55625D),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Field 4: Connect to socket
                    const Text(
                      'Connect to socket',
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 12,
                        height: 16 / 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF55625D),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Socket options
                    for (final socket in sockets) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _buildSocketCard(
                          title: socket.name,
                          subtitle:
                              '${socket.id} · currently ${socket.appliance}',
                          selected: _socketId == socket.id,
                          onTap: () {
                            if (!_saving) {
                              setState(() => _socketId = socket.id);
                            }
                          },
                        ),
                      ),
                    ],
                    // Assign later option
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _buildSocketCard(
                        title: 'Assign later',
                        subtitle: 'Create it now, connect it to a socket later',
                        selected: _socketId == null,
                        onTap: () {
                          if (!_saving) {
                            setState(() => _socketId = null);
                          }
                        },
                      ),
                    ),

                    // Warning banner if reassigning
                    if (selectedSocket != null &&
                        selectedSocket.appliance != 'Unassigned') ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCF0D9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFD98A00)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              AppAssets.iconInfo,
                              width: 19,
                              height: 19,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFD98A00),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${selectedSocket.appliance} will be unassigned',
                                    style: const TextStyle(
                                      fontFamily: AppText.family,
                                      fontSize: 13,
                                      height: 20 / 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0F1714),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'One socket serves one appliance. ${selectedSocket.appliance}\'s session closes at the current meter reading and its history stays.',
                                    style: const TextStyle(
                                      fontFamily: AppText.family,
                                      fontSize: 12,
                                      height: 18 / 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF55625D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    if (selectedSocket != null)
                      Text(
                        'Creating it opens a new usage session starting at meter ${(selectedSocket.meterKwh).toStringAsFixed(2)} kWh.',
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
            ),

            // Footer (height ~80, padding 12px 16px 20px, border top 1px)
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF4F7F6),
                border: Border(
                  top: BorderSide(color: Color(0xFFE1E9E5)),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E9F6E),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onPressed: _saving || DemoSession.isMember ? null : _save,
                  child: Text(
                    _saving ? 'Adding…' : 'Create appliance',
                    style: const TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 15,
                      height: 20 / 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile({
    required String label,
    required String svgAsset,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFDDF4EA) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFF0E9F6E)
                  : const Color(0xFFE1E9E5),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                svgAsset,
                width: 22,
                height: 22,
                colorFilter: ColorFilter.mode(
                  selected ? const Color(0xFF0E9F6E) : const Color(0xFF55625D),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 11,
                  height: 14 / 11,
                  fontWeight: FontWeight.w500,
                  color: selected
                      ? const Color(0xFF0F1714)
                      : const Color(0xFF55625D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocketCard({
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFDDF4EA) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFF0E9F6E)
                  : const Color(0xFFE1E9E5),
            ),
          ),
          child: Row(
            children: [
              // Radio indicator
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF0E9F6E)
                        : const Color(0xFFE1E9E5),
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: selected
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0E9F6E),
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
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
                        fontSize: 14,
                        height: 20 / 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0F1714),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 12,
                        height: 18 / 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF55625D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final nameValid = _nameController.text.trim().isNotEmpty;
    if (!nameValid) {
      setState(() {
        _nameError = 'Give the appliance a name';
      });
    }
    if (!_formKey.currentState!.validate() || !nameValid) return;
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
