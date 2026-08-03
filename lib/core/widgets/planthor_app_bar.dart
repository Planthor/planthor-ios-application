import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';

class PlanthorAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PlanthorAppBar({
    super.key,
    this.showBack = false,
    this.onBack,
    this.onRefreshTap,
    this.onNotificationTap,
    this.onProfileTap,
    this.avatarUrl,
  });

  final bool showBack;
  final VoidCallback? onBack;
  final VoidCallback? onRefreshTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final String? avatarUrl;

  @override
  Size get preferredSize => const Size.fromHeight(75);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceCard,
        border: Border(
          bottom: BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 75,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                // ── Back button or brand ──
                if (showBack)
                  GestureDetector(
                    onTap: onBack ?? () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.planthorBlue,
                        size: 18,
                      ),
                    ),
                  ),

                // ── Brand name ──
                Text(
                  'Planthor',
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brandHeader,
                    letterSpacing: -0.3,
                  ),
                ),

                const Spacer(),

                if (onRefreshTap != null)
                  IconButton(
                    key: const Key('refresh-button'),
                    onPressed: onRefreshTap,
                    tooltip: 'Refresh',
                    icon: const Icon(
                      Icons.refresh,
                      color: AppColors.textSecondary,
                      size: 24,
                    ),
                  ),

                IconButton(
                  key: const Key('notifications-button'),
                  onPressed: onNotificationTap,
                  tooltip: 'Notifications',
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                ),

                GestureDetector(
                  key: const Key('profile-avatar'),
                  onTap: onProfileTap,
                  child: Semantics(
                    button: true,
                    label: 'Open profile',
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.metricSurface,
                      foregroundImage: avatarUrl == null || avatarUrl!.isEmpty
                          ? null
                          : NetworkImage(avatarUrl!),
                      child: const Icon(
                        Icons.person,
                        color: AppColors.inactive,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
