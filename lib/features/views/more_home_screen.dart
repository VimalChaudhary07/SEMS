import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/session/demo_session.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/sems_models.dart';
import '../../data/repositories/sems_repository.dart';
import '../../shared/widgets/sems_widgets.dart';
import 'add_appliance_screen.dart';
import 'auth_screens.dart';
import 'backup_restore_screen.dart';
import 'device_detail_screen.dart';
import 'insights_screen.dart';
import 'more_screens.dart';
import 'settings_detail_screens.dart';
import 'settings_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key, required this.repository});
  final SemsRepository repository;

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool _darkTheme = false;

  void _push(Widget page) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));

  void _signOut() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'Your data stays on this phone. Sign in again to control sockets.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          AppButton(
            fullWidth: false,
            variant: AppButtonVariant.danger,
            onPressed: () {
              DemoSession.role.value = DemoRole.owner;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(builder: (_) => const SignInScreen()),
                (_) => false,
              );
            },
            label: 'Sign out',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeAppliances = widget.repository.appliances
        .where((item) => !item.archived)
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F7F6),
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 56,
        titleSpacing: 16,
        title: const Text(
          'More',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F1714),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: RoleBadge(
              isFamily: DemoSession.isMember,
              showIcon: false,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          // Profile Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E9E5)),
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
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0E9F6E),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'AV',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Asha Verma',
                        style: TextStyle(
                          color: Color(0xFF0F1714),
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          height: 1.41,
                        ),
                      ),
                      Text(
                        'owner@sems.app',
                        style: TextStyle(
                          color: Color(0xFF55625D),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          height: 1.38,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDF4EA),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppAssets.iconUser,
                        width: 13,
                        height: 13,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF0E9F6E),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DemoSession.isMember ? 'Family' : 'Owner',
                        style: const TextStyle(
                          color: Color(0xFF0E9F6E),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Group 1 Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E9E5)),
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
                _MoreRow(
                  svgIcon: AppAssets.iconLayers,
                  iconBg: const Color(0xFFDDF4EA),
                  iconColor: const Color(0xFF0E9F6E),
                  title: 'Appliances',
                  subtitle: '$activeAppliances active',
                  onTap: () => _push(AppliancesScreen(repository: widget.repository)),
                ),
                const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
                _MoreRow(
                  svgIcon: AppAssets.iconCalendar,
                  iconBg: const Color(0xFFDDF4EA),
                  iconColor: const Color(0xFF0E9F6E),
                  title: 'Scheduling',
                  subtitle: '2 active schedules',
                  onTap: () => _push(SchedulesScreen(repository: widget.repository)),
                ),
                const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
                _MoreRow(
                  svgIcon: AppAssets.iconReceipt,
                  iconBg: const Color(0xFFDDF4EA),
                  iconColor: const Color(0xFF0E9F6E),
                  title: 'Billing and tariff',
                  subtitle: 'Bills, budget, estimates',
                  onTap: () => _push(
                    TariffSettingsScreen(
                      repository: widget.repository,
                      readOnly: DemoSession.isMember,
                    ),
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
                _MoreRow(
                  svgIcon: AppAssets.iconSparkle,
                  iconBg: const Color(0xFFECE6FB),
                  iconColor: const Color(0xFF7E3AF2),
                  title: 'AI energy',
                  subtitle: 'Forecasts and tips',
                  onTap: () => _push(InsightsScreen(repository: widget.repository)),
                ),
                const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
                _MoreRow(
                  svgIcon: AppAssets.iconCloud,
                  iconBg: const Color(0xFFDDF4EA),
                  iconColor: const Color(0xFF0E9F6E),
                  title: 'Backup and restore',
                  subtitle: 'Google Drive connected',
                  onTap: () {
                    if (DemoSession.isMember) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Backup is available to the owner in this demo.',
                          ),
                        ),
                      );
                    } else {
                      _push(const BackupRestoreScreen());
                    }
                  },
                ),
                const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
                _MoreRow(
                  svgIcon: AppAssets.iconSliders,
                  iconBg: const Color(0xFFDDF4EA),
                  iconColor: const Color(0xFF0E9F6E),
                  title: 'Settings',
                  subtitle: 'Profile, notifications, privacy',
                  onTap: () => _push(const SettingsScreen()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Group 2 Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E9E5)),
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
                InkWell(
                  onTap: () => setState(() => _darkTheme = !_darkTheme),
                  child: Padding(
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
                            AppAssets.iconMoon,
                            width: 19,
                            height: 19,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF0F1714),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Dark theme',
                            style: TextStyle(
                              color: Color(0xFF0F1714),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 1.33,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _darkTheme = !_darkTheme),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 46,
                            height: 28,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: _darkTheme ? const Color(0xFF0E9F6E) : const Color(0xFFE1E9E5),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Align(
                              alignment: _darkTheme ? Alignment.centerRight : Alignment.centerLeft,
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
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
                InkWell(
                  onTap: _signOut,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBE6E6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            AppAssets.iconLogout,
                            width: 19,
                            height: 19,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFD64545),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Sign out',
                            style: TextStyle(
                              color: Color(0xFFD64545),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 1.33,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'SEMS v1.0.0 · Example data only',
              style: TextStyle(
                color: Color(0xFF55625D),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreRow extends StatelessWidget {
  const _MoreRow({
    required this.svgIcon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String svgIcon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                svgIcon,
                width: 19,
                height: 19,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
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
                      color: Color(0xFF0F1714),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF55625D),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              AppAssets.iconChevRight,
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                Color(0xFF55625D),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppliancesScreen extends StatefulWidget {
  const AppliancesScreen({super.key, required this.repository});
  final SemsRepository repository;
  @override
  State<AppliancesScreen> createState() => _AppliancesScreenState();
}

class _AppliancesScreenState extends State<AppliancesScreen> {
  @override
  Widget build(BuildContext context) {
    final active =
        widget.repository.appliances.where((item) => !item.archived).toList();
    final archived =
        widget.repository.appliances.where((item) => item.archived).toList();
    final isEmpty = active.isEmpty && archived.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar (height 56px, back arrow, title, plus action, role badge)
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
                      'Appliances',
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 20,
                        height: 24 / 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F1714),
                      ),
                    ),
                  ),
                  if (!DemoSession.isMember)
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: _addAppliance,
                        tooltip: 'Add appliance',
                        icon: SvgPicture.asset(
                          AppAssets.iconPlus,
                          width: 22,
                          height: 22,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF0F1714),
                            BlendMode.srcIn,
                          ),
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
              child: isEmpty
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 48,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 96,
                                  height: 96,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEAF1EE),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    AppAssets.iconLayers,
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
                                  'No appliances yet',
                                  style: TextStyle(
                                    fontFamily: AppText.family,
                                    fontSize: 17,
                                    height: 24 / 17,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F1714),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Add an appliance so usage is tracked per device, not just per socket.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppText.family,
                                    fontSize: 14,
                                    height: 20 / 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF55625D),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                    ),
                                    onPressed: _addAppliance,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          AppAssets.iconPlus,
                                          width: 18,
                                          height: 18,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Add appliance',
                                          style: TextStyle(
                                            fontFamily: AppText.family,
                                            fontSize: 15,
                                            height: 20 / 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  // ACTIVE section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'ACTIVE',
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 13,
                        height: 18 / 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.78,
                        color: Color(0xFF55625D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (active.isEmpty)
                    const AppCard(
                      child: Text(
                        'No appliances yet. Add one to start tracking energy use.',
                        style: TextStyle(color: SemsColors.muted),
                      ),
                    ),
                  for (final appliance in active) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _activeApplianceCard(appliance),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // ARCHIVED section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'ARCHIVED',
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 13,
                        height: 18 / 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.78,
                        color: Color(0xFF55625D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (archived.isEmpty)
                    const AppCard(
                      child: Text(
                        'Archived appliances and their energy history appear here.',
                        style: TextStyle(color: SemsColors.muted),
                      ),
                    ),
                  if (archived.isNotEmpty) ...[
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
                          for (int i = 0; i < archived.length; i++) ...[
                            if (i > 0)
                              Container(
                                height: 1,
                                color: const Color(0xFFE1E9E5),
                              ),
                            _archivedApplianceRow(archived[i]),
                          ],
                        ],
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

  Widget _activeApplianceCard(SemsAppliance appliance) {
    final isOnline = appliance.online;
    return Container(
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ApplianceOverviewScreen(
                appliance: appliance,
                repository: widget.repository,
                onChanged: () => setState(() {}),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // 44x44 icon badge
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isOnline
                        ? const Color(0xFFDDF4EA)
                        : const Color(0xFFECEEF0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    _applianceSvgIcon(appliance.name),
                    width: 22,
                    height: 22,
                    colorFilter: ColorFilter.mode(
                      isOnline
                          ? const Color(0xFF0E9F6E)
                          : const Color(0xFF55625D),
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
                        appliance.name,
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
                        appliance.socketId == null
                            ? (appliance.room.isEmpty
                                ? 'No room'
                                : appliance.room)
                            : '${appliance.room} · ${appliance.socketId}',
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isOnline ? _formatWatts(appliance.watts) : '—',
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 16,
                        height: 24 / 16,
                        fontWeight: FontWeight.w600,
                        color: isOnline
                            ? const Color(0xFF0F1714)
                            : const Color(0xFF55625D),
                      ),
                    ),
                    Text(
                      '${appliance.todayKwh} kWh today',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _archivedApplianceRow(SemsAppliance appliance) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ApplianceOverviewScreen(
              appliance: appliance,
              repository: widget.repository,
              onChanged: () => setState(() {}),
            ),
          ),
        ),
        child: Padding(
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
                  AppAssets.iconArchive,
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
                      appliance.name,
                      style: const TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 15,
                        height: 20 / 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF0F1714),
                      ),
                    ),
                    Text(
                      '${appliance.lifetimeKwh} kWh lifetime · history kept',
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
              SvgPicture.asset(
                AppAssets.iconChevRight,
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF55625D),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatWatts(int watts) {
    if (watts <= 0) return '—';
    if (watts >= 1000) {
      final thousands = watts ~/ 1000;
      final remainder = watts % 1000;
      return '$thousands,${remainder.toString().padLeft(3, '0')} W';
    }
    return '$watts W';
  }

  static String _applianceSvgIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('fan')) return AppAssets.iconFan;
    if (lower.contains('fridge') || lower.contains('refrigerator')) {
      return AppAssets.iconFridge;
    }
    if (lower.contains('heater')) return AppAssets.iconFlame;
    return AppAssets.iconZap;
  }

  Future<void> _addAppliance() async {
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddApplianceScreen(repository: widget.repository),
      ),
    );
    if (added == true && mounted) setState(() {});
  }
}

