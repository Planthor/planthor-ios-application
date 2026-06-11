import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';
import 'package:planthor_ios_application/features/auth/presentation/providers/auth_provider.dart';

/// Profile / Settings screen for the Profile tab.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColoredBox(
      color: const Color(0xFFF0F2F5),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          children: [
            // ── Avatar section ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A191C1E),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF2C2C2E),
                      border: Border.all(
                        color: AppColors.planBlue.withValues(alpha: 0.3),
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white70,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'My Profile',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.planTextDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage your account settings',
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.planTextSub,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Menu items ──
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A191C1E),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _MenuItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () {},
                    showTopBorder: false,
                  ),
                  _MenuItem(
                    icon: Icons.help_outline,
                    label: 'Help & Support',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.info_outline,
                    label: 'About',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.logout,
                    label: 'Sign Out',
                    color: AppColors.planOverdue,
                    onTap: () => ref.read(authProvider.notifier).signOut(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.showTopBorder = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final bool showTopBorder;

  @override
  Widget build(BuildContext context) {
    final itemColor = color ?? AppColors.planTextDark;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: showTopBorder
              ? const Border(
                  top: BorderSide(color: Color(0xFFF0F2F5), width: 1),
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: itemColor),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: itemColor,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.planTextSub.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
