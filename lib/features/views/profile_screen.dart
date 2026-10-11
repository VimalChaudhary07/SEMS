import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/repositories/sems_repository.dart';
import '../../shared/widgets/sems_widgets.dart';
import 'alerts_screen.dart';
import 'settings_screen.dart';
import 'more_screens.dart';
import 'backup_restore_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.repository});
  final SemsRepository repository;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      children: [
        const PageHeading(
          title: 'Profile',
          subtitle: 'Manage your SEMS experience',
        ),
        const SizedBox(height: 20),
        const AppCard(
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: SemsColors.mint,
                child: Icon(
                  Icons.person_rounded,
                  color: SemsColors.forest,
                  size: 30,
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alex Morgan',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'alex.morgan@example.com',
                      style: TextStyle(color: SemsColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.edit_outlined, color: SemsColors.muted),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const SectionTitle('Preferences'),
        const SizedBox(height: 8),
        _MenuItem(
          icon: Icons.notifications_none_rounded,
          title: 'Notifications',
          subtitle: 'Alerts and device updates',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => AlertsScreen(repository: repository),
            ),
          ),
        ),
        _MenuItem(
          icon: Icons.settings_outlined,
          title: 'Settings',
          subtitle: 'Tariff, units and app preferences',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
          ),
        ),
        _MenuItem(
          icon: Icons.receipt_long_outlined,
          title: 'Estimated bill',
          subtitle: 'Monthly cost breakdown',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => const BillsScreen()),
          ),
        ),
        _MenuItem(
          icon: Icons.schedule_outlined,
          title: 'Timers and schedules',
          subtitle: 'Manage local device routines',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => SchedulesScreen(repository: repository),
            ),
          ),
        ),
        _MenuItem(
          icon: Icons.backup_outlined,
          title: 'Backup and restore',
          subtitle: 'Local preview',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const BackupRestoreScreen(),
            ),
          ),
        ),
        const SizedBox(height: 18),
        const SectionTitle('Support'),
        const SizedBox(height: 8),
        _MenuItem(
          icon: Icons.help_outline_rounded,
          title: 'Help and support',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (_) => const HelpScreen()),
          ),
        ),
        _MenuItem(
          icon: Icons.info_outline_rounded,
          title: 'About SEMS',
          subtitle: 'Smart Energy Monitoring System',
          onTap: () => showAboutDialog(
            context: context,
            applicationName: 'SEMS',
            applicationVersion: '1.0.0',
            applicationLegalese: 'Frontend preview',
          ),
        ),
      ],
    ),
  );
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    leading: Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: SemsColors.mint,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: SemsColors.forest, size: 20),
    ),
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    ),
    subtitle: subtitle == null
        ? null
        : Text(
            subtitle!,
            style: const TextStyle(fontSize: 11, color: SemsColors.muted),
          ),
    trailing: const Icon(Icons.chevron_right_rounded, color: SemsColors.muted),
    onTap: onTap,
  );
}
