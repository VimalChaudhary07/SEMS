// Implements Figma frame: persistent five-tab application shell.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/mock_data_provider.dart';
import '../../data/repositories/sems_repository.dart';
import '../views/alerts_screen.dart';
import '../views/analytics_screen.dart';
import '../views/dashboard_screen.dart';
import '../views/devices_screen.dart';
import '../views/more_home_screen.dart';
import '../../shared/widgets/app_bottom_nav.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  AppShellState createState() => AppShellState();
}

class AppShellState extends ConsumerState<AppShell> {
  int selectedIndex = 0;

  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(semsRepositoryProvider);
    return repository.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Could not load local SEMS data.'),
                const SizedBox(height: 12),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => ref.invalidate(semsRepositoryProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (value) => _buildShell(value),
    );
  }

  Widget _buildShell(SemsRepository repository) {
    final pages = [
      DashboardScreen(repository: repository),
      DevicesScreen(repository: repository, onChanged: refresh),
      AnalyticsScreen(repository: repository),
      AlertsScreen(repository: repository),
      MoreScreen(repository: repository),
    ];
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: AppBottomNav(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => setState(() => selectedIndex = index),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
