import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sems/core/session/demo_session.dart';
import 'package:sems/core/theme/app_theme.dart';
import 'package:sems/data/repositories/sems_repository.dart';
import 'package:sems/domain/models/schedule_record.dart';
import 'package:sems/features/views/schedules_screen.dart';

Future<void> loadAppFonts() async {
  final interLoader = FontLoader('Inter');
  interLoader.addFont(
    File('assets/fonts/Inter-Variable.ttf')
        .readAsBytes()
        .then((b) => ByteData.sublistView(b)),
  );
  await interLoader.load();

  final monoLoader = FontLoader('JetBrains Mono');
  monoLoader.addFont(
    File('assets/fonts/JetBrainsMono-Variable.ttf')
        .readAsBytes()
        .then((b) => ByteData.sublistView(b)),
  );
  await monoLoader.load();

  final iconsLoader = FontLoader('MaterialIcons');
  iconsLoader.addFont(
    File(
      r'D:\flutter_env\flutter\bin\cache\artifacts\material_fonts\materialicons-regular.otf',
    ).readAsBytes().then((b) => ByteData.sublistView(b)),
  );
  await iconsLoader.load();
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testWidgets('schedule_delete_dialog_screen_golden', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    DemoSession.role.value = DemoRole.owner;

    final repository = MockSemsRepository();
    final schedules = await repository.getSchedules();

    const existing = ScheduleRecord(
      id: 'schedule-evening-heater',
      name: 'Evening heater',
      applianceId: 'heater',
      socketId: 'SEMS-000001',
      startTime: '18:00',
      endTime: '22:00',
      days: ['monday', 'tuesday', 'wednesday', 'thursday', 'friday'],
      kind: 'weekly',
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: SizedBox(
          width: 390,
          height: 844,
          child: ScheduleEditorScreen(
            repository: repository,
            schedules: schedules,
            existing: existing,
            showDeleteDialogOnStart: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
        'screens/schedule_delete_dialog_screen_updated.png',
      ),
    );

    await tester.binding.setSurfaceSize(null);
  });
}
