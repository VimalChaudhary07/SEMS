// Model classes for Dashboard Screen visual data foundations.
import 'package:flutter/foundation.dart';

@immutable
class DashboardOverview {
  const DashboardOverview({
    this.peakWatts = 1890,
    this.peakTime = 'at 19:42',
    this.socketsOnline = 2,
    this.totalSockets = 3,
    this.todayKwh = 4.9,
    this.periodKwh = 168,
    this.billEstimateInr = 1292,
    this.lastSyncText = '2 h ago',
    this.pendingSyncCount = 14,
  });

  final int peakWatts;
  final String peakTime;
  final int socketsOnline;
  final int totalSockets;
  final double todayKwh;
  final int periodKwh;
  final int billEstimateInr;
  final String lastSyncText;
  final int pendingSyncCount;
}

@immutable
class DashboardAiInsight {
  const DashboardAiInsight({
    required this.categoryTitle,
    required this.mainTitle,
    required this.subtitle1,
    this.subtitle2,
    required this.badge1Text,
    this.badge2Text,
    this.actionButtonText,
    required this.iconAsset,
    this.isAnomaly = false,
  });

  final String categoryTitle;
  final String mainTitle;
  final String subtitle1;
  final String? subtitle2;
  final String badge1Text;
  final String? badge2Text;
  final String? actionButtonText;
  final String iconAsset;
  final bool isAnomaly;
}

@immutable
class DashboardSavingTip {
  const DashboardSavingTip({
    this.category = 'AI SAVING TIP',
    this.badge = 'Forecast',
    this.body =
        'Start the heater schedule 30 minutes later. Forecast saving is about 6 kWh a week (range 4 to 8).',
    this.actionText = 'See AI insights',
  });

  final String category;
  final String badge;
  final String body;
  final String actionText;
}
