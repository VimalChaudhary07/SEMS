// Implements Figma shared-component light-theme golden coverage.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sems/core/theme/app_theme.dart';
import 'package:sems/shared/widgets/alert_card.dart';
import 'package:sems/shared/widgets/appliance_icon.dart';
import 'package:sems/shared/widgets/app_banner.dart';
import 'package:sems/shared/widgets/app_bottom_nav.dart';
import 'package:sems/shared/widgets/app_bottom_sheet.dart';
import 'package:sems/shared/widgets/app_button.dart';
import 'package:sems/shared/widgets/app_card.dart';
import 'package:sems/shared/widgets/app_checkbox.dart';
import 'package:sems/shared/widgets/app_chip.dart';
import 'package:sems/shared/widgets/app_dialog.dart';
import 'package:sems/shared/widgets/app_progress_bar.dart';
import 'package:sems/shared/widgets/app_radio_card.dart';
import 'package:sems/shared/widgets/app_row.dart';
import 'package:sems/shared/widgets/app_segmented.dart';
import 'package:sems/shared/widgets/app_text_field.dart';
import 'package:sems/shared/widgets/app_toast.dart';
import 'package:sems/shared/widgets/app_toggle.dart';
import 'package:sems/shared/widgets/app_top_bar.dart';
import 'package:sems/shared/widgets/empty_state.dart';
import 'package:sems/shared/widgets/energy_charts.dart';
import 'package:sems/shared/widgets/error_state.dart';
import 'package:sems/shared/widgets/estimated_badge.dart';
import 'package:sems/shared/widgets/insight_card.dart';
import 'package:sems/shared/widgets/load_bars.dart';
import 'package:sems/shared/widgets/metric_tile.dart';
import 'package:sems/shared/widgets/permission_gate.dart';
import 'package:sems/shared/widgets/power_control.dart';
import 'package:sems/shared/widgets/qr_scanner_view.dart';
import 'package:sems/shared/widgets/role_badge.dart';
import 'package:sems/shared/widgets/section_header.dart';
import 'package:sems/shared/widgets/settings_group.dart';
import 'package:sems/shared/widgets/signal_bars.dart';
import 'package:sems/shared/widgets/status_badge.dart';
import 'package:sems/shared/widgets/step_bar.dart';

typedef _Golden = ({String name, Widget child});

