import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

export 'app_banner.dart';
export 'app_bottom_nav.dart';
export 'app_bottom_sheet.dart';
export 'app_button.dart';
export 'app_card.dart';
export 'app_checkbox.dart';
export 'app_chip.dart';
export 'app_dialog.dart';
export 'app_progress_bar.dart';
export 'app_radio_card.dart';
export 'app_row.dart';
export 'app_segmented.dart';
export 'app_text_field.dart';
export 'app_toast.dart';
export 'app_toggle.dart';
export 'app_top_bar.dart';
export 'alert_card.dart';
export 'appliance_icon.dart';
export 'empty_state.dart';
export 'energy_charts.dart';
export 'error_state.dart';
export 'estimated_badge.dart';
export 'insight_card.dart';
export 'load_bars.dart';
export 'metric_tile.dart';
export 'permission_gate.dart';
export 'power_control.dart';
export 'qr_scanner_view.dart';
export 'role_badge.dart';
export 'section_header.dart';
export 'settings_group.dart';
export 'signal_bars.dart';
export 'status_badge.dart';
export 'step_bar.dart';

class PageHeading extends StatelessWidget {
  const PageHeading({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
  });
  final String title;
  final String? subtitle;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
      ?action,
    ],
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.trailing, this.onTap});
  final String title;
  final String? trailing;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(title, style: Theme.of(context).textTheme.titleLarge),
      ),
      if (trailing != null)
        TextButton(onPressed: onTap, child: Text(trailing!)),
    ],
  );
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    this.delta,
  });
  final String label, value, unit;
  final IconData icon;
  final String? delta;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: SemsColors.mint,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: SemsColors.forest, size: 19),
          ),
          const SizedBox(height: 13),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 3),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    color: SemsColors.ink,
                  ),
                ),
                const SizedBox(width: 4),
                Text(unit, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          if (delta case final deltaText?) ...[
            const SizedBox(height: 5),
            Text(
              deltaText,
              style: const TextStyle(
                fontSize: 11,
                color: SemsColors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

class EnergyBars extends StatelessWidget {
  const EnergyBars({super.key, required this.values, this.selected = 5});
  final List<double> values;
  final int selected;
  @override
  Widget build(BuildContext context) {
    final motionDuration = MediaQuery.of(context).disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 460);
    return SizedBox(
      height: 156,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < values.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0,
                            end: (values[i] / 6.5).clamp(0, 1),
                          ),
                          duration: motionDuration,
                          curve: Curves.easeOutCubic,
                          builder: (context, factor, child) =>
                              FractionallySizedBox(
                                heightFactor: factor,
                                child: child,
                              ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: i == selected
                                  ? SemsColors.forest
                                  : SemsColors.mint,
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ['M', 'T', 'W', 'T', 'F', 'S', 'S'][i],
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
