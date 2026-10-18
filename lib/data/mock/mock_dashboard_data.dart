// Mock data provider for Dashboard screen conforming to Figma specifications.
import '../../core/constants/app_assets.dart';
import '../models/dashboard_models.dart';

abstract final class MockDashboardData {
  static const overview = DashboardOverview(
    peakWatts: 1890,
    peakTime: 'at 19:42',
    socketsOnline: 2,
    totalSockets: 3,
    todayKwh: 4.9,
    periodKwh: 168,
    billEstimateInr: 1292,
    lastSyncText: '2 h ago',
    pendingSyncCount: 14,
  );

  static const savingTip = DashboardSavingTip(
    category: 'AI SAVING TIP',
    badge: 'Forecast',
    body:
        'Start the heater schedule 30 minutes later. Forecast saving is about 6 kWh a week (range 4 to 8).',
    actionText: 'See AI insights',
  );

  static const insights = <DashboardAiInsight>[
    DashboardAiInsight(
      categoryTitle: 'Abnormal Consumption',
      mainTitle: 'Heater is 47% above normal',
      subtitle1: 'Current 2,200 W, usual 1,500 W',
      subtitle2: 'Possible abnormal behaviour. Please check the appliance.',
      badge1Text: 'HIGH',
      badge2Text: 'Estimated',
      actionButtonText: 'Check Appliance',
      iconAsset: AppAssets.iconTrend,
      isAnomaly: true,
    ),
    DashboardAiInsight(
      categoryTitle: 'Potential Saving',
      mainTitle: 'Reduce heater usage 1 hr/day',
      subtitle1: 'Save ₹20/day, ₹600/month, 60 kWh/month',
      badge1Text: 'Estimated',
      actionButtonText: 'View Suggestion',
      iconAsset: AppAssets.iconFlame,
      isAnomaly: false,
    ),
    DashboardAiInsight(
      categoryTitle: 'Consumption Forecast',
      mainTitle: 'Estimated this month 248 kWh',
      subtitle1: '₹2,480 estimated cost · range 231 to 266 kWh',
      badge1Text: 'Estimated',
      iconAsset: AppAssets.iconTrend,
      isAnomaly: false,
    ),
  ];

  static const List<double> loadCurveHeights = [
    6,
    6,
    6,
    6,
    6,
    8,
    16,
    16,
    22,
    22,
    22,
    14,
    14,
    14,
    14,
    14,
    14,
    24,
    42,
    42,
    42,
    42,
    16,
    16,
  ];
}
