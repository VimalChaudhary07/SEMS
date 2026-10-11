// Implements the SEMS app root for the Figma product flows.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'app/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/local/mock_database.dart';
import 'data/providers/mock_data_provider.dart';
import 'data/repositories/sems_repository.dart';

class SemsApp extends StatefulWidget {
  const SemsApp({super.key, this.mockDatabase, this.repository});

  final MockDatabase? mockDatabase;
  final SemsRepository? repository;

  @override
  State<SemsApp> createState() => _SemsAppState();
}

class _SemsAppState extends State<SemsApp> {
  late final GoRouter _router = createAppRouter();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final database = widget.mockDatabase;
    final repository = widget.repository;
    return ProviderScope(
      overrides: [
        if (database != null)
          mockDatabaseProvider.overrideWith((ref) => database),
        if (repository != null)
          semsRepositoryProvider.overrideWith((ref) async => repository),
      ],
      child: MaterialApp.router(
        title: 'SEMS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.light,
        routerConfig: _router,
      ),
    );
  }
}
