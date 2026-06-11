import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';

/// Placeholder screen for the Community tab.
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF0F2F5),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.planActiveLight,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.people_outline,
                  size: 36,
                  color: AppColors.planBlueDark,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Community',
                style: GoogleFonts.montserrat(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.planTextDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Connect with fellow plant enthusiasts and share your journey.',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.planTextSub,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.planChip,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Coming Soon',
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.planTextSub,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
