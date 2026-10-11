// Implements Figma component: alert card and acknowledgement action.
import 'package:flutter/material.dart';

import 'app_card.dart';
import 'status_badge.dart';
import 'component_theme.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({
    super.key,
    required this.title,
    required this.time,
    required this.device,
    required this.severity,
    this.occurredReceived,
    this.cause,
    this.nextStep,
    this.acknowledged = false,
    this.onAcknowledge,
    this.onTap,
  });

  final String title;
  final String time;
  final String device;
  final StatusTone severity;
  final String? occurredReceived;
  final String? cause;
  final String? nextStep;
  final bool acknowledged;
  final VoidCallback? onAcknowledge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final toneName = switch (severity) {
      StatusTone.ok => 'ok',
      StatusTone.warn || StatusTone.yellow => 'warn',
      StatusTone.fault => 'fault',
      StatusTone.off => 'off',
      StatusTone.pend => 'pend',
      StatusTone.ai => 'ai',
      StatusTone.orange => 'orange',
      StatusTone.brand => 'brand',
      StatusTone.mute => 'mute',
    };
    final color = ComponentTheme.tone(context, toneName);
    return AppCard(
      accentColor: color,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusBadge(label: severity.name.toUpperCase(), tone: severity),
              const Spacer(),
              if (acknowledged)
                const StatusBadge(
                  label: 'Acknowledged',
                  tone: StatusTone.mute,
                  compact: true,
                )
              else
                Text(time, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 10),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(device, style: Theme.of(context).textTheme.bodySmall),
          if (occurredReceived != null ||
              cause != null ||
              nextStep != null) ...[
            const SizedBox(height: 10),
            if (occurredReceived != null)
              _DetailRow('Occurred / received', occurredReceived!),
            if (cause != null) _DetailRow('Cause', cause!),
            if (nextStep != null) _DetailRow('Next step', nextStep!),
          ],
          if (!acknowledged && onAcknowledge != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onAcknowledge,
                child: const Text('Acknowledge'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 118,
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    ),
  );
}
