// Implements Figma component: local mock-mode QR camera placeholder.
import 'package:flutter/material.dart';

import '../../core/theme/app_radii.dart';
import 'component_theme.dart';

class QrScannerView extends StatelessWidget {
  const QrScannerView({
    super.key,
    this.title = 'Scan socket QR code',
    this.subtitle = 'Camera preview is simulated in demo mode.',
    this.onMockScan,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onMockScan;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 280),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.raised,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.qr_code_scanner_rounded,
            size: 72,
            color: colors.brandPrimary,
          ),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (onMockScan != null) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onMockScan,
              icon: const Icon(Icons.qr_code_2),
              label: const Text('Use demo QR code'),
            ),
          ],
        ],
      ),
    );
  }
}
