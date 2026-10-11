import 'package:flutter/material.dart';

import '../../core/session/demo_session.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/sems_widgets.dart';

class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({super.key});
  @override
  State<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  bool connected = false, backupExists = false, verified = false, busy = false;
  String? error;
  int restoreStep = -1;
  static const restoreSteps = [
    'Find backup',
    'Validate backup',
    'Review restore',
    'Restore data',
    'Done',
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Backup and restore')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const PageHeading(
          title: 'Your data, your choice',
          subtitle: 'Local backup preview',
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Row(
            children: [
              Icon(
                connected
                    ? Icons.cloud_done_outlined
                    : Icons.cloud_off_outlined,
                color: SemsColors.forest,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      connected
                          ? 'Drive connected · demo account'
                          : 'Drive not connected',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      connected
                          ? 'Example account · preview only'
                          : 'No cloud service is contacted',
                      style: const TextStyle(
                        color: SemsColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: DemoSession.isMember ? null : _connect,
                child: Text(connected ? 'Manage' : 'Connect'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Backup status',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                busy
                    ? 'Preparing a local preview…'
                    : backupExists
                    ? 'Last backup · just now'
                    : 'No backup created yet',
                style: const TextStyle(color: SemsColors.muted, fontSize: 12),
              ),
              if (busy)
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: LinearProgressIndicator(),
                ),
              if (backupExists) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      verified
                          ? Icons.verified_outlined
                          : Icons.info_outline_rounded,
                      size: 17,
                      color: verified ? SemsColors.green : SemsColors.amber,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      verified ? 'Backup verified' : 'Not verified yet',
                      style: const TextStyle(
                        fontSize: 11,
                        color: SemsColors.muted,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        FilledButton.icon(
          onPressed: busy || DemoSession.isMember ? null : _backup,
          icon: const Icon(Icons.backup_outlined),
          label: Text(connected ? 'Back up now' : 'Create local demo backup'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: !backupExists || busy || DemoSession.isMember
              ? null
              : _verify,
          icon: const Icon(Icons.fact_check_outlined),
          label: const Text('Verify backup'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: busy || DemoSession.isMember ? null : _startRestore,
          icon: const Icon(Icons.restore_rounded),
          label: const Text('Restore from backup'),
        ),
        if (error != null) ...[
          const SizedBox(height: 12),
          _ErrorBanner(
            title: error!,
            onRetry: () => setState(() {
              error = null;
              restoreStep = -1;
            }),
          ),
        ],
        if (restoreStep >= 0) ...[
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restoreSteps[restoreStep],
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (restoreStep + 1) / restoreSteps.length,
                  minHeight: 5,
                  borderRadius: BorderRadius.circular(5),
                ),
                const SizedBox(height: 10),
                Text(
                  _restoreDescription(),
                  style: const TextStyle(
                    color: SemsColors.muted,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _advanceRestore,
                  child: Text(
                    restoreStep == restoreSteps.length - 1
                        ? 'Done'
                        : restoreStep == 2
                        ? 'Review and continue'
                        : 'Continue',
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 14),
        TextButton.icon(
          onPressed: _previewErrors,
          icon: const Icon(Icons.bug_report_outlined, size: 17),
          label: const Text('Preview restore error states'),
        ),
        const SizedBox(height: 6),
        const AppCard(
          child: Text(
            'This screen simulates Google Drive backup/restore states. No Google account, backup file, or cloud operation is used.',
            style: TextStyle(
              color: SemsColors.muted,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );

  String _restoreDescription() => switch (restoreStep) {
    0 => 'Looking for the most recent sample backup.',
    1 => 'Checking the sample backup format and checksum.',
    2 => 'Review the sample data that would be restored.',
    3 => 'Restoring sample preferences in this screen only.',
    _ => 'Restore preview finished. No device or cloud data was changed.',
  };

  Future<void> _connect() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connect Google Drive?'),
        content: const Text(
          'This preview will simulate a connection. It will not open Google sign-in or access Drive.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Continue with demo'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) setState(() => connected = !connected);
  }

  Future<void> _backup() async {
    final include = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) => _ManualBackupSheet(),
    );
    if (include != true || !mounted) return;
    setState(() {
      busy = true;
      error = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() {
      busy = false;
      backupExists = true;
      verified = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sample backup prepared for this preview.')),
    );
  }

  Future<void> _verify() async {
    setState(() => busy = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() {
      busy = false;
      verified = true;
    });
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => const SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_rounded, color: SemsColors.green, size: 42),
              SizedBox(height: 10),
              Text(
                'Backup verified',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 6),
              Text(
                'This sample backup passed the local preview check.',
                textAlign: TextAlign.center,
                style: TextStyle(color: SemsColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startRestore() {
    setState(() {
      if (!backupExists) {
        error = 'No backup found';
      } else {
        error = null;
        restoreStep = 0;
      }
    });
  }

  void _advanceRestore() {
    if (restoreStep == restoreSteps.length - 1) {
      setState(() => restoreStep = -1);
      return;
    }
    if (restoreStep == 1 && !verified) {
      setState(() => error = 'Verify the backup before restoring it.');
      return;
    }
    setState(() => restoreStep++);
  }

  Future<void> _previewErrors() async {
    const errors = [
      'No backup found',
      'Schema mismatch',
      'Checksum failed',
      'Google account unavailable',
    ];
    final result = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            const ListTile(title: Text('Choose a restore error state')),
            for (final value in errors)
              ListTile(
                title: Text(value),
                onTap: () => Navigator.pop(context, value),
              ),
          ],
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        error = result;
        restoreStep = -1;
      });
    }
  }
}

class _ManualBackupSheet extends StatefulWidget {
  @override
  State<_ManualBackupSheet> createState() => _ManualBackupSheetState();
}

class _ManualBackupSheetState extends State<_ManualBackupSheet> {
  bool settings = true, schedules = true, history = true;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Manual backup',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          SwitchListTile(
            title: const Text('Settings and preferences'),
            value: settings,
            onChanged: (v) => setState(() => settings = v),
          ),
          SwitchListTile(
            title: const Text('Schedules'),
            value: schedules,
            onChanged: (v) => setState(() => schedules = v),
          ),
          SwitchListTile(
            title: const Text('Energy history'),
            value: history,
            onChanged: (v) => setState(() => history = v),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, settings || schedules || history),
            child: const Text('Create backup'),
          ),
        ],
      ),
    ),
  );
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.title, required this.onRetry});
  final String title;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => AppCard(
    child: Row(
      children: [
        const Icon(Icons.error_outline_rounded, color: SemsColors.red),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        TextButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    ),
  );
}