void main() {
  final goldens = <_Golden>[
    (
      name: 'app_button',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (label, variant) in [
            ('Primary', AppButtonVariant.primary),
            ('Secondary', AppButtonVariant.secondary),
            ('Tonal', AppButtonVariant.tonal),
            ('Danger', AppButtonVariant.danger),
            ('Text', AppButtonVariant.text),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppButton(
                label: label,
                variant: variant,
                onPressed: () {},
                leadingIcon: Icons.bolt,
              ),
            ),
          const AppButton(
            label: 'Small disabled',
            size: AppButtonSize.small,
            onPressed: null,
          ),
        ],
      ),
    ),
    (
      name: 'app_chip',
      child: AppChipRow(
        children: const [
          AppChip(label: 'All', selected: true, count: 3),
          AppChip(label: 'Kitchen', selected: false, icon: Icons.kitchen),
          AppChip(label: 'Room', selected: false),
        ],
      ),
    ),
    (
      name: 'app_segmented',
      child: AppSegmented<String>(
        values: const ['Sign in', 'Sign up'],
        selected: 'Sign in',
        labelFor: (value) => value,
        onChanged: _ignoreString,
      ),
    ),
    (
      name: 'app_toggle',
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AppToggle(value: true, onChanged: null, semanticLabel: 'Enabled'),
          AppToggle(value: false, onChanged: null, semanticLabel: 'Disabled'),
        ],
      ),
    ),
    (
      name: 'app_checkbox',
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppCheckbox(value: true, onChanged: null, label: 'Selected'),
          AppCheckbox(value: false, onChanged: null, label: 'Not selected'),
        ],
      ),
    ),
    (
      name: 'app_radio_card',
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppRadioCard<String>(
            value: 'wifi',
            groupValue: 'wifi',
            onChanged: _ignoreString,
            title: 'Wi-Fi',
            subtitle: 'Connected network',
            leading: Icon(Icons.wifi),
          ),
          SizedBox(height: 8),
          AppRadioCard<String>(
            value: 'other',
            groupValue: 'wifi',
            onChanged: _ignoreString,
            title: 'Other network',
          ),
        ],
      ),
    ),
    (
      name: 'app_text_field',
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(label: 'Email', hint: 'name@example.com'),
          SizedBox(height: 12),
          AppTextField(
            label: 'Power limit',
            hint: 'Enter watts',
            unitSuffix: 'W',
            errorText: 'Value is above the safe limit',
          ),
          SizedBox(height: 12),
          AppTextField(
            label: 'Password',
            hint: 'Enter password',
            obscureText: true,
          ),
          SizedBox(height: 12),
          AppTextField(label: 'Disabled', enabled: false),
        ],
      ),
    ),
    (
      name: 'status_badge',
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final tone in StatusTone.values)
            StatusBadge(label: tone.name.toUpperCase(), tone: tone),
        ],
      ),
    ),
    (
      name: 'role_badge',
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [RoleBadge(isFamily: false), RoleBadge(isFamily: true)],
      ),
    ),
    (
      name: 'app_banner',
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBanner(
            tone: StatusTone.ok,
            title: 'Connected',
            body: 'Last synced just now.',
          ),
          SizedBox(height: 8),
          AppBanner(
            tone: StatusTone.warn,
            title: 'Safety warning',
            actionText: 'Review',
            onAction: _ignore,
          ),
          SizedBox(height: 8),
          AppBanner(
            tone: StatusTone.fault,
            title: 'Connection failed',
            body: 'Check the device and retry.',
          ),
          SizedBox(height: 8),
          AppBanner(tone: StatusTone.off, title: 'Socket offline'),
          SizedBox(height: 8),
          AppBanner(tone: StatusTone.pend, title: 'Pending'),
          SizedBox(height: 8),
          AppBanner(tone: StatusTone.ai, title: 'Estimated insight'),
        ],
      ),
    ),
    (
      name: 'app_card',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppCard(child: Text('Standard card with a subtle border.')),
          const SizedBox(height: 10),
          AppCard(
            accentColor: Color(0xFF0E9F6E),
            child: const Text('Accent card for alerts and insights.'),
          ),
        ],
      ),
    ),
    (
      name: 'app_row',
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppRow(
            title: 'Profile',
            subtitle: 'Manage your profile',
            icon: Icons.person_outline,
            showChevron: true,
            onTap: _ignore,
          ),
          Divider(height: 1),
          AppRow(title: 'Family member', trailing: Text('Owner')),
          Divider(height: 1),
          AppRow(
            title: 'Remove device',
            icon: Icons.delete_outline,
            danger: true,
          ),
          Divider(height: 1),
          AppRow(title: 'Unavailable action', dimmed: true),
        ],
      ),
    ),
    (
      name: 'settings_group',
      child: SettingsGroup(
        title: 'Account',
        children: const [
          AppRow(
            title: 'Profile',
            subtitle: 'Asha Verma',
            icon: Icons.person_outline,
            showChevron: true,
          ),
          AppRow(
            title: 'Notifications',
            icon: Icons.notifications_outlined,
            trailing: Icon(Icons.chevron_right),
          ),
          AppRow(title: 'Sign out', icon: Icons.logout, danger: true),
        ],
      ),
    ),
    (
      name: 'section_header',
      child: const SectionHeader(title: 'Appliances', actionLabel: 'See all'),
    ),
    (
      name: 'metric_tile',
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MetricTile(label: 'Measured today', value: '4.9', unit: 'kWh'),
          SizedBox(height: 8),
          MetricTile(
            label: 'Bill so far',
            value: '₹1,292',
            kind: MetricKind.estimated,
          ),
          SizedBox(height: 8),
          MetricTile(
            label: 'Last bill',
            value: '₹1,860',
            kind: MetricKind.billed,
          ),
        ],
      ),
    ),
    (name: 'estimated_badge', child: const EstimatedBadge()),
    (
      name: 'app_progress_bar',
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppProgressBar(value: .72, tone: 'brand'),
          SizedBox(height: 10),
          AppProgressBar(value: .45, tone: 'warn'),
          SizedBox(height: 10),
          AppProgressBar(value: .2, tone: 'fault'),
        ],
      ),
    ),
    (
      name: 'signal_bars',
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SignalBars(level: 0),
          SignalBars(level: 1),
          SignalBars(level: 2),
          SignalBars(level: 3),
          SignalBars(level: 4),
        ],
      ),
    ),
    (
      name: 'appliance_icon',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final category in ApplianceCategory.values)
            ApplianceIcon(
              category: category,
              online: category != ApplianceCategory.refrigerator,
            ),
        ],
      ),
    ),
    (
      name: 'app_top_bar',
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTopBar(title: 'Devices', subtitle: 'Manage your sockets'),
          AppTopBar(title: 'Dashboard', isFamily: false),
          AppTopBar(title: 'Settings', isFamily: true),
        ],
      ),
    ),
    (
      name: 'app_bottom_nav',
      child: AppBottomNav(selectedIndex: 0, onDestinationSelected: _ignoreInt),
    ),
    (
      name: 'app_bottom_sheet',
      child: const AppBottomSheet(
        title: 'Set a timer',
        onClose: _ignore,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text('Choose when this socket should turn off.'),
        ),
      ),
    ),
    (
      name: 'app_dialog',
      child: AppDialog(
        title: 'Remove socket?',
        body: 'This action cannot be undone.',
        confirmText: 'Remove',
        danger: true,
        onConfirm: _ignore,
      ),
    ),
    (name: 'app_toast', child: const _ToastPreview()),
    (
      name: 'empty_state',
      child: const EmptyState(
        title: 'No sockets yet',
        message: 'Add a socket to start monitoring energy.',
        icon: Icons.power_outlined,
        actionLabel: 'Add socket',
        onAction: _ignore,
      ),
    ),
    (
      name: 'error_state',
      child: const ErrorState(
        title: 'Could not load devices',
        message: 'Check your connection and try again.',
        primaryLabel: 'Retry',
        secondaryLabel: 'Go back',
      ),
    ),
    (
      name: 'step_bar',
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StepBar(steps: 7, currentStep: 3),
          SizedBox(height: 16),
          StepBar(steps: 4, currentStep: 4),
          SizedBox(height: 16),
          StepBar(steps: 3, currentStep: 1),
        ],
      ),
    ),
    (
      name: 'power_control',
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 6,
        runSpacing: 8,
        children: [
          for (final state in PowerControlState.values)
            PowerControl(state: state, onPressed: _ignore, size: 112),
        ],
      ),
    ),
    (
      name: 'load_bars',
      child: LoadBars(
        values: List.generate(24, (index) => (index % 7 + 1) * 100.0),
        currentHour: 14,
      ),
    ),
    (
      name: 'energy_bar_chart',
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EnergyBarChart(
            values: [1, 3, 2, null, 5, 4, 2],
            labels: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
          ),
          SizedBox(height: 8),
          EnergyBarChart(values: [1, 2, null, 4, 2], dataGap: true),
        ],
      ),
    ),
    (
      name: 'energy_area_chart',
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EnergyAreaChart(
            values: [1, 2, 2.5, null, 3, 3.5, 4, 4.5],
            forecastStart: 5,
            lowerForecast: [2.8, 3, 3.2],
            upperForecast: [3.4, 3.8, 4.2],
          ),
          SizedBox(height: 8),
          EnergyAreaChart(values: [1, 2, null, 4], dataGap: true),
        ],
      ),
    ),
    (
      name: 'alert_card',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AlertCard(
            title: 'Power limit exceeded',
            time: '2 min ago',
            device: 'Living room · SEMS-000001',
            severity: StatusTone.warn,
            cause: 'Measured power exceeded the configured limit.',
            nextStep: 'Check the appliance load.',
            onAcknowledge: _ignore,
          ),
          const SizedBox(height: 8),
          const AlertCard(
            title: 'Socket acknowledged',
            time: 'Yesterday',
            device: 'Bedroom · SEMS-000002',
            severity: StatusTone.ok,
            acknowledged: true,
          ),
        ],
      ),
    ),
    (
      name: 'insight_card',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final severity in InsightSeverity.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InsightCard(
                title: 'Energy use changed this week',
                body: 'Evening use differs from its recent baseline.',
                severity: severity,
              ),
            ),
        ],
      ),
    ),
    (name: 'qr_scanner_view', child: QrScannerView(onMockScan: _ignore)),
    (
      name: 'permission_gate',
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PermissionGate(
            allowed: false,
            presentation: PermissionPresentation.hidden,
            child: Text('Hidden owner action'),
          ),
          PermissionGate(
            allowed: false,
            presentation: PermissionPresentation.dimmed,
            child: Text('Move to another socket'),
          ),
          PermissionGate(
            allowed: false,
            presentation: PermissionPresentation.readOnly,
            child: Text('Read-only safety limits'),
          ),
          PermissionGate(
            allowed: false,
            presentation: PermissionPresentation.locked,
            explanation: 'Only the Owner can add appliances.',
            child: Text('Add appliance'),
          ),
        ],
      ),
    ),
  ];

  for (final (themeName, theme) in [
    ('light', AppTheme.light),
    ('dark', AppTheme.dark),
  ]) {
    for (final golden in goldens) {
      final goldenName = '${themeName}_${golden.name}';
      testWidgets('$goldenName golden', (tester) async {
        await tester.binding.setSurfaceSize(const Size(390, 900));
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    key: ValueKey('golden-$goldenName'),
                    width: 366,
                    child: golden.child,
                  ),
                ),
              ),
            ),
          ),
        );
        if (golden.name == 'power_control') {
          await tester.pump(const Duration(milliseconds: 500));
        } else {
          await tester.pumpAndSettle();
        }
        await expectLater(
          find.byKey(ValueKey('golden-$goldenName')),
          matchesGoldenFile('shared_components/$goldenName.png'),
        );
        await tester.binding.setSurfaceSize(null);
      });
    }
  }
}

void _ignore() {}
void _ignoreInt(int _) {}
void _ignoreString(String _) {}

class _ToastPreview extends StatefulWidget {
  const _ToastPreview();

  @override
  State<_ToastPreview> createState() => _ToastPreviewState();
}

class _ToastPreviewState extends State<_ToastPreview> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) AppToast.show(context, 'Changes saved');
    });
  }

  @override
  Widget build(BuildContext context) =>
      const SizedBox(height: 64, child: Center(child: Text('Toast preview')));
}
