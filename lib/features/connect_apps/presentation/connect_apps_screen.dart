import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';
import 'package:planthor_ios_application/core/widgets/planthor_app_bar.dart';
import 'package:planthor_ios_application/features/connect_apps/presentation/widgets/strava_logo_painter.dart';
import 'package:planthor_ios_application/features/connect_apps/providers/strava_connection_provider.dart';

/// "Connect to Apps" screen showing Strava integration card with three states:
/// Not Connected, Connecting, and Connected.
///
/// Matches the Stitch design screens:
///   - Connect to Apps - Strava Not Connected (Updated Style)
///   - Connect to Apps - Strava Connecting (Updated Style)
///   - Connect to Apps - Strava Connected (Updated Style)
class ConnectAppsScreen extends ConsumerWidget {
  const ConnectAppsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(stravaConnectionProvider);

    return Scaffold(
      appBar: const PlanthorAppBar(showBack: true),
      backgroundColor: AppColors.surfaceBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ──
            _HeaderRow(status: status),
            const SizedBox(height: 24),

            // ── Strava integration card ──
            _StravaCard(status: status),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header row: title + optional status badge
// ─────────────────────────────────────────────────────────────────────────────

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.status});

  final StravaConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Connect to apps',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryDark,
          ),
        ),
        const Spacer(),
        if (status == StravaConnectionStatus.disconnected) _NotConnectedBadge(),
      ],
    );
  }
}

class _NotConnectedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.errorContainerLight,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.link_off,
            size: 14,
            color: AppColors.onErrorContainerDark,
          ),
          const SizedBox(width: 4),
          Text(
            'NOT CONNECTED',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.onErrorContainerDark,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Strava integration card
// ─────────────────────────────────────────────────────────────────────────────

class _StravaCard extends ConsumerWidget {
  const _StravaCard({required this.status});

  final StravaConnectionStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnecting = status == StravaConnectionStatus.connecting;
    final isConnected = status == StravaConnectionStatus.connected;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Card content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Strava icon ──
                    _StravaIcon(isConnected: isConnected),
                    const SizedBox(width: 16),
                    // ── Text content ──
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Connected status label
                          if (isConnected) ...[
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.achievementGreen,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'CONNECTED',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.achievementGreen,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                          ],
                          Text(
                            'Strava',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMain,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Connect to sync your activities automatically.',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textMuted,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Action button ──
                _ActionButton(status: status),
              ],
            ),
          ),

          // ── Connecting overlay ──
          if (isConnecting)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Strava icon with optional connected checkmark
// ─────────────────────────────────────────────────────────────────────────────

class _StravaIcon extends StatelessWidget {
  const _StravaIcon({required this.isConnected});

  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.stravaOrange,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: StravaLogo(size: 32, color: Colors.white),
            ),
          ),
          if (isConnected)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: AppColors.achievementGreen,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.surfaceCard,
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Action button — CONNECT / CONNECTING / DISCONNECT
// ─────────────────────────────────────────────────────────────────────────────

class _ActionButton extends ConsumerWidget {
  const _ActionButton({required this.status});

  final StravaConnectionStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (status) {
      case StravaConnectionStatus.disconnected:
        return _buildConnectButton(ref);
      case StravaConnectionStatus.connecting:
        return _buildConnectingButton();
      case StravaConnectionStatus.connected:
        return _buildDisconnectButton(ref);
    }
  }

  Widget _buildConnectButton(WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () =>
            ref.read(stravaConnectionProvider.notifier).connect(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.planthorBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: AppColors.planthorBlue.withValues(alpha: 0.3),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        child: Text(
          'CONNECT',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  Widget _buildConnectingButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          disabledBackgroundColor: AppColors.primaryDark,
          disabledForegroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'CONNECTING...',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisconnectButton(WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () =>
            ref.read(stravaConnectionProvider.notifier).disconnect(),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textMain,
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: const BorderSide(color: AppColors.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        child: Text(
          'DISCONNECT',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
