import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/session/demo_session.dart';
import '../../shared/widgets/sems_widgets.dart';
import 'settings_detail_screens.dart';
import 'developer_tools_screen.dart';
import 'backup_restore_screen.dart';
import 'auth_screens.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Settings'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: RoleBadge(isFamily: DemoSession.isMember),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 24),
      children: [
        AppCard(
          child: InkWell(
            onTap: () => _push(context, const AccountSettingsScreen()),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: SemsColors.forest,
                  child: Text(
                    'AV',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Asha Verma',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'owner@sems.app',
                        style: TextStyle(color: SemsColors.muted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                RoleBadge(isFamily: DemoSession.isMember),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _SettingsGroup(
          title: 'ACCOUNT',
          children: [
            _SettingsTile(
              icon: Icons.person_outline,
              title: 'Profile',
              subtitle: 'Name, email, password',
              onTap: () => _push(context, const AccountSettingsScreen()),
            ),
            _SettingsTile(
              icon: Icons.notifications_none,
              title: 'Notifications',
              subtitle: 'Alerts, quiet hours, push',
              onTap: () => _push(context, const NotificationSettingsScreen()),
            ),
            _SettingsTile(
              icon: Icons.group_outlined,
              title: 'Family and permissions',
              subtitle: '2 members',
              onTap: () => _push(context, const FamilySettingsScreen()),
              last: true,
            ),
          ],
        ),
        const SizedBox(height: 13),
        _SettingsGroup(
          title: 'HOME',
          children: [
            _SettingsTile(
              icon: Icons.receipt_long_outlined,
              title: 'Billing and tariff',
              subtitle: 'Budget and estimated bill',
              onTap: () => _push(
                context,
                TariffSettingsScreen(readOnly: DemoSession.isMember),
              ),
            ),
            _SettingsTile(
              icon: Icons.auto_awesome_outlined,
              title: 'AI settings',
              subtitle: 'On-device insights and alerts',
              onTap: () => _push(context, const AiSettingsScreen()),
            ),
            _SettingsTile(
              icon: Icons.cloud_outlined,
              title: 'Backup',
              subtitle: 'Local preview',
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
                  _push(context, const BackupRestoreScreen());
                }
              },
              last: true,
            ),
          ],
        ),
        const SizedBox(height: 13),
        _SettingsGroup(
          title: 'DATA',
          children: [
            _SettingsTile(
              icon: Icons.storage_outlined,
              title: 'Storage and retention',
              subtitle: 'Sample storage use',
              onTap: () => _push(context, const StorageSettingsScreen()),
            ),
            _SettingsTile(
              icon: Icons.shield_outlined,
              title: 'Privacy and data',
              subtitle: 'Export and permissions',
              onTap: () => _push(context, const PrivacySettingsScreen()),
            ),
            _SettingsTile(
              icon: Icons.download_outlined,
              title: 'Export data',
              subtitle: 'CSV, JSON, PDF',
              onTap: () => _push(context, const PrivacySettingsScreen()),
              last: true,
            ),
          ],
        ),
        const SizedBox(height: 13),
        _SettingsGroup(
          title: 'ADVANCED',
          children: [
            _SettingsTile(
              icon: Icons.developer_mode_outlined,
              title: 'Developer tools',
              subtitle: 'Local socket identity preview',
              onTap: () => _push(context, const DeveloperToolsScreen()),
              last: true,
            ),
          ],
        ),
        const SizedBox(height: 13),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              _SettingsTile(
                icon: Icons.logout_rounded,
                title: 'Sign out',
                subtitle: 'Your data stays on this phone',
                onTap: () => _confirmAccountAction(context, deleting: false),
              ),
              if (!DemoSession.isMember)
                _SettingsTile(
                  icon: Icons.delete_outline_rounded,
                  title: 'Delete account',
                  subtitle: 'Remove this account from SEMS',
                  onTap: () => _confirmAccountAction(context, deleting: true),
                  last: true,
                ),
            ],
          ),
        ),
        const SizedBox(height: 13),
        const AppCard(
          child: Text(
            'This frontend preview stores temporary sample data in memory. Account, cloud backup, push messages, and hardware features are not connected.',
            style: TextStyle(
              color: SemsColors.muted,
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ),
      ],
    ),
  );

  static void _push(BuildContext context, Widget page) =>
      Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));

  static Future<void> _confirmAccountAction(
    BuildContext context, {
    required bool deleting,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(deleting ? 'Delete account?' : 'Sign out?'),
        content: Text(
          deleting
              ? 'Your account and access are removed. Local and Drive backups are only deleted if you confirm each one.'
              : 'Your data stays on this phone. Sign in again to control sockets.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          AppButton(
            fullWidth: false,
            variant: deleting
                ? AppButtonVariant.danger
                : AppButtonVariant.primary,
            onPressed: () => Navigator.pop(context, true),
            label: deleting ? 'Delete account' : 'Sign out',
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const SignInScreen()),
      (_) => false,
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.children});
  final String title;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 7),
        child: Text(
          title,
          style: const TextStyle(
            color: SemsColors.muted,
            letterSpacing: 1,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      AppCard(
        padding: EdgeInsets.zero,
        child: Column(children: children),
      ),
    ],
  );
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.last = false,
  });
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  final bool last;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: ComponentTheme.colors(context).brandTint,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 19,
            color: ComponentTheme.colors(context).brandPrimary,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: SemsColors.muted, fontSize: 10),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: SemsColors.muted,
        ),
        minLeadingWidth: 0,
      ),
      if (!last) const Divider(height: 1, indent: 60),
    ],
  );
}
