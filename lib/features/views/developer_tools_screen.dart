import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/sems_widgets.dart';

class DeveloperToolsScreen extends StatefulWidget {
  const DeveloperToolsScreen({super.key});
  @override
  State<DeveloperToolsScreen> createState() => _DeveloperToolsScreenState();
}

class _DeveloperToolsScreenState extends State<DeveloperToolsScreen> {
  bool unlocked = false;
  final code = TextEditingController();
  final List<(String, String)> identities = [
    ('SEMS-000001', 'Living room heater'),
    ('SEMS-000002', 'Bedroom fan'),
  ];
  int nextId = 3;
  @override
  void dispose() {
    code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Developer mode')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (!unlocked) ...[
          const PageHeading(
            title: 'Developer tools',
            subtitle: 'Local socket identity demo',
          ),
          const SizedBox(height: 16),
          const AppCard(
            child: Text(
              'Developer mode is hidden in the product flow. This frontend preview uses a demo unlock and stores no credentials.',
              style: TextStyle(
                color: SemsColors.muted,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: code,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Demo access code',
              helperText: 'Enter DEMO to continue',
            ),
          ),
          const SizedBox(height: 14),
          FilledButton(
            onPressed: () {
              if (code.text.trim() == 'DEMO') {
                setState(() => unlocked = true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Use DEMO for this local preview.'),
                  ),
                );
              }
            },
            child: const Text('Unlock developer tools'),
          ),
        ] else ...[
          const PageHeading(
            title: 'Socket identities',
            subtitle: 'Create and revoke sample IDs',
          ),
          const SizedBox(height: 14),
          for (final identity in identities)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: AppCard(
                child: ListTile(
                  onTap: () => _details(identity),
                  leading: const Icon(
                    Icons.memory_rounded,
                    color: SemsColors.forest,
                  ),
                  title: Text(
                    identity.$1,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(identity.$2),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              ),
            ),
          FilledButton.icon(
            onPressed: _create,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create identity'),
          ),
          const SizedBox(height: 12),
          const AppCard(
            child: Text(
              'These identities are fake labels for frontend testing only; they cannot authenticate or connect to SEMS hardware.',
              style: TextStyle(color: SemsColors.muted, fontSize: 12),
            ),
          ),
        ],
      ],
    ),
  );

  Future<void> _create() async {
    final name = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create identity'),
        content: TextField(
          controller: name,
          decoration: const InputDecoration(labelText: 'Identity name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, name.text.trim()),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    name.dispose();
    if (result != null && result.isNotEmpty && mounted) {
      setState(
        () => identities.add((
          'SEMS-${(nextId++).toString().padLeft(6, '0')}',
          result,
        )),
      );
    }
  }

  Future<void> _details((String, String) identity) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            Text(
              identity.$1,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 5),
            Text(identity.$2, style: const TextStyle(color: SemsColors.muted)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.copy_rounded),
              title: const Text('Copy identity'),
              onTap: () => Navigator.pop(context, 'copied'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: const Text('Revoke identity'),
              onTap: () => Navigator.pop(context, 'revoke'),
            ),
          ],
        ),
      ),
    );
    if (action == 'copied' && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Identity copied in the demo preview.')),
      );
    }
    if (action == 'revoke' && mounted) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Revoke identity?'),
          content: const Text(
            'Remove this sample identity from the local list?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Revoke'),
            ),
          ],
        ),
      );
      if (ok == true && mounted) setState(() => identities.remove(identity));
    }
  }
}
