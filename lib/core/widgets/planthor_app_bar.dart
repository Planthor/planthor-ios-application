import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';

class PlanthorAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PlanthorAppBar({
    super.key,
    this.showBack = false,
    this.onBack,
    this.onNotification,
    this.avatarUrl,
  });

  final bool showBack;
  final VoidCallback? onBack;
  final VoidCallback? onNotification;
  final String? avatarUrl;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceCard,
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderSubtle,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.planthorBlue,
                    letterSpacing: -0.3,
                  ),
                ),

                const Spacer(),

                // ── Notification bell ──
                GestureDetector(
                  onTap: onNotification ?? () {},
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textMuted,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // ── User avatar ──
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceContainer,
                      border: Border.all(
                        color: AppColors.borderSubtle,
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: avatarUrl != null
                          ? Image.network(
                              avatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const Icon(
                                Icons.person,
                                size: 18,
                                color: AppColors.textMuted,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 18,
                              color: AppColors.textMuted,
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
