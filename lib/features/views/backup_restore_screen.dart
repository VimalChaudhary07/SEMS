import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/session/demo_session.dart';

/// Implements Figma Module 11: Google Drive backup and restore
/// Screen 122: Backup - not connected (Node ID: 22:146)
/// Screen 123: Backup - connected (Node ID: 22:314)
/// Screen 124: Backup - syncing (Node ID: 22:469)
/// Screen 125: Backup - failed (Node ID: 22:622)
/// Screen 126: Backup - Drive account unavailable (Node ID: 22:791)
/// Screen 127: Backup - Family (Owner only) (Node ID: 22:822)
/// Screen 128: Backup - Google account chooser (Node ID: 22:931)
/// Screen 129: Backup - manual backup sheet (Node ID: 22:1128)
/// Screen 130: Backup - verify result sheet (Node ID: 22:1305)
/// Screen 131: Restore 1 - Find backup (Node ID: 22:1402)
/// Screen 132: Restore 2 - Validating (Node ID: 22:1446)
/// Screen 133: Restore 3 - Review (Node ID: 22:1526)
/// Screen 134: Restore 4 - Restoring (Node ID: 22:1568)
/// Screen 135: Restore 5 - Done (Node ID: 22:1608)
/// Screen 136: Restore error - no backup found (Node ID: 22:1647)
/// Screen 137: Restore error - schema mismatch (Node ID: 22:1680)
/// Screen 138: Restore error - checksum failed (Node ID: 22:1715)
/// Screen 139: Restore error - Google account unavailable (Node ID: 22:1748)

enum BackupScreenStatus {
  notConnected,
  connected,
  syncing,
  failed,
  driveAccountUnavailable,
  familyOwnerOnly,
  googleAccountChooser,
  manualBackupSheet,
  verifyResultSheet,
  restore1FindBackup,
  restore2Validating,
  restore3Review,
  restore4Restoring,
  restore5Done,
  restoreErrorNoBackup,
  restoreErrorSchemaMismatch,
  restoreErrorChecksumFailed,
  restoreErrorGoogleAccountUnavailable,
}

class BackupRestoreScreen extends StatefulWidget {
  const BackupRestoreScreen({
    super.key,
    this.status = BackupScreenStatus.notConnected,
    this.bottomNavigationBar,
    this.onBack,
    this.onConnectDrive,
    this.onBackupNow,
    this.onVerify,
    this.onRestore,
    this.onDisconnectDrive,
    this.onRetryNow,
    this.onReconnect,
  });

  final BackupScreenStatus status;
  final Widget? bottomNavigationBar;
  final VoidCallback? onBack;
  final VoidCallback? onConnectDrive;
  final VoidCallback? onBackupNow;
  final VoidCallback? onVerify;
  final VoidCallback? onRestore;
  final VoidCallback? onDisconnectDrive;
  final VoidCallback? onRetryNow;
  final VoidCallback? onReconnect;

  @override
  State<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  late BackupScreenStatus _status;
  bool _dailyBackup = true;
  bool _weeklyCheckpoint = true;
  bool _backupOnChanges = true;

