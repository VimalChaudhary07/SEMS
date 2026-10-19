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
  int _selectedManualBackupOption = 0;
  int _selectedRestoreConflictOption = 0;

  @override
  void initState() {
    super.initState();
    _status = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    final bodyContent = SafeArea(
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
              left: _status == BackupScreenStatus.restore5Done ? 20 : 8,
              right: (_status == BackupScreenStatus.familyOwnerOnly ||
                      _isRestoreFlow)
                  ? 8
                  : 16,
            ),
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  if (_status != BackupScreenStatus.restore5Done)
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
                        Text(
                          _topBarTitle,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F1714),
                            height: 1.2,
                          ),
                        ),
                        if (_topBarSubtitle != null)
                          Text(
                            _topBarSubtitle!,
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
                (_status == BackupScreenStatus.familyOwnerOnly ||
                        _status == BackupScreenStatus.restore1FindBackup ||
                        _status == BackupScreenStatus.restore2Validating ||
                        _status == BackupScreenStatus.restore3Review ||
                        _status == BackupScreenStatus.restore4Restoring ||
                        _status == BackupScreenStatus.restore5Done ||
                        _status == BackupScreenStatus.restoreErrorNoBackup ||
                        _status == BackupScreenStatus.restoreErrorSchemaMismatch ||
                        _status == BackupScreenStatus.restoreErrorChecksumFailed ||
                        _status == BackupScreenStatus.restoreErrorGoogleAccountUnavailable)
                    ? 0
                    : 24,
              ),
              child: _buildContent(),
            ),
          ),
          if (_status == BackupScreenStatus.restore1FindBackup)
            _buildRestoreFooter(
              label: 'Search Drive for SEMS backup',
              onTap: () {
                setState(() {
                  _status = BackupScreenStatus.restore2Validating;
                });
              },
            ),
          if (_status == BackupScreenStatus.restore3Review)
            _buildRestoreFooter(
              label: 'Restore',
              onTap: () {
                setState(() {
                  _status = BackupScreenStatus.restore4Restoring;
                });
              },
            ),
        ],
      ),
    );

    if (_status == BackupScreenStatus.googleAccountChooser ||
        _status == BackupScreenStatus.manualBackupSheet ||
        _status == BackupScreenStatus.verifyResultSheet) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F7F6),
        bottomNavigationBar: widget.bottomNavigationBar,
        body: Stack(
          children: [
            bodyContent,
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _status = _status == BackupScreenStatus.googleAccountChooser
                        ? BackupScreenStatus.notConnected
                        : BackupScreenStatus.connected;
                  });
                },
                child: Container(
                  color: const Color.fromRGBO(0, 0, 0, 0.45),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _status == BackupScreenStatus.googleAccountChooser
                  ? _buildGoogleAccountChooserSheet()
                  : _status == BackupScreenStatus.manualBackupSheet
                      ? _buildManualBackupSheet()
                      : _buildVerifyResultSheet(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      bottomNavigationBar: widget.bottomNavigationBar,
      body: bodyContent,
    );
  }

  Widget _buildContent() {
    switch (_status) {
      case BackupScreenStatus.notConnected:
      case BackupScreenStatus.googleAccountChooser:
        return _buildNotConnectedContent();
      case BackupScreenStatus.syncing:
        return _buildSyncingContent();
      case BackupScreenStatus.failed:
        return _buildFailedContent();
      case BackupScreenStatus.driveAccountUnavailable:
        return _buildDriveAccountUnavailableContent();
      case BackupScreenStatus.familyOwnerOnly:
        return _buildFamilyOwnerOnlyContent();
      case BackupScreenStatus.restore1FindBackup:
        return _buildRestore1FindBackupContent();
      case BackupScreenStatus.restore2Validating:
        return _buildRestore2ValidatingContent();
      case BackupScreenStatus.restore3Review:
        return _buildRestore3ReviewContent();
      case BackupScreenStatus.restore4Restoring:
        return _buildRestore4RestoringContent();
      case BackupScreenStatus.restore5Done:
        return _buildRestore5DoneContent();
      case BackupScreenStatus.restoreErrorNoBackup:
        return _buildRestoreErrorNoBackupContent();
      case BackupScreenStatus.restoreErrorSchemaMismatch:
        return _buildRestoreErrorSchemaMismatchContent();
      case BackupScreenStatus.manualBackupSheet:
      case BackupScreenStatus.verifyResultSheet:
      case BackupScreenStatus.connected:
      default:
        return _buildConnectedContent();
    }
  }

  Widget _buildGoogleAccountChooserSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Grab handle (18px)
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1E9E5),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),

          // Header row (52px)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Choose an account',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F1714),
                      height: 24 / 18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _status = BackupScreenStatus.notConnected;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        AppAssets.iconClose,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF0F1714),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Accounts & permission card group
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Accounts card (119px)
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
                    _buildAccountRow(
                      email: 'asha.verma@gmail.com',
                      name: 'Asha Verma',
                      onTap: () {},
                    ),
                    Container(
                      height: 1,
                      color: const Color(0xFFE1E9E5),
                    ),
                    _buildAccountRow(
                      email: 'asha.work@company.com',
                      name: 'Asha V',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Permission banner (84px)
              _buildPermissionBanner(),

              const SizedBox(height: 12),

              // Allow access button (48px)
              GestureDetector(
                onTap: widget.onConnectDrive ?? () {},
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E9F6E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Allow access',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  Widget _buildAccountRow({
    required String email,
    required String name,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                AppAssets.iconUser,
                width: 19,
                height: 19,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF55625D),
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
                    email,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0F1714),
                      height: 20 / 15,
                    ),
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF55625D),
                      height: 18 / 12,
                    ),
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              AppAssets.iconChevRight,
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                Color(0xFF55625D),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionBanner() {
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
              AppAssets.iconLock,
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
                  'SEMS asks for one permission',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F1714),
                    height: 20 / 13,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Create and manage only the files SEMS creates in your Drive. It cannot see your other files.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                    height: 18 / 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualBackupSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Grab handle (18px)
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1E9E5),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),

          // Header row (52px)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Manual backup',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F1714),
                      height: 24 / 18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _status = BackupScreenStatus.connected;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        AppAssets.iconClose,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF0F1714),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Radio options group
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildManualBackupRadioOption(
                index: 0,
                title: 'Full account',
                subtitle: 'Everything listed in the backup contents',
              ),
              const SizedBox(height: 12),
              _buildManualBackupRadioOption(
                index: 1,
                title: 'Selected data',
                subtitle: 'Choose appliances, sockets or a date range',
              ),
              const SizedBox(height: 12),
              _buildManualBackupRadioOption(
                index: 2,
                title: 'Export ZIP file',
                subtitle: 'Save a copy on this phone instead',
              ),
              const SizedBox(height: 12),

              // Button "Start backup" (48px)
              GestureDetector(
                onTap: widget.onBackupNow ?? () {},
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E9F6E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
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
                        'Start backup',
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
        ],
      ),
    );
  }

  Widget _buildManualBackupRadioOption({
    required int index,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedManualBackupOption == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedManualBackupOption = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDDF4EA) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF0E9F6E) : const Color(0xFFE1E9E5),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0E9F6E)
                      : const Color(0xFFE1E9E5),
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: isSelected
                  ? Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0E9F6E),
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0F1714),
                      height: 20 / 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF55625D),
                      height: 18 / 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifyResultSheet() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Grab handle (18px)
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1E9E5),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),

          // Header row (52px)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Backup verified',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F1714),
                      height: 24 / 18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _status = BackupScreenStatus.connected;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        AppAssets.iconClose,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF0F1714),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Verification content & group card
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Checkmark container (88px)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE2F1E8),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        AppAssets.iconCheck,
                        width: 26,
                        height: 26,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF2E9E5B),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'All checksums match',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F1714),
                        height: 20 / 15,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Group card (171px)
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
                    // Row 1: Batches checked
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Batches checked',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F1714),
                              height: 20 / 15,
                            ),
                          ),
                          Text(
                            '128',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F1714),
                              height: 18 / 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(height: 1, color: const Color(0xFFE1E9E5)),
                    // Row 2: Gaps found
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Gaps found',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F1714),
                              height: 20 / 15,
                            ),
                          ),
                          Container(
                            height: 24,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCF0D9),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.iconAlert,
                                  width: 13,
                                  height: 13,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFFD98A00),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '1 gap',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFD98A00),
                                    height: 16 / 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(height: 1, color: const Color(0xFFE1E9E5)),
                    // Row 3: Schema
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Schema',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F1714),
                              height: 20 / 15,
                            ),
                          ),
                          Text(
                            'v1',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F1714),
                              height: 18 / 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Button "Done" (48px)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _status = BackupScreenStatus.connected;
                  });
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E9F6E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  bool get _isRestoreFlow {
    switch (_status) {
      case BackupScreenStatus.restore1FindBackup:
      case BackupScreenStatus.restore2Validating:
      case BackupScreenStatus.restore3Review:
      case BackupScreenStatus.restore4Restoring:
      case BackupScreenStatus.restore5Done:
      case BackupScreenStatus.restoreErrorNoBackup:
      case BackupScreenStatus.restoreErrorSchemaMismatch:
      case BackupScreenStatus.restoreErrorChecksumFailed:
      case BackupScreenStatus.restoreErrorGoogleAccountUnavailable:
        return true;
      default:
        return false;
    }
  }

  String get _topBarTitle {
    if (_isRestoreFlow) {
      return 'Restore from backup';
    }
    return 'Backup';
  }

  String? get _topBarSubtitle {
    if (_status == BackupScreenStatus.familyOwnerOnly) {
      return null;
    }
    switch (_status) {
      case BackupScreenStatus.restore1FindBackup:
        return 'Step 1 of 4';
      case BackupScreenStatus.restore2Validating:
        return 'Step 2 of 4';
      case BackupScreenStatus.restore3Review:
        return 'Step 3 of 4';
      case BackupScreenStatus.restore4Restoring:
        return 'Step 4 of 4';
      case BackupScreenStatus.restore5Done:
      case BackupScreenStatus.restoreErrorNoBackup:
      case BackupScreenStatus.restoreErrorSchemaMismatch:
      case BackupScreenStatus.restoreErrorChecksumFailed:
      case BackupScreenStatus.restoreErrorGoogleAccountUnavailable:
        return null;
      case BackupScreenStatus.notConnected:
      case BackupScreenStatus.googleAccountChooser:
        return 'Not connected';
      default:
        return 'Google Drive';
    }
  }

  Widget _buildRestore1FindBackupContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 4-step progress bar (height 4px + 20px bottom spacing)
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E9F6E),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1E9E5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1E9E5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1E9E5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Title: Find your backup (22 Bold, #0F1714)
        const Text(
          'Find your backup',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F1714),
            height: 28 / 22,
          ),
        ),
        const SizedBox(height: 4),

        // Subtitle: Sign in with the Google account you used before. (14 Regular, #55625D)
        const Text(
          'Sign in with the Google account you used before.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF55625D),
            height: 20 / 14,
          ),
        ),
        const SizedBox(height: 20),

        // Group Card: 2 rows
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
              _buildRestoreAccountRow(
                title: 'asha.verma@gmail.com',
                onTap: () {},
              ),
              Container(
                height: 1,
                color: const Color(0xFFE1E9E5),
              ),
              _buildRestoreAccountRow(
                title: 'Use another account',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRestoreAccountRow({
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                AppAssets.iconUser,
                width: 19,
                height: 19,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF55625D),
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
                  height: 20 / 15,
                ),
              ),
            ),
            SvgPicture.asset(
              AppAssets.iconChevRight,
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(
                Color(0xFF55625D),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestoreFooter({
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF4F7F6),
        border: Border(
          top: BorderSide(
            color: Color(0xFFE1E9E5),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF0E9F6E),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
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
      ),
    );
  }

  Widget _buildRestore3ReviewContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 4-step progress bar (height 4px + 20px bottom spacing)
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E9F6E),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E9F6E),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E9F6E),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1E9E5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Title: Backup found (22 Bold, #0F1714)
        const Text(
          'Backup found',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F1714),
            height: 28 / 22,
          ),
        ),
        const SizedBox(height: 4),

        // Subtitle: Saved 11 Oct 2026, 06:00 · schema v1 · all checksums valid. (14 Regular, #55625D)
        const Text(
          'Saved 11 Oct 2026, 06:00 · schema v1 · all checksums valid.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF55625D),
            height: 20 / 14,
          ),
        ),
        const SizedBox(height: 16),

        // Group Card: 5 rows
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
              _buildReviewRow(title: 'Appliances', trailing: '3 + 1 archived'),
              Container(height: 1, color: const Color(0xFFE1E9E5)),
              _buildReviewRow(title: 'Sessions', trailing: '8'),
              Container(height: 1, color: const Color(0xFFE1E9E5)),
              _buildReviewRow(title: 'Readings', trailing: '412,880'),
              Container(height: 1, color: const Color(0xFFE1E9E5)),
              _buildReviewRow(title: 'Schedules', trailing: '2'),
              Container(height: 1, color: const Color(0xFFE1E9E5)),
              _buildReviewRow(title: 'Bills', trailing: '3'),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Warning banner
        Container(
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
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2 conflicts with data on this phone',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F1714),
                        height: 20 / 13,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Heater and Evening heater already exist here.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF55625D),
                        height: 18 / 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Radio 1: Merge
        _buildConflictRadioOption(
          index: 0,
          title: 'Merge',
          subtitle: 'Keep newer items, add the rest',
        ),
        const SizedBox(height: 8),

        // Radio 2: Import as new
        _buildConflictRadioOption(
          index: 1,
          title: 'Import as new',
          subtitle: 'Add everything as separate copies',
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildReviewRow({
    required String title,
    required String trailing,
  }) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0F1714),
              height: 20 / 15,
            ),
          ),
          Text(
            trailing,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF0F1714),
              height: 18 / 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConflictRadioOption({
    required int index,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedRestoreConflictOption == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRestoreConflictOption = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDDF4EA) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0E9F6E)
                : const Color(0xFFE1E9E5),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0E9F6E)
                      : const Color(0xFFE1E9E5),
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: isSelected
                  ? Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0E9F6E),
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0F1714),
                      height: 20 / 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF55625D),
                      height: 18 / 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestore2ValidatingContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 4-step progress bar (height 4px + 20px bottom spacing)
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E9F6E),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E9F6E),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1E9E5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1E9E5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Hero block
        Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFE3ECFD),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppAssets.iconRefresh,
                  width: 34,
                  height: 34,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF2F6FED),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Validating backup',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F1714),
                  height: 28 / 22,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Checking schema version and checksums…',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF55625D),
                  height: 20 / 14,
                ),
              ),
              const SizedBox(height: 28),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1EE),
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 90,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F6FED),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 500),
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

  Widget _buildRestore4RestoringContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 4-step progress bar (height 4px + 20px bottom spacing) - all 4 green
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E9F6E),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E9F6E),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E9F6E),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E9F6E),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Hero block
        Padding(
          padding: const EdgeInsets.only(top: 32),
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
                  AppAssets.iconDownload,
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
                'Restoring your data',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F1714),
                  height: 28 / 22,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Reconnecting your registered sockets…',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF55625D),
                  height: 20 / 14,
                ),
              ),
              const SizedBox(height: 28),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1EE),
                  borderRadius: BorderRadius.circular(999),
                ),
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 160,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E9F6E),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 500),
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

  Widget _buildRestore5DoneContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFE2F1E8),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppAssets.iconCheck,
                  width: 34,
                  height: 34,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF2E9E5B),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Restore complete',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F1714),
                  height: 32 / 24,
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Your history is back and your sockets are reconnected. No duplicates were created.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF55625D),
                    height: 22 / 14,
                  ),
                ),
              ),
              const SizedBox(height: 32),
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
                    _buildReviewRow(
                      title: 'Sockets reconnected',
                      trailing: '3 of 3',
                    ),
                    Container(height: 1, color: const Color(0xFFE1E9E5)),
                    _buildReviewRow(
                      title: 'Duplicate batches skipped',
                      trailing: '12',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _status = BackupScreenStatus.connected;
                  });
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E9F6E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Go to dashboard',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 299),
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

  Widget _buildRestoreErrorNoBackupContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 32, 8, 0),
          child: Column(
            children: [
              // 80x80 hero circle #FBE6E6 with 34x34 AppAssets.iconAlert (#D64545)
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFFBE6E6),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppAssets.iconAlert,
                  width: 34,
                  height: 34,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFD64545),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'No SEMS backup found',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F1714),
                  height: 28 / 22,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'There is no SEMS folder in this Google account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF55625D),
                  height: 22 / 14,
                ),
              ),
              const SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _status = BackupScreenStatus.googleAccountChooser;
                      });
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E9F6E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Try another account',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _status = BackupScreenStatus.notConnected;
                      });
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE1E9E5),
                          width: 1,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Start fresh',
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
        ),
        const SizedBox(height: 416),
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

  Widget _buildRestoreErrorSchemaMismatchContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 32, 8, 0),
          child: Column(
            children: [
              // 80x80 hero circle #FBE6E6 with 34x34 AppAssets.iconAlert (#D64545)
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFFBE6E6),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  AppAssets.iconAlert,
                  width: 34,
                  height: 34,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFD64545),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Backup is from a newer app version',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F1714),
                  height: 28 / 22,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Update SEMS to restore this backup. Nothing was changed.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF55625D),
                  height: 22 / 14,
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Checking for updates… App is up to date.'),
                    ),
                  );
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                        color: const Color(0xFF0E9F6E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Check for updates',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 422),
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
