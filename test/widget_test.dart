// Implements Figma Auth flow navigation and existing screen widget coverage.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sems/app.dart';
import 'package:sems/core/session/demo_session.dart';
import 'package:sems/core/theme/app_theme.dart';
import 'package:sems/data/repositories/sems_repository.dart';
import 'package:sems/domain/models/schedule_record.dart';
import 'package:sems/features/views/dashboard_screen.dart';
import 'package:sems/features/views/analytics_screen.dart';
import 'package:sems/features/views/alerts_screen.dart';
import 'package:sems/features/views/more_home_screen.dart';
import 'package:sems/features/views/safety_limits_screen.dart';
import 'package:sems/features/views/schedules_screen.dart';

Future<void> enterDemo(WidgetTester tester) async {
  DemoSession.role.value = DemoRole.owner;
  await tester.pumpWidget(SemsApp(repository: MockSemsRepository()));
  await tester.pump(const Duration(milliseconds: 1800));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Skip'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Continue with Google'));
  for (
    var attempt = 0;
    attempt < 50 && find.text('Good evening, Asha').evaluate().isEmpty;
    attempt++
  ) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(find.text('Good evening, Asha'), findsOneWidget);
}

void main() {
  testWidgets('launch displays the designed splash before onboarding', (
    tester,
  ) async {
    await tester.pumpWidget(const SemsApp());
    expect(find.text('SEMS'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pumpAndSettle();
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets('sign up routes to verification with the entered email', (
    tester,
  ) async {
    await tester.pumpWidget(const SemsApp());
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Demo User');
    await tester.enterText(find.byType(TextFormField).at(1), 'demo@sems.app');
    await tester.enterText(find.byType(TextFormField).at(2), 'sems-demo');
    await tester.ensureVisible(find.text('Create account'));
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.textContaining('demo@sems.app'), findsOneWidget);
    expect(find.text('Verify your email'), findsOneWidget);
  });

  testWidgets('dashboard shows its empty socket state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: DashboardScreen(repository: MockSemsRepository(empty: true)),
        ),
      ),
    );
    expect(find.text('No sockets yet'), findsOneWidget);
    expect(find.text('Add socket'), findsOneWidget);
  });

  testWidgets('history range and chart inspection update from local readings', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(body: AnalyticsScreen(repository: MockSemsRepository())),
      ),
    );
    expect(find.text('Last 24 hours, energy per hour'), findsOneWidget);
    await tester.tap(find.text('Week'));
    await tester.pumpAndSettle();
    expect(find.text('Last 7 days, energy per day'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('history-bar-0')));
    await tester.pumpAndSettle();
    expect(find.text('M · 4.10 kWh'), findsOneWidget);
  });

  testWidgets('history shows its designed empty state without sockets', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: AnalyticsScreen(repository: MockSemsRepository(empty: true)),
        ),
      ),
    );
    expect(find.text('No history yet'), findsOneWidget);
    expect(
      find.text('Usage appears here after your first socket starts reporting.'),
      findsOneWidget,
    );
  });

  testWidgets('alert categories and preferences use local repository state', (
    tester,
  ) async {
    final repository = MockSemsRepository();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: AlertsScreen(repository: repository),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('3 need attention'), findsOneWidget);
    expect(find.text('Possible abnormal behaviour'), findsNothing);
    await tester.ensureVisible(find.text('AI'));
    await tester.tap(find.text('AI'));
    await tester.pumpAndSettle();
    expect(find.text('Possible abnormal behaviour'), findsOneWidget);
    expect(
      find.text('Estimated, calculated on your phone'),
      findsOneWidget,
    );
    await tester.tap(find.byTooltip('Alert settings'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, '3500');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect((await repository.getAlertPreferences()).overallPowerLimitW, 3500);
  });

  testWidgets('dashboard shows learning progress for new installations', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: DashboardScreen(
            repository: MockSemsRepository(coverageDays: 2),
          ),
        ),
      ),
    );
    expect(find.text('Learning your usage pattern'), findsOneWidget);
    expect(find.text('5 more days of data recommended'), findsOneWidget);
    expect(find.text('2 of 7 days'), findsOneWidget);
  });

  testWidgets('safety limits validate current, power, and voltage fields', (
    tester,
  ) async {
    final device = MockSemsRepository().devices.first;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: SafetyLimitsScreen(device: device),
      ),
    );
    expect(find.text('Max current'), findsOneWidget);
    expect(find.text('Max power'), findsOneWidget);
    expect(find.text('Min voltage'), findsOneWidget);
    expect(find.text('Max voltage'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(1), '5000');
    await tester.tap(find.text('Save limits'));
    await tester.pumpAndSettle();
    expect(find.text('Enter 1 to 3680 W'), findsOneWidget);
  });

  testWidgets('safety limits save to the supplied local repository', (
    tester,
  ) async {
    final repository = MockSemsRepository();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: SafetyLimitsScreen(
          device: repository.devices.first,
          repository: repository,
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), '12');
    await tester.tap(find.text('Save limits'));
    await tester.pumpAndSettle();

    expect(repository.devices.first.safetyLimits.maxCurrentA, 12);
    expect(find.text('Safety limits saved for this socket.'), findsOneWidget);
  });

  testWidgets('bottom navigation switches between app sections', (
    tester,
  ) async {
    await enterDemo(tester);
    expect(find.text('Good evening, Asha'), findsOneWidget);
    await tester.tap(find.text('Devices'));
    await tester.pumpAndSettle();
    expect(find.text('Devices').first, findsOneWidget);
    expect(find.text('3 sockets'), findsOneWidget);
    await tester.tap(find.text('History').last);
    await tester.pumpAndSettle();
    expect(find.text('History'), findsNWidgets(2));
  });

  testWidgets('device details show live readings and local manage actions', (
    tester,
  ) async {
    await enterDemo(tester);
    await tester.tap(find.text('Devices'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Living room socket'));
    await tester.pumpAndSettle();
    expect(find.text('LIVE READINGS'), findsOneWidget);
    expect(find.text('Voltage'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('DIAGNOSTICS'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('DIAGNOSTICS'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('MANAGE'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('MANAGE'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Rename socket'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Rename socket'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Office heater');
    await tester.tap(find.text('Save name'));
    await tester.pumpAndSettle();
    expect(find.text('Office heater'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Assign room'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Assign room'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Study'),
      150,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Study'));
    await tester.pumpAndSettle();
    expect(find.text('Study'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Remove device'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Remove device'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove device').last);
    await tester.pumpAndSettle();
    expect(find.text('2 sockets'), findsOneWidget);
  });

  testWidgets('device details are reachable from a device name', (
    tester,
  ) async {
    await enterDemo(tester);
    await tester.tap(find.text('Devices'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Living room socket'));
    await tester.pumpAndSettle();
    expect(find.text('SEMS-000001'), findsAtLeastNWidgets(1));
    expect(find.text('Voltage'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Safety limits'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Safety limits'), findsOneWidget);
  });

  testWidgets(
    'socket control animates through pending, acknowledgement, and OFF',
    (tester) async {
      await enterDemo(tester);
      await tester.tap(find.text('Devices'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Living room socket'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remote control'));
      await tester.pumpAndSettle();
      final onPowerButton = find.byWidgetPredicate(
        (widget) =>
            widget is AnimatedContainer &&
            widget.constraints?.maxWidth == 148 &&
            (widget.decoration as BoxDecoration?)?.color == SemsColors.forest,
      );
      expect(onPowerButton, findsOneWidget);
      await tester.tap(find.byTooltip('Turn off Heater'));
      await tester.pumpAndSettle();
      expect(find.text('Socket confirmed OFF'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is AnimatedContainer &&
              widget.constraints?.maxWidth == 148 &&
              (widget.decoration as BoxDecoration?)?.color ==
                  const Color(0xFFEAF1EE),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'appliance creation and archiving persist without adding sockets',
    (tester) async {
      DemoSession.role.value = DemoRole.owner;
      final repository = MockSemsRepository();
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: AppliancesScreen(repository: repository),
        ),
      );

      await tester.tap(find.byTooltip('Add appliance'));
      await tester.pumpAndSettle();
      expect(find.text('CATEGORY'), findsOneWidget);
      expect(find.text('Create appliance'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField).first, 'Desk heater');
      await tester.ensureVisible(find.text('Create appliance'));
      await tester.tap(find.text('Create appliance'));
      await tester.pumpAndSettle();

      expect(repository.devices, hasLength(3));
      expect(
        repository.appliances.any((item) => item.name == 'Desk heater'),
        isTrue,
      );
      expect(
        repository.devices
            .firstWhere((device) => device.id == 'SEMS-000001')
            .appliance,
        'Desk heater',
      );

      await tester.tap(find.text('Desk heater').first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(PopupMenuButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Archive appliance'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Archive').last);
      await tester.pumpAndSettle();

      expect(
        repository.appliances
            .singleWhere((item) => item.name == 'Desk heater')
            .status,
        'archived',
      );
      expect(repository.devices, hasLength(3));
      expect(
        repository.devices
            .firstWhere((device) => device.id == 'SEMS-000001')
            .appliance,
        'Unassigned',
      );
    },
  );

  testWidgets('More exposes appliance, schedule, and billing pages', (
    tester,
  ) async {
    await enterDemo(tester);
    await tester.tap(find.text('More').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Appliances').last);
    await tester.pumpAndSettle();
    expect(find.text('ACTIVE'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Scheduling'));
    await tester.pumpAndSettle();
    expect(find.text('Timers & schedules'), findsOneWidget);
  });

  testWidgets('schedule editor supports multiple time intervals', (
    tester,
  ) async {
    await enterDemo(tester);
    await tester.tap(find.text('More').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Scheduling'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add schedule'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).last,
      'Morning and evening',
    );
    await tester.tap(find.text('Multiple intervals').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<String>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Fan ·').last);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).last, const Offset(0, -360));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add interval'));
    await tester.pumpAndSettle();
    expect(find.text('12:00'), findsOneWidget);
    expect(find.text('Save schedule'), findsOneWidget);
    await tester.ensureVisible(find.text('Save schedule'));
    await tester.tap(find.text('Save schedule'));
    await tester.pumpAndSettle();
    expect(find.text('Morning and evening'), findsOneWidget);
  });

  testWidgets('schedule pause sheet offers a timed holiday pause', (
    tester,
  ) async {
    await enterDemo(tester);
    await tester.tap(find.text('More').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Scheduling'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).last, const Offset(0, -900));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pause all (holiday)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('For 3 days'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Schedules paused until'), findsOneWidget);
    await tester.ensureVisible(find.text('Resume now'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Resume now'));
    await tester.pumpAndSettle();
    expect(find.text('Pause all (holiday)'), findsOneWidget);
  });

  testWidgets('schedule editor warns while its socket clock is unsynced', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: SchedulesScreen(repository: _UnsyncedScheduleRepository()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add schedule'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Waiting for time sync'), findsOneWidget);
  });

  testWidgets('expired countdown turns its socket off through the local repo', (
    tester,
  ) async {
    final repository = _ExpiredCountdownRepository();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: SchedulesScreen(repository: repository),
      ),
    );
    await tester.pumpAndSettle();
    expect(repository.schedule.countdownState, 'completed');
    expect(repository.devices.first.isOn, isFalse);
    expect(find.text('Countdown complete · socket is off'), findsOneWidget);
  });

  testWidgets('settings presents sign-out confirmation without leaving', (
    tester,
  ) async {
    await enterDemo(tester);
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Sign out'), 300);
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(find.text('Sign out?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Sign out'), 300);
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out').last);
    await tester.pumpAndSettle();
    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('socket setup can scan, validate Wi-Fi, and add a demo socket', (
    tester,
  ) async {
    await enterDemo(tester);
    await tester.tap(find.text('Devices'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add socket'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Scan sample QR'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes, continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'DemoNet');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('The screen shows "Pairing"'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2200));
    await tester.pumpAndSettle();
    expect(find.text('Name your socket'), findsOneWidget);
    await tester.tap(find.text('Add to my devices'));
    await tester.pumpAndSettle();
    expect(find.text('Your socket is ready'), findsOneWidget);
    await tester.tap(find.text('Done').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'New smart plug');
    await tester.pumpAndSettle();
    expect(find.text('New smart plug').last, findsOneWidget);
  });

  testWidgets('alerts can be filtered and acknowledged', (tester) async {
    await enterDemo(tester);
    await tester.tap(find.text('Alerts').last);
    await tester.pumpAndSettle();
    expect(find.text('Over-current at SEMS-000001'), findsOneWidget);
    await tester.tap(find.text('Acknowledge').first);
    await tester.pumpAndSettle();
    expect(find.text('Acknowledged'), findsOneWidget);
    await tester.ensureVisible(find.text('Electrical'));
    await tester.tap(find.text('Electrical'));
    await tester.pumpAndSettle();
    expect(find.text('Over-current at SEMS-000001'), findsOneWidget);
    expect(find.text('Monthly budget 80% used'), findsNothing);
  });
}

class _UnsyncedScheduleRepository extends MockSemsRepository {
  @override
  Future<bool> isScheduleClockSynced(String applianceId) async => false;
}

class _ExpiredCountdownRepository extends MockSemsRepository {
  ScheduleRecord schedule = const ScheduleRecord(
    id: 'expired-countdown',
    name: 'Auto off',
    applianceId: 'heater',
    socketId: 'SEMS-000001',
    startTime: '00:00',
    endTime: '00:00',
    countdownMinutes: 30,
    countdownEndsAt: '2000-01-01T00:00:00.000',
    countdownState: 'running',
    kind: 'countdown',
  );

  @override
  Future<List<ScheduleRecord>> getSchedules() async => [schedule];

  @override
  Future<void> saveSchedule(ScheduleRecord value) async {
    schedule = value;
  }
}