  @override
  void initState() {
    super.initState();
    _status = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      bottomNavigationBar: widget.bottomNavigationBar,
      body: SafeArea(
        child: Column(
          children: [
            // Status bar (24px)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 24,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '09:41',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F1714),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          AppAssets.iconWifi,
                          width: 12,
                          height: 12,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF0F1714),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '100%',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F1714),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Top bar (56px)
            Padding(
              padding: EdgeInsets.only(
                left: 8,
                right: _status == BackupScreenStatus.familyOwnerOnly ? 8 : 16,
              ),
              child: SizedBox(
                height: 56,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onBack ?? () => Navigator.of(context).maybePop(),
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          AppAssets.iconChevLeft,
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF0F1714),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Backup',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F1714),
                              height: 1.2,
                            ),
                          ),
                          if (_status != BackupScreenStatus.familyOwnerOnly)
                            Text(
                              _status == BackupScreenStatus.notConnected
                                  ? 'Not connected'
                                  : 'Google Drive',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF55625D),
                                height: 1.33,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (_status == BackupScreenStatus.familyOwnerOnly)
                      Container(
                        height: 20,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3ECFD),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Family',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2F6FED),
                          ),
                        ),
                      )
                    else
                      ValueListenableBuilder<DemoRole>(
                        valueListenable: DemoSession.role,
                        builder: (context, role, _) {
                          final isOwner = role == DemoRole.owner;
                          return Container(
                            height: 20,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: isOwner
                                  ? const Color(0xFFDDF4EA)
                                  : const Color(0xFFECEEF0),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              isOwner ? 'Owner' : 'Member',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isOwner
                                    ? const Color(0xFF0E9F6E)
                                    : const Color(0xFF7A8594),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  16,
                  4,
                  16,
                  _status == BackupScreenStatus.familyOwnerOnly ? 0 : 24,
                ),
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_status) {
      case BackupScreenStatus.notConnected:
        return _buildNotConnectedContent();
      case BackupScreenStatus.syncing:
        return _buildSyncingContent();
      case BackupScreenStatus.failed:
        return _buildFailedContent();
      case BackupScreenStatus.driveAccountUnavailable:
        return _buildDriveAccountUnavailableContent();
      case BackupScreenStatus.familyOwnerOnly:
        return _buildFamilyOwnerOnlyContent();
      case BackupScreenStatus.connected:
      default:
        return _buildConnectedContent();
    }
  }

  Widget _buildFamilyOwnerOnlyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFDDF4EA),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppAssets.iconLock,
                  width: 34,
                  height: 34,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF0E9F6E),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Only the Owner can manage backups',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F1714),
                  height: 24 / 17,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Ask the Owner to back up or restore home data.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF55625D),
                  height: 20 / 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 456),
        Center(
          child: Container(
            width: 112,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF0F1714),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildDriveAccountUnavailableContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDriveAccountUnavailableBanner(),
        const SizedBox(height: 16),
        _buildDriveStatusCard(isDisconnected: true),
        const SizedBox(height: 16),
        _buildScheduleSection(),
        const SizedBox(height: 16),
        _buildBackupContentsSection(),
        const SizedBox(height: 16),
        _buildRestoreFromBackupButton(),
        const SizedBox(height: 16),
        _buildDisconnectDriveButton(),
        const SizedBox(height: 16),
        _buildFooterInfoNote(),
        const SizedBox(height: 14),
        Center(
          child: Container(
            width: 112,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF0F1714),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildDriveAccountUnavailableBanner() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCF0D9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD98A00)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: SvgPicture.asset(
              AppAssets.iconAlert,
              width: 19,
              height: 19,
              colorFilter: const ColorFilter.mode(
                Color(0xFFD98A00),
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Google account unavailable',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F1714),
                    height: 1.54,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Sign in to Drive again to resume backups. Drive recovery depends on this account.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: widget.onReconnect ?? () {},
                  child: const Text(
                    'Reconnect',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFD98A00),
                      height: 1.38,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFailedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFailedBanner(),
        const SizedBox(height: 16),
        _buildDriveStatusCard(lastSynced: 'Yesterday 21:40'),
        const SizedBox(height: 16),
        _buildScheduleSection(),
        const SizedBox(height: 16),
        _buildBackupContentsSection(),
        const SizedBox(height: 16),
        _buildRestoreFromBackupButton(),
        const SizedBox(height: 16),
        _buildDisconnectDriveButton(),
        const SizedBox(height: 16),
        _buildFooterInfoNote(),
        const SizedBox(height: 14),
        Center(
          child: Container(
            width: 112,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF0F1714),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildFailedBanner() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFBE6E6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD64545)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: SvgPicture.asset(
              AppAssets.iconAlert,
              width: 19,
              height: 19,
              colorFilter: const ColorFilter.mode(
                Color(0xFFD64545),
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Last backup failed',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F1714),
                    height: 1.54,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Network lost while uploading. Retrying with backoff; your local copy is safe.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: widget.onRetryNow ?? () {},
                  child: const Text(
                    'Retry now',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFD64545),
                      height: 1.38,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildNotConnectedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeroCard(),
        const SizedBox(height: 16),
        _buildWarningBanner(),
        const SizedBox(height: 16),
        _buildWhatIsBackedUpSection(),
        const SizedBox(height: 16),
        _buildRestoreButton(),
      ],
    );
  }

  Widget _buildConnectedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDriveStatusCard(),
        const SizedBox(height: 16),
        _buildScheduleSection(),
        const SizedBox(height: 16),
        _buildBackupContentsSection(),
        const SizedBox(height: 16),
        _buildRestoreFromBackupButton(),
        const SizedBox(height: 16),
        _buildDisconnectDriveButton(),
        const SizedBox(height: 16),
        _buildFooterInfoNote(),
        const SizedBox(height: 14),
        Center(
          child: Container(
            width: 112,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF0F1714),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildSyncingContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSyncingBanner(),
        const SizedBox(height: 16),
        _buildDriveStatusCard(isSyncing: true),
        const SizedBox(height: 16),
        _buildScheduleSection(),
        const SizedBox(height: 16),
        _buildBackupContentsSection(),
        const SizedBox(height: 16),
        _buildRestoreFromBackupButton(),
        const SizedBox(height: 16),
        _buildDisconnectDriveButton(),
        const SizedBox(height: 16),
        _buildFooterInfoNote(),
        const SizedBox(height: 14),
        Center(
          child: Container(
            width: 112,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF0F1714),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _buildSyncingBanner() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE3ECFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2F6FED)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: SvgPicture.asset(
              AppAssets.iconRefresh,
              width: 19,
              height: 19,
              colorFilter: const ColorFilter.mode(
                Color(0xFF2F6FED),
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Backup in progress',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F1714),
                    height: 1.54,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Uploading 14 pending batches… 62%',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriveStatusCard({
    bool isSyncing = false,
    bool isDisconnected = false,
    String lastSynced = '2 h ago',
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E9E5)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(16, 22, 20, 0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color.fromRGBO(16, 22, 20, 0.05),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDisconnected
                      ? const Color(0xFFFCF0D9)
                      : const Color(0xFFE2F1E8),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  isDisconnected
                      ? AppAssets.iconCloudOff
                      : AppAssets.iconCloud,
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    isDisconnected
                        ? const Color(0xFFD98A00)
                        : const Color(0xFF2E9E5B),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Google Drive',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F1714),
                        height: 1.33,
                      ),
                    ),
                    Text(
                      'asha.verma@gmail.com',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF55625D),
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: isDisconnected
                      ? const Color(0xFFFCF0D9)
                      : const Color(0xFFE2F1E8),
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      isDisconnected
                          ? AppAssets.iconWifiOff
                          : AppAssets.iconCheck,
                      width: 13,
                      height: 13,
                      colorFilter: ColorFilter.mode(
                        isDisconnected
                            ? const Color(0xFFD98A00)
                            : const Color(0xFF2E9E5B),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isDisconnected ? 'Disconnected' : 'Connected',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDisconnected
                            ? const Color(0xFFD98A00)
                            : const Color(0xFF2E9E5B),
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Last synced',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF55625D),
                        height: 1.33,
                      ),
                    ),
                    Text(
                      lastSynced,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F1714),
                        height: 1.43,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Pending uploads',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF55625D),
                        height: 1.33,
                      ),
                    ),
                    Text(
                      '14 batches',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2F6FED),
                        height: 1.43,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isSyncing) ...[
            const SizedBox(height: 14),
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1EE),
                borderRadius: BorderRadius.circular(999),
              ),
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.62,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F6FED),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: Opacity(
                    opacity: isSyncing ? 0.45 : 1.0,
                    child: ElevatedButton(
                      onPressed: isSyncing ? null : (widget.onBackupNow ?? () {}),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E9F6E),
                        disabledBackgroundColor: const Color(0xFF0E9F6E),
                        disabledForegroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppAssets.iconUpload,
                            width: 18,
                            height: 18,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Back up now',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 104,
                height: 48,
                child: ElevatedButton(
                  onPressed: widget.onVerify ?? () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEAF1EE),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F1714),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'SCHEDULE',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.06 * 13,
              color: Color(0xFF55625D),
              height: 1.38,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE1E9E5)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(16, 22, 20, 0.05),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
              BoxShadow(
                color: Color.fromRGBO(16, 22, 20, 0.05),
                blurRadius: 14,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildScheduleRow(
                icon: AppAssets.iconClock,
                title: 'Daily backup',
                subtitle: 'Uploads new readings overnight',
                value: _dailyBackup,
                onChanged: (v) => setState(() => _dailyBackup = v),
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
              _buildScheduleRow(
                icon: AppAssets.iconCalendar,
                title: 'Weekly checkpoint',
                subtitle: 'Sunday, consolidated archive',
                value: _weeklyCheckpoint,
                onChanged: (v) => setState(() => _weeklyCheckpoint = v),
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
              _buildScheduleRow(
                icon: AppAssets.iconRefresh,
                title: 'Backup on changes',
                subtitle: 'Schedules, tariff and bills',
                value: _backupOnChanges,
                onChanged: (v) => setState(() => _backupOnChanges = v),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleRow({
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      height: 58,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1EE),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                icon,
                width: 19,
                height: 19,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF0F1714),
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0F1714),
                      height: 1.33,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF55625D),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            _FigmaToggle(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupContentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'BACKUP CONTENTS',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.06 * 13,
              color: Color(0xFF55625D),
              height: 1.38,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE1E9E5)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(16, 22, 20, 0.05),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
              BoxShadow(
                color: Color.fromRGBO(16, 22, 20, 0.05),
                blurRadius: 14,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildContentRow(
                icon: AppAssets.iconLayers,
                title: 'Appliances and sessions',
                count: '3 + 1 archived',
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
              _buildContentRow(
                icon: AppAssets.iconChart,
                title: 'Readings archive',
                count: '1.2 MB',
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
              _buildContentRow(
                icon: AppAssets.iconReceipt,
                title: 'Bills and tariff',
                count: '3 bills',
              ),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
              _buildContentRow(
                icon: AppAssets.iconSparkle,
                title: 'AI reports',
                count: '2',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContentRow({
    required String icon,
    required String title,
    required String count,
  }) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1EE),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                icon,
                width: 19,
                height: 19,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF0F1714),
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F1714),
                  height: 1.33,
                ),
              ),
            ),
            Text(
              count,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF55625D),
                height: 1.38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestoreFromBackupButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: widget.onRestore ?? () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE1E9E5)),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.iconDownload,
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                Color(0xFF0F1714),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Restore from backup',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F1714),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisconnectDriveButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: TextButton(
        onPressed: widget.onDisconnectDrive ?? () {},
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: const Text(
          'Disconnect Drive',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFFD64545),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterInfoNote() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: SvgPicture.asset(
            AppAssets.iconInfo,
            width: 14,
            height: 14,
            colorFilter: const ColorFilter.mode(
              Color(0xFF55625D),
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            'The folder is a normal Drive folder, so it survives uninstall. You can see it in Google Drive.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF55625D),
              height: 1.33,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE1E9E5)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(16, 22, 20, 0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color.fromRGBO(16, 22, 20, 0.05),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFDDF4EA),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppAssets.iconCloud,
              width: 34,
              height: 34,
              colorFilter: const ColorFilter.mode(
                Color(0xFF0E9F6E),
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Back up to your Google Drive',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F1714),
              height: 1.41,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Keep your history safe if you reinstall the app\nor change phones. It lives in a normal\nfolder in your own Drive.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF55625D),
              height: 1.43,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: widget.onConnectDrive ?? () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E9F6E),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.iconCloud,
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Connect Google Drive',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCF0D9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD98A00)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: SvgPicture.asset(
              AppAssets.iconAlert,
              width: 19,
              height: 19,
              colorFilter: const ColorFilter.mode(
                Color(0xFFD98A00),
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your history is only on this phone',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F1714),
                    height: 1.54,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Uninstalling SEMS removes local history\nthat has not been backed up.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatIsBackedUpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'WHAT IS BACKED UP',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.06 * 13,
              color: Color(0xFF55625D),
              height: 1.38,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE1E9E5)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(16, 22, 20, 0.05),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
              BoxShadow(
                color: Color.fromRGBO(16, 22, 20, 0.05),
                blurRadius: 14,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildFeatureRow('Appliances and sessions', AppAssets.iconLayers),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
              _buildFeatureRow('Daily and monthly usage', AppAssets.iconChart),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
              _buildFeatureRow('Schedules', AppAssets.iconCalendar),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
              _buildFeatureRow('Bills and tariff', AppAssets.iconReceipt),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
              _buildFeatureRow('Alerts', AppAssets.iconBell),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE1E9E5)),
              _buildFeatureRow('AI reports', AppAssets.iconSparkle),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureRow(String title, String iconAsset) {
    return SizedBox(
      height: 56,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1EE),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                iconAsset,
                width: 19,
                height: 19,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF0F1714),
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F1714),
                  height: 1.33,
                ),
              ),
            ),
            SvgPicture.asset(
              AppAssets.iconCheck,
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                Color(0xFF0E9F6E),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestoreButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: widget.onRestore ?? () {},
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE1E9E5)),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Restore from a backup',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F1714),
          ),
        ),
      ),
    );
  }
}

class _FigmaToggle extends StatelessWidget {
  const _FigmaToggle({required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 46,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? const Color(0xFF0E9F6E) : const Color(0xFFD9DEDC),
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(16, 22, 20, 0.15),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
