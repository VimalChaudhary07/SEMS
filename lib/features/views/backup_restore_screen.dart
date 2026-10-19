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
  });

  final BackupScreenStatus status;
  final Widget? bottomNavigationBar;
  final VoidCallback? onBack;

  @override
  State<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends State<BackupRestoreScreen> {
  late BackupScreenStatus _status;

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
              padding: const EdgeInsets.only(left: 8, right: 16),
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
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                child: Column(
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
                ),
              ),
            ),
          ],
        ),
      ),
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
              onPressed: () {},
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
        onPressed: () {},
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
