import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/session/demo_session.dart';
import '../../data/models/sems_models.dart';
import '../../data/repositories/sems_repository.dart';
import '../../shared/widgets/sems_widgets.dart';
import 'device_detail_screen.dart';
import 'device_pairing_screen.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({
    super.key,
    required this.repository,
    required this.onChanged,
  });
  final SemsRepository repository;
  final VoidCallback onChanged;
  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  String query = '';
  String selectedRoom = 'All';
  @override
  Widget build(BuildContext context) {
    final allDevices = widget.repository.devices;
    final devices = allDevices
        .where(
          (d) =>
              '${d.name} ${d.room} ${d.appliance}'.toLowerCase().contains(
                query.toLowerCase(),
              ) &&
              (selectedRoom == 'All' || d.room == selectedRoom),
        )
        .toList();
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: PageHeading(
              title: 'Devices',
              subtitle: '${allDevices.length} sockets',
              action: DemoSession.isMember
                  ? null
                  : IconButton(
                      onPressed: _openSetup,
                      icon: const Icon(
                        Icons.add_circle_outline_rounded,
                        size: 27,
                        color: SemsColors.forest,
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                hintText: 'Search sockets or appliances',
                isDense: true,
              ),
              onChanged: (value) => setState(() => query = value),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final room in ['All', 'Living room', 'Bedroom', 'Kitchen'])
                  Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: ChoiceChip(
                      label: Text(room),
                      selected: selectedRoom == room,
                      onSelected: (_) => setState(() => selectedRoom = room),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: devices.isEmpty
                ? _emptyDevices(context, hasAnyDevices: allDevices.isNotEmpty)
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      for (final device in devices)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _DeviceCard(
                            device: device,
                            repository: widget.repository,
                            onChanged: () {
                              setState(() {});
                              widget.onChanged();
                            },
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _emptyDevices(BuildContext context, {required bool hasAnyDevices}) =>
      Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AppCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  hasAnyDevices
                      ? Icons.search_off_rounded
                      : Icons.power_rounded,
                  size: 38,
                  color: SemsColors.forest,
                ),
                const SizedBox(height: 12),
                Text(
                  hasAnyDevices ? 'No matching sockets' : 'No sockets yet',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  hasAnyDevices ? 'Try another search or room.' : 'Add your first SEMS socket to start measuring and controlling an appliance.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: SemsColors.muted, fontSize: 12),
                ),
                if (!hasAnyDevices && !DemoSession.isMember) ...[
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: _openSetup,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add socket'),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
  void _openSetup() => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => DevicePairingScreen(
        repository: widget.repository,
        onAdded: () {
          setState(() {});
          widget.onChanged();
        },
      ),
    ),
  );
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({
    required this.device,
    required this.repository,
    required this.onChanged,
  });
  final SemsDevice device;
  final SemsRepository repository;
  final VoidCallback onChanged;
  @override
  Widget build(BuildContext context) => AppCard(
    padding: const EdgeInsets.fromLTRB(14, 14, 14, 11),
    child: InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => DeviceDetailScreen(
            device: device,
            repository: repository,
            onChanged: onChanged,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: device.online
                      ? SemsColors.mint
                      : const Color(0xFFECEFEE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _applianceIcon,
                  color: device.online ? SemsColors.forest : SemsColors.muted,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${device.room} · ${device.appliance}',
                      style: const TextStyle(
                        color: SemsColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                device.online && device.isOn
                    ? '${device.watts.toStringAsFixed(0)} W'
                    : '—',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _statusBadge(
                icon: device.online
                    ? Icons.wifi_rounded
                    : Icons.wifi_off_rounded,
                label: device.online ? 'Online' : 'Offline',
                isActive: device.online,
              ),
              if (device.online) ...[
                const SizedBox(width: 7),
                _statusBadge(
                  icon: Icons.power_settings_new_rounded,
                  label: device.isOn ? 'ON' : 'OFF',
                  isActive: device.isOn,
                ),
              ],
              const Spacer(),
              Icon(
                Icons.signal_cellular_alt_rounded,
                size: 15,
                color: device.online ? SemsColors.ink : SemsColors.line,
              ),
              const SizedBox(width: 5),
              Text(
                device.online ? '4 s ago' : '14 min ago',
                style: const TextStyle(color: SemsColors.muted, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  IconData get _applianceIcon {
    final name = device.appliance.toLowerCase();
    if (name.contains('fan')) return Icons.air_rounded;
    if (name.contains('refrigerator') || name.contains('fridge')) {
      return Icons.kitchen_outlined;
    }
    if (name.contains('heater')) return Icons.local_fire_department_outlined;
    return Icons.power_rounded;
  }

  Widget _statusBadge({
    required IconData icon,
    required String label,
    required bool isActive,
  }) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: isActive ? SemsColors.mint : const Color(0xFFECEFEE),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: isActive ? SemsColors.forest : SemsColors.muted,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? SemsColors.forest : SemsColors.muted,
            fontSize: 11,
          ),
        ),
      ],
    ),
  );
}