void _showApplianceMessage(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));

class ApplianceOverviewScreen extends StatefulWidget {
  const ApplianceOverviewScreen({
    super.key,
    required this.appliance,
    required this.repository,
    required this.onChanged,
  });
  final SemsAppliance appliance;
  final SemsRepository repository;
  final VoidCallback onChanged;
  @override
  State<ApplianceOverviewScreen> createState() =>
      _ApplianceOverviewScreenState();
}

class _ApplianceOverviewScreenState extends State<ApplianceOverviewScreen> {
  late SemsAppliance appliance = widget.appliance;
  bool working = false;

  @override
  Widget build(BuildContext context) {
    final isOnline = appliance.online;
    final socketSubtitle = appliance.socketId == null
        ? (appliance.room.isEmpty ? 'No room' : appliance.room)
        : '${appliance.room} · ${appliance.socketId}';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar (height 56, back button, title/subtitle, role badge)
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
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appliance.name,
                          style: const TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 20,
                            height: 24 / 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F1714),
                          ),
                        ),
                        Text(
                          socketSubtitle,
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
                  // PopupMenuButton for test compatibility (invisible icon)
                  if (!DemoSession.isMember)
                    SizedBox(
                      width: 24,
                      height: 48,
                      child: PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.transparent,
                          size: 20,
                        ),
                        onSelected: (value) async {
                          if (value == 'move') {
                            _move();
                          } else {
                            await _archive();
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'move',
                            child: Text('Move appliance'),
                          ),
                          PopupMenuItem(
                            value: 'archive',
                            child: Text('Archive appliance'),
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
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  // Power now Hero Card
                  _buildPowerNowCard(isOnline),

                  const SizedBox(height: 16),

                  // ENERGY (KEPT SEPARATE) section
                  _buildSectionHeader('ENERGY (KEPT SEPARATE)'),
                  const SizedBox(height: 10),
                  _buildEnergyKeptSeparateSection(),

                  const SizedBox(height: 10),
                  _buildThreeMetricsRow(),

                  const SizedBox(height: 16),

                  // CURRENT SESSION section
                  _buildSectionHeader('CURRENT SESSION'),
                  const SizedBox(height: 10),
                  _buildCurrentSessionCard(),

                  const SizedBox(height: 16),

                  // AI ANALYSIS section
                  _buildSectionHeader('AI ANALYSIS'),
                  const SizedBox(height: 10),
                  _buildAiAnalysisCard(),

                  const SizedBox(height: 16),

                  // HISTORICAL section
                  _buildSectionHeader('HISTORICAL'),
                  const SizedBox(height: 10),
                  _buildHistoricalSection(),

                  const SizedBox(height: 16),

                  // AI SUGGESTIONS section
                  _buildSectionHeader('AI SUGGESTIONS'),
                  const SizedBox(height: 10),
                  _buildAiSuggestionsCard(),

                  const SizedBox(height: 16),

                  // RELATED section
                  _buildSectionHeader('RELATED'),
                  const SizedBox(height: 10),
                  _buildRelatedCard(),

                  if (!DemoSession.isMember) ...[
                    const SizedBox(height: 16),

                    // MANAGE section
                    _buildSectionHeader('MANAGE'),
                    const SizedBox(height: 10),
                    _buildManageCard(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: AppText.family,
          fontSize: 13,
          height: 18 / 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.78,
          color: Color(0xFF55625D),
        ),
      ),
    );
  }

  Widget _buildPowerNowCard(bool isOnline) {
    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: isOnline
                      ? const Color(0xFFDDF4EA)
                      : const Color(0xFFECEEF0),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  _AppliancesScreenState._applianceSvgIcon(appliance.name),
                  width: 26,
                  height: 26,
                  colorFilter: ColorFilter.mode(
                    isOnline
                        ? const Color(0xFF0E9F6E)
                        : const Color(0xFF55625D),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Power now',
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 12,
                        height: 16 / 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF55625D),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          isOnline ? _formatWattsNumber(appliance.watts) : '—',
                          style: const TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 34,
                            height: 38 / 34,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F1714),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'W',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 15,
                            height: 20 / 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF55625D),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: isOnline
                      ? const Color(0xFFDDF4EA)
                      : const Color(0xFFECEEF0),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssets.iconPower,
                      width: 13,
                      height: 13,
                      colorFilter: ColorFilter.mode(
                        isOnline
                            ? const Color(0xFF0E9F6E)
                            : const Color(0xFF55625D),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isOnline ? 'ON' : 'OFF',
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 12,
                        height: 16 / 12,
                        fontWeight: FontWeight.w500,
                        color: isOnline
                            ? const Color(0xFF0E9F6E)
                            : const Color(0xFF55625D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
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
              onPressed: _openConnectedSocket,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.iconPower,
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Remote control',
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 15,
                      height: 20 / 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyKeptSeparateSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Session kWh',
                value: (appliance.sessionKwh ?? 4.2).toStringAsFixed(2),
                unit: 'kWh',
                subtitle: 'Since this session began',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMetricCard(
                title: 'Today kWh',
                value: appliance.todayKwh.toStringAsFixed(2),
                unit: 'kWh',
                subtitle: 'Calendar day',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Billing-period kWh',
                value: '106.5',
                unit: 'kWh',
                subtitle: 'Current period',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMetricCard(
                title: 'Appliance lifetime',
                value: appliance.lifetimeKwh.toStringAsFixed(1),
                unit: 'kWh',
                subtitle: 'All sessions added up',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Dashed socket meter banner
        DashedOutline(
          color: const Color(0xFFE1E9E5),
          radius: 12,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppAssets.iconInfo,
                  width: 18,
                  height: 18,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF55625D),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Socket meter lifetime reading is ${(appliance.meterKwh ?? 150.0).toStringAsFixed(2)} kWh. It belongs to the socket, not this appliance.',
                    style: const TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 12,
                      height: 18 / 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF55625D),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    String? unit,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E9E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: AppText.family,
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF55625D),
            ),
          ),
          const SizedBox(height: 3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 20,
                  height: 24 / 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F1714),
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: const TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 12,
                    height: 16 / 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF55625D),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: AppText.family,
              fontSize: 11,
              height: 14 / 11,
              fontWeight: FontWeight.w400,
              color: Color(0xFF55625D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreeMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Runtime today',
            value: '2.2',
            unit: 'h',
            subtitle: '',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE1E9E5)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Peak power',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 12,
                    height: 16 / 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF55625D),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '2,260 W',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 20,
                    height: 24 / 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F1714),
                  ),
                ),
                SizedBox(height: 17),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DashedOutline(
            color: const Color(0xFF55625D),
            radius: 12,
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
                        'Cost today',
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
                  const SizedBox(height: 3),
                  const Text(
                    '₹24',
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 20,
                      height: 24 / 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F1714),
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Estimated',
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 11,
                      height: 14 / 11,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF55625D),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentSessionCard() {
    return Container(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Socket',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 15,
                    height: 20 / 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F1714),
                  ),
                ),
                Text(
                  appliance.socketId ?? 'None',
                  style: const TextStyle(
                    fontFamily: 'JetBrains Mono',
                    fontSize: 12,
                    height: 16 / 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F1714),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Started',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 15,
                    height: 20 / 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F1714),
                  ),
                ),
                Text(
                  appliance.sessionStartedAt ?? 'Yesterday 22:41',
                  style: const TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 13,
                    height: 18 / 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F1714),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Meter at start',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 15,
                    height: 20 / 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F1714),
                  ),
                ),
                Text(
                  '${(appliance.sessionStartMeterKwh ?? 145.8).toStringAsFixed(2)} kWh',
                  style: const TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 13,
                    height: 18 / 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0F1714),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiAnalysisCard() {
    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBE6E6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
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
                    const Text(
                      'Strong anomaly',
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 12,
                        height: 16 / 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFD64545),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFECE6FB),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssets.iconSparkle,
                      width: 13,
                      height: 13,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF7C5CE0),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Estimated',
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 12,
                        height: 16 / 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7C5CE0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Possible abnormal behaviour. Please check the appliance.',
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 13,
              height: 20 / 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF0F1714),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Normal power range',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 12,
                            height: 16 / 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF55625D),
                          ),
                        ),
                        Text(
                          '1,300 to 1,550 W',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 13,
                            height: 18 / 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F1714),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Current deviation',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 12,
                            height: 16 / 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF55625D),
                          ),
                        ),
                        Text(
                          '+47%',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 13,
                            height: 18 / 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFD98A00),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Normal duration',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 12,
                            height: 16 / 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF55625D),
                          ),
                        ),
                        Text(
                          '2 h/day',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 13,
                            height: 18 / 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F1714),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Current duration',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 12,
                            height: 16 / 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF55625D),
                          ),
                        ),
                        Text(
                          '3 h today',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 13,
                            height: 18 / 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F1714),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoricalSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Daily',
                value: '3.1',
                unit: 'kWh',
                subtitle: 'Measured',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMetricCard(
                title: 'Weekly',
                value: '21',
                unit: 'kWh',
                subtitle: 'Measured',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMetricCard(
                title: 'Monthly',
                value: '92',
                unit: 'kWh',
                subtitle: 'Measured',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            children: [
              const Expanded(
                child: Text(
                  'Trend vs last week',
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 13,
                    height: 18 / 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBE6E6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssets.iconTrend,
                      width: 13,
                      height: 13,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFD64545),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Increasing +47%',
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 12,
                        height: 16 / 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFD64545),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFECE6FB),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssets.iconSparkle,
                      width: 13,
                      height: 13,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF7C5CE0),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Estimated',
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 12,
                        height: 16 / 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7C5CE0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAiSuggestionsCard() {
    return Container(
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
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Reduce heater usage 1 hr/day',
                style: TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 15,
                  height: 20 / 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F1714),
                ),
              ),
              const Spacer(),
              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFECE6FB),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssets.iconSparkle,
                      width: 13,
                      height: 13,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF7C5CE0),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Estimated',
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 12,
                        height: 16 / 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7C5CE0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Save ₹20/day, ₹600/month, 60 kWh/month',
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 13,
              height: 18 / 13,
              fontWeight: FontWeight.w400,
              color: Color(0xFF55625D),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '25.0% of your daily consumption',
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF55625D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedCard() {
    return Container(
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
          _buildActionRow(
            icon: AppAssets.iconCalendar,
            iconBg: const Color(0xFFEAF1EE),
            iconColor: const Color(0xFF55625D),
            title: 'Schedules',
            subtitle: 'Evening heater: Today 18:00',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => SchedulesScreen(repository: widget.repository),
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
          _buildActionRow(
            icon: AppAssets.iconBell,
            iconBg: const Color(0xFFFBE6E6),
            iconColor: const Color(0xFFD64545),
            title: 'Alerts',
            subtitle: '1 needs attention',
            onTap: () {},
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
          _buildActionRow(
            icon: AppAssets.iconSparkle,
            iconBg: const Color(0xFFECE6FB),
            iconColor: const Color(0xFF7C5CE0),
            title: 'AI insight',
            subtitle: 'Higher than your normal pattern (Estimated)',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => InsightsScreen(repository: widget.repository),
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
          _buildActionRow(
            icon: AppAssets.iconClock,
            iconBg: const Color(0xFFEAF1EE),
            iconColor: const Color(0xFF55625D),
            title: 'Usage history',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildManageCard() {
    return Container(
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
          _buildActionRow(
            icon: AppAssets.iconSwap,
            iconBg: const Color(0xFFEAF1EE),
            iconColor: const Color(0xFF55625D),
            title: 'Move to another socket',
            subtitle: 'Closes this session and starts a new one',
            onTap: _move,
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
          _buildActionRow(
            icon: AppAssets.iconArchive,
            iconBg: const Color(0xFFFBE6E6),
            iconColor: const Color(0xFFD64545),
            title: 'Archive appliance',
            titleColor: const Color(0xFFD64545),
            subtitle: 'History is kept',
            onTap: _archive,
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required String icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    Color? titleColor,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  icon,
                  width: 19,
                  height: 19,
                  colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: AppText.family,
                        fontSize: 15,
                        height: 20 / 15,
                        fontWeight: FontWeight.w500,
                        color: titleColor ?? const Color(0xFF0F1714),
                      ),
                    ),
                    if (subtitle != null) ...[
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
                  ],
                ),
              ),
              SvgPicture.asset(
                AppAssets.iconChevRight,
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF55625D),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatWattsNumber(int watts) {
    if (watts <= 0) return '0';
    if (watts >= 1000) {
      final thousands = watts ~/ 1000;
      final remainder = watts % 1000;
      return '$thousands,${remainder.toString().padLeft(3, '0')}';
    }
    return '$watts';
  }

  void _openConnectedSocket() {
    if (appliance.socketId == null) return;
    try {
      final socket = widget.repository.devices.firstWhere(
        (item) => item.id == appliance.socketId,
      );
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => DeviceDetailScreen(
            device: socket,
            repository: widget.repository,
            onChanged: widget.onChanged,
          ),
        ),
      );
    } catch (_) {}
  }

  void _move() {
    final socketId = appliance.socketId;
    if (socketId == null) {
      _showApplianceMessage(
        context,
        'Assign a socket before moving this appliance.',
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => MoveApplianceScreen(
          appliance: appliance,
          repository: widget.repository,
          onChanged: widget.onChanged,
        ),
      ),
    ).then((_) => _refresh());
  }

  Future<void> _refresh() async {
    if (!mounted) return;
    final updated = widget.repository.appliances.where(
      (item) => item.id == appliance.id,
    );
    if (updated.isNotEmpty) setState(() => appliance = updated.first);
  }

  Future<void> _archive() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive appliance?'),
        content: const Text(
          'This ends any active session and keeps the appliance’s energy history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          AppButton(
            fullWidth: false,
            variant: AppButtonVariant.danger,
            onPressed: () => Navigator.pop(context, true),
            label: 'Archive',
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    setState(() => working = true);
    try {
      await widget.repository.archiveAppliance(appliance.id);
      widget.onChanged();
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        _showApplianceMessage(context, 'Could not archive appliance: $error');
      }
    } finally {
      if (mounted) setState(() => working = false);
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: SemsColors.muted)),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

class MoveApplianceScreen extends StatefulWidget {
  const MoveApplianceScreen({
    super.key,
    required this.appliance,
    required this.repository,
    required this.onChanged,
  });
  final SemsAppliance appliance;
  final SemsRepository repository;
  final VoidCallback onChanged;
  @override
  State<MoveApplianceScreen> createState() => _MoveApplianceScreenState();
}

class _MoveApplianceScreenState extends State<MoveApplianceScreen> {
  int step = 0;
  String? selected;
  bool working = false;

  SemsDevice? get destination {
    for (final device in widget.repository.devices) {
      if (device.id == selected) return device;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Move ${widget.appliance.name}')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        AppProgressBar(value: step >= 3 ? 1 : (step + 1) / 3, height: 5),
        const SizedBox(height: 24),
        Text(
          [
            'Close current session',
            'Choose new socket',
            'Review and confirm',
            'Appliance moved',
          ][step],
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          [
            'The current meter session will be closed and its final reading kept.',
            'Choose an online SEMS socket. Any appliance there will be unassigned, with its history preserved.',
            'Review the source and destination meter readings before confirming.',
            'The new session is open. Previous appliance history is preserved.',
          ][step],
          style: const TextStyle(color: SemsColors.muted),
        ),
        const SizedBox(height: 20),
        if (step == 0)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(label: 'Appliance', value: widget.appliance.name),
                _DetailRow(
                  label: 'Current socket',
                  value: widget.appliance.socketId ?? 'Not assigned',
                ),
                _DetailRow(
                  label: 'Session energy',
                  value: widget.appliance.sessionKwh == null
                      ? 'No active session'
                      : '${widget.appliance.sessionKwh!.toStringAsFixed(2)} kWh',
                ),
                if (widget.appliance.meterKwh != null)
                  _DetailRow(
                    label: 'Current meter',
                    value:
                        '${widget.appliance.meterKwh!.toStringAsFixed(1)} kWh',
                  ),
              ],
            ),
          ),
        if (step == 1)
          RadioGroup<String>(
            groupValue: selected,
            onChanged: (value) => setState(() => selected = value),
            child: Column(
              children: [
                for (final device in widget.repository.devices.where(
                  (d) =>
                      d.id != widget.appliance.socketId &&
                      d.online &&
                      !d.safetyTrip,
                ))
                  RadioListTile<String>(
                    value: device.id,
                    title: Text(device.name),
                    subtitle: Text(
                      '${device.room} · ${device.id} · ${device.appliance == 'Unassigned' ? 'Available' : 'Currently ${device.appliance}'}',
                    ),
                  ),
              ],
            ),
          ),
        if (step == 1 &&
            !widget.repository.devices.any(
              (device) =>
                  device.id != widget.appliance.socketId &&
                  device.online &&
                  !device.safetyTrip,
            ))
          const AppCard(
            child: Text(
              'No online destination sockets are available. Connect another socket and try again.',
            ),
          ),
        if (step == 2 && destination != null)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(label: 'Appliance', value: widget.appliance.name),
                _DetailRow(
                  label: 'From',
                  value: widget.appliance.socketId ?? 'Not assigned',
                ),
                _DetailRow(label: 'To', value: destination!.name),
                _DetailRow(
                  label: 'Destination meter',
                  value: '${destination!.meterKwh.toStringAsFixed(1)} kWh',
                ),
                if (destination!.appliance != 'Unassigned')
                  _DetailRow(
                    label: 'Current appliance',
                    value: '${destination!.appliance} will be unassigned',
                  ),
                const Text(
                  'The current session will close. A new meter session starts at the destination reading.',
                  style: TextStyle(color: SemsColors.muted, height: 1.4),
                ),
              ],
            ),
          ),
        if (step == 3)
          const AppCard(
            child: Text(
              'Move completed locally. Meter sessions were updated; no hardware or backend was contacted.',
            ),
          ),
        const SizedBox(height: 24),
        AppButton(
          onPressed: working
              ? null
              : step == 3
              ? () => Navigator.pop(context)
              : _next,
          label: working
              ? 'Moving…'
              : step == 2
              ? 'Confirm move'
              : step == 3
              ? 'Done'
              : 'Continue',
        ),
      ],
    ),
  );

  Future<void> _next() async {
    if (step == 1 && selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a socket to continue.')),
      );
      return;
    }
    if (step == 2 && selected != null) {
      setState(() => working = true);
      try {
        await widget.repository.moveAppliance(
          widget.appliance.socketId!,
          selected!,
        );
        widget.onChanged();
        if (mounted) setState(() => step++);
      } catch (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not move appliance: $error')),
          );
        }
      } finally {
        if (mounted) setState(() => working = false);
      }
      return;
    }
    setState(() => step++);
  }
}
