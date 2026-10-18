import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_assets.dart';
import '../../core/session/demo_session.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text.dart';
import '../../data/models/sems_models.dart';
import '../../data/repositories/sems_repository.dart';
import '../../shared/widgets/component_theme.dart';
import '../../shared/widgets/role_badge.dart';
import '../../shared/widgets/signal_bars.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final NumberFormat _numberFormat = NumberFormat('#,##0');

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSetup() {
    Navigator.of(context).push(
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

  void _openDetail(SemsDevice device) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DeviceDetailScreen(
          device: device,
          repository: widget.repository,
          onChanged: () {
            setState(() {});
            widget.onChanged();
          },
        ),
      ),
    );
  }

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
          // Top Bar — height 56px, matching Figma frame #14:149
          _TopBar(
            socketCount: allDevices.length,
            onAddSocket: DemoSession.isMember ? null : _openSetup,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              children: [
                // Search field & Room chips — Frame #14:20
                _SearchAndFilter(
                  controller: _searchController,
                  query: query,
                  selectedRoom: selectedRoom,
                  onQueryChanged: (value) => setState(() => query = value),
                  onRoomSelected: (room) => setState(() => selectedRoom = room),
                ),
                const SizedBox(height: 16),
                if (devices.isEmpty)
                  _EmptyDevicesView(
                    hasAnyDevices: allDevices.isNotEmpty,
                    onAddSocket: _openSetup,
                  )
                else
                  for (final device in devices)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _DeviceCard(
                        device: device,
                        formattedWatts: _numberFormat.format(device.watts),
                        onTap: () => _openDetail(device),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.socketCount,
    required this.onAddSocket,
  });

  final int socketCount;
  final VoidCallback? onAddSocket;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    return Container(
      height: 56,
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Devices',
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 20,
                      height: 24 / 20,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$socketCount sockets',
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 12,
                      height: 16 / 12,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (onAddSocket != null)
            Tooltip(
              message: 'Add socket',
              child: InkWell(
                onTap: onAddSocket,
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    AppAssets.iconPlus,
                    width: 22,
                    height: 22,
                    colorFilter: ColorFilter.mode(
                      colors.textPrimary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(width: 4),
          RoleBadge(isFamily: DemoSession.isMember, showIcon: false),
        ],
      ),
    );
  }
}

class _SearchAndFilter extends StatelessWidget {
  const _SearchAndFilter({
    required this.controller,
    required this.query,
    required this.selectedRoom,
    required this.onQueryChanged,
    required this.onRoomSelected,
  });

