import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/personal_plan.dart';

class PlanStatusBadge extends StatelessWidget {
  const PlanStatusBadge({super.key, required this.status});

  final PlanStatus status;

  @override
  Widget build(BuildContext context) {
    final (bgColor, fgColor, iconData) = _statusStyle(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 12, color: fgColor),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fgColor,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  static (Color bg, Color fg, IconData icon) _statusStyle(PlanStatus status) {
    return switch (status) {
      PlanStatus.active => (
          AppColors.planActiveLight,
          AppColors.planBlueDark,
          Icons.play_circle_outline,
        ),
      PlanStatus.completed => (
          AppColors.planGreenLight,
          AppColors.planGreen,
          Icons.check_circle_outline,
        ),
      PlanStatus.overdue => (
          AppColors.planOverdueLight,
          AppColors.planOverdue,
          Icons.warning_amber_rounded,
        ),
      PlanStatus.upcoming => (
          AppColors.planUpcomingLight,
          AppColors.planUpcoming,
          Icons.schedule,
        ),
    };
  }
}
