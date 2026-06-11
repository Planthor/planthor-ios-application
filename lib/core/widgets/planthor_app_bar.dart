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
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE8EAF0),
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
                        color: AppColors.planChip,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.planTextDark,
                        size: 16,
                      ),
                    ),
                  ),

                // ── Brand icon + name ──
                Text(
                  'Planthor',
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.planBlue,
                    letterSpacing: -0.5,
                  ),
                ),

                const Spacer(),

                // ── Notification bell ──
                GestureDetector(
                  onTap: onNotification ?? () {},
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.planChip,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.notifications_outlined,
                          color: AppColors.planTextSub,
                          size: 22,
                        ),
                        // Notification dot
                        Positioned(
                          top: 9,
                          right: 10,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.planOverdue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
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