  final TextEditingController controller;
  final String query;
  final String selectedRoom;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onRoomSelected;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    const rooms = ['All', 'Living room', 'Bedroom', 'Kitchen'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search Input — height 48px, radius 8px, Frame #14:9
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                AppAssets.iconSearch,
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(
                  colors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onQueryChanged,
                  style: TextStyle(
                    fontFamily: AppText.family,
                    fontSize: 15,
                    height: 20 / 15,
                    fontWeight: FontWeight.w400,
                    color: colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: 'Search sockets or appliances',
                    hintStyle: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 15,
                      height: 20 / 15,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              if (query.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    controller.clear();
                    onQueryChanged('');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: colors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Room Filter Chips — height 36px, gap 8px, Frame #14:19
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final room in rooms) ...[
                _RoomChip(
                  label: room,
                  selected: selectedRoom == room,
                  onTap: () => onRoomSelected(room),
                ),
                if (room != rooms.last) const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RoomChip extends StatelessWidget {
  const _RoomChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final bg = selected ? colors.brandPrimary : colors.card;
    final border = selected ? colors.brandPrimary : colors.border;
    final text = selected ? Colors.white : colors.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppText.family,
            fontSize: 13,
            height: 18 / 13,
            fontWeight: FontWeight.w500,
            color: text,
          ),
        ),
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({
    required this.device,
    required this.formattedWatts,
    required this.onTap,
  });

  final SemsDevice device;
  final String formattedWatts;
  final VoidCallback onTap;

  String get _applianceSvg {
    final name = device.appliance.toLowerCase();
    if (name.contains('fan')) return AppAssets.iconFan;
    if (name.contains('fridge') || name.contains('refrigerator')) {
      return AppAssets.iconFridge;
    }
    if (name.contains('heater')) return AppAssets.iconFlame;
    return AppAssets.iconPlug;
  }

  int get _signalLevel {
    if (!device.online) return 0;
    if (device.signalDbm != null) {
      if (device.signalDbm! > -60) return 4;
      if (device.signalDbm! > -75) return 3;
      if (device.signalDbm! > -85) return 2;
      return 1;
    }
    final name = device.name.toLowerCase();
    if (name.contains('bedroom')) return 3;
    return 4;
  }

  String get _lastSeenText {
    if (!device.online) {
      return device.lastSeenMinutes > 0
          ? '${device.lastSeenMinutes} min ago'
          : '14 min ago';
    }
    final name = device.name.toLowerCase();
    if (name.contains('bedroom')) return '6 s ago';
    return '4 s ago';
  }

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);
    final iconBg = device.online
        ? colors.brandTint
        : (colors.statusOfflineTint ?? const Color(0xFFECEEF0));
    final iconColor = device.online
        ? colors.brandPrimary
        : colors.statusOffline;

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
        boxShadow: AppShadows.card,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Row — Appliance icon, Title/Room, Power
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      _applianceSvg,
                      width: 22,
                      height: 22,
                      colorFilter: ColorFilter.mode(
                        iconColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          device.name,
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 15,
                            height: 20 / 15,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${device.room} · ${device.appliance}',
                          style: TextStyle(
                            fontFamily: AppText.family,
                            fontSize: 12,
                            height: 16 / 12,
                            fontWeight: FontWeight.w400,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    device.online && device.isOn ? '$formattedWatts W' : '—',
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 18,
                      height: 24 / 18,
                      fontWeight: FontWeight.w600,
                      color: device.online && device.isOn
                          ? colors.textPrimary
                          : colors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Bottom Row — Badges, Signal, Timestamp
              Row(
                children: [
                  if (device.online) ...[
                    _PillBadge(
                      text: 'Online',
                      iconAsset: AppAssets.iconWifi,
                      textColor: colors.statusOk,
                      bgColor: colors.statusOkTint ?? const Color(0xFFE2F1E8),
                    ),
                    const SizedBox(width: 6),
                    _PillBadge(
                      text: device.isOn ? 'ON' : 'OFF',
                      iconAsset: AppAssets.iconPower,
                      textColor: device.isOn
                          ? colors.brandPrimary
                          : colors.textSecondary,
                      bgColor: device.isOn
                          ? colors.brandTint
                          : colors.raised,
                    ),
                  ] else
                    _PillBadge(
                      text: 'Offline',
                      iconAsset: AppAssets.iconWifiOff,
                      textColor: colors.statusOffline,
                      bgColor: colors.statusOfflineTint ??
                          const Color(0xFFECEEF0),
                    ),
                  const Spacer(),
                  SignalBars(
                    level: _signalLevel,
                    activeColor: colors.textPrimary,
                    inactiveColor: colors.border,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _lastSeenText,
                    style: TextStyle(
                      fontFamily: AppText.family,
                      fontSize: 12,
                      height: 16 / 12,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillBadge extends StatelessWidget {
  const _PillBadge({
    required this.text,
    required this.iconAsset,
    required this.textColor,
    required this.bgColor,
  });

  final String text;
  final String iconAsset;
  final Color textColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconAsset,
            width: 13,
            height: 13,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontFamily: AppText.family,
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDevicesView extends StatelessWidget {
  const _EmptyDevicesView({
    required this.hasAnyDevices,
    required this.onAddSocket,
  });

  final bool hasAnyDevices;
  final VoidCallback onAddSocket;

  @override
  Widget build(BuildContext context) {
    final colors = ComponentTheme.colors(context);

    if (hasAnyDevices) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: colors.raised,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.search_off_rounded,
                  size: 38,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'No matching sockets',
                style: TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 17,
                  height: 22 / 17,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Try another search or room.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppText.family,
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w400,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: colors.raised,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                AppAssets.splashSocket,
                width: 34,
                height: 34,
                colorFilter: ColorFilter.mode(
                  colors.brandPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No sockets added',
              style: TextStyle(
                fontFamily: AppText.family,
                fontSize: 17,
                height: 22 / 17,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Add a socket by scanning the QR code on its box.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppText.family,
                fontSize: 14,
                height: 20 / 14,
                fontWeight: FontWeight.w400,
                color: colors.textSecondary,
              ),
            ),
            if (!DemoSession.isMember) ...[
              const SizedBox(height: 20),
              InkWell(
                onTap: onAddSocket,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: colors.brandPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        AppAssets.iconPlus,
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Add socket',
                        style: TextStyle(
                          fontFamily: AppText.family,
                          fontSize: 15,
                          height: 20 / 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
