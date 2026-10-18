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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Appliances'),
      actions: [
        if (!DemoSession.isMember)
          IconButton(
            onPressed: _addAppliance,
            tooltip: 'Add appliance',
            icon: const Icon(Icons.add_rounded),
          ),
      ],
    ),
    body: Builder(
      builder: (context) {
        final active = widget.repository.appliances
            .where((item) => !item.archived)
            .toList();
        final archived = widget.repository.appliances
            .where((item) => item.archived)
            .toList();
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SectionTitle('ACTIVE'),
            const SizedBox(height: 8),
            if (active.isEmpty)
              const AppCard(
                child: Text(
                  'No appliances yet. Add one to start tracking energy use.',
                  style: TextStyle(color: SemsColors.muted),
                ),
              ),
            for (final appliance in active)
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: AppCard(
                  child: ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ApplianceOverviewScreen(
                          appliance: appliance,
                          repository: widget.repository,
                          onChanged: () => setState(() {}),
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: appliance.online
                            ? SemsColors.mint
                            : const Color(0xFFECEEF0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _applianceIcon(appliance.name),
                        color: appliance.online
                            ? SemsColors.forest
                            : SemsColors.muted,
                      ),
                    ),
                    title: Text(
                      appliance.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      appliance.socketId == null
                          ? '${appliance.room.isEmpty ? 'No room' : appliance.room} · Assign a socket later'
                          : '${appliance.room} · ${appliance.socketId} · ${appliance.online ? 'Online' : 'Offline'}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: SemsColors.muted,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          appliance.online ? '${appliance.watts} W' : '—',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '${appliance.todayKwh} kWh today',
                          style: const TextStyle(
                            color: SemsColors.muted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            const SectionTitle('ARCHIVED'),
            const SizedBox(height: 8),
            if (archived.isEmpty)
              const AppCard(
                child: Text(
                  'Archived appliances and their energy history appear here.',
                  style: TextStyle(color: SemsColors.muted),
                ),
              ),
            for (final appliance in archived)
              AppCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.inventory_2_outlined,
                    color: SemsColors.muted,
                  ),
                  title: Text(appliance.name),
                  subtitle: Text(
                    '${appliance.lifetimeKwh} kWh lifetime · history kept',
                    style: const TextStyle(
                      fontSize: 11,
                      color: SemsColors.muted,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    ),
  );

  Future<void> _addAppliance() async {
    final added = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AddApplianceScreen(repository: widget.repository),
      ),
    );
    if (added == true && mounted) setState(() {});
  }

  static IconData _applianceIcon(String name) =>
      name.toLowerCase().contains('fan')
      ? Icons.toys_outlined
      : name.toLowerCase().contains('fridge')
      ? Icons.kitchen_outlined
      : name.toLowerCase().contains('heater')
      ? Icons.local_fire_department_outlined
      : Icons.power_rounded;
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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(appliance.name),
      actions: [
        if (!DemoSession.isMember)
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'move') {
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
              } else {
                await _archive();
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'move', child: Text('Move appliance')),
              PopupMenuItem(value: 'archive', child: Text('Archive appliance')),
            ],
          ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        AppCard(
          child: Column(
            children: [
              Icon(
                _AppliancesScreenState._applianceIcon(appliance.name),
                size: 48,
                color: appliance.online ? SemsColors.forest : SemsColors.muted,
              ),
              const SizedBox(height: 12),
              Text(
                appliance.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                appliance.socketId == null
                    ? '${appliance.room.isEmpty ? 'No room assigned' : appliance.room} · Not connected'
                    : '${appliance.room} · ${appliance.socketId}',
                style: const TextStyle(color: SemsColors.muted),
              ),
              const SizedBox(height: 10),
              StatusBadge(
                label: appliance.archived
                    ? 'Archived'
                    : appliance.socketId == null
                    ? 'Assign a socket'
                    : appliance.online
                    ? 'Online'
                    : 'Offline',
                icon: appliance.online
                    ? Icons.wifi_rounded
                    : Icons.wifi_off_rounded,
                tone: appliance.online ? StatusTone.ok : StatusTone.off,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                label: 'Current draw',
                value: appliance.online ? '${appliance.watts}' : '—',
                unit: 'W',
                icon: Icons.bolt_rounded,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MetricCard(
                label: 'Today',
                value: '${appliance.todayKwh}',
                unit: 'kWh',
                icon: Icons.show_chart_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        const SectionTitle('CURRENT SESSION'),
        const SizedBox(height: 8),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailRow(
                label: 'Session energy',
                value: appliance.sessionKwh == null
                    ? 'No active session'
                    : '${appliance.sessionKwh!.toStringAsFixed(2)} kWh',
              ),
              if (appliance.sessionStartedAt != null)
                _DetailRow(
                  label: 'Started',
                  value: appliance.sessionStartedAt!,
                ),
              if (appliance.meterKwh != null)
                _DetailRow(
                  label: 'Socket meter',
                  value: '${appliance.meterKwh!.toStringAsFixed(1)} kWh',
                ),
              if (appliance.ratedPowerW != null)
                _DetailRow(
                  label: 'Rated power',
                  value: '${appliance.ratedPowerW} W',
                ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const SectionTitle('Consumption history'),
        AppCard(
          child: EnergyBars(
            values: widget.repository.weeklyReadings.map((e) => e.kwh).toList(),
          ),
        ),
        if (appliance.socketId != null) ...[
          const SizedBox(height: 14),
          AppButton(
            onPressed: () {
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
            },
            label: 'Open connected socket',
          ),
        ],
        if (!DemoSession.isMember && !appliance.archived) ...[
          const SizedBox(height: 8),
          AppButton(
            variant: AppButtonVariant.secondary,
            onPressed: working ? null : _rename,
            label: 'Rename appliance',
          ),
        ],
        if (working)
          const Padding(
            padding: EdgeInsets.all(12),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    ),
  );

  Future<void> _refresh() async {
    if (!mounted) return;
    final updated = widget.repository.appliances.where(
      (item) => item.id == appliance.id,
    );
    if (updated.isNotEmpty) setState(() => appliance = updated.first);
  }

  Future<void> _rename() async {
    final controller = TextEditingController(text: appliance.name);
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename appliance'),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          AppButton(
            fullWidth: false,
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            label: 'Save',
          ),
        ],
      ),
    );
    controller.dispose();
    if (value == null || value.isEmpty || !mounted) return;
    setState(() => working = true);
    try {
      await widget.repository.renameApplianceRecord(appliance.id, value);
      await _refresh();
      widget.onChanged();
    } catch (error) {
      if (mounted) {
        _showApplianceMessage(context, 'Could not rename appliance: $error');
      }
    } finally {
      if (mounted) setState(() => working = false);
    }
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
