import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/personal_plan.dart';
import 'package:planthor_ios_application/features/plans/presentation/widgets/plan_progress_bar.dart';
import 'package:planthor_ios_application/features/plans/presentation/widgets/plan_progress_ring.dart';
import 'package:planthor_ios_application/features/plans/presentation/widgets/plan_status_badge.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({super.key, required this.plan, this.onTap});

  final PersonalPlan plan;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final progressColor =
        plan.isComplete ? AppColors.planGreen : AppColors.planBlueDark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D191C1E),
              blurRadius: 24,
              offset: Offset(0, 8),
              spreadRadius: -4,
            ),
            BoxShadow(
              color: Color(0x05191C1E),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Status badge + icon row ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PlanStatusBadge(status: plan.status),
                      _ActionMenu(plan: plan),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ── Title + progress ring ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan.name,
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.planTextDark,
                                height: 1.35,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 13,
                                  color: AppColors.planTextSub,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  plan.dateRange,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.planTextSub,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      PlanProgressRing(
                          progress: plan.progress, icon: plan.icon),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // ── Progress stats row ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: _fmt(plan.current),
                                    style: GoogleFonts.montserrat(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.planTextDark,
                                      height: 1.1,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' / ${_fmt(plan.target)}',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.planTextSub,
                                      height: 1.1,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ${plan.unit}',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.planTextSub,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${plan.progressPercent}% ACHIEVED',
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: progressColor,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _DetailsButton(
                        isComplete: plan.isComplete,
                        onTap: onTap,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),

            // ── Bottom progress bar (full width, flush with card bottom) ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: PlanProgressBar(progress: plan.progress),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(double v) =>
      v == v.truncateToDouble() ? v.toInt().toString() : v.toString();
}

class _ActionMenu extends StatelessWidget {
  const _ActionMenu({required this.plan});
  final PersonalPlan plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: AppColors.planChip,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.more_horiz,
        size: 16,
        color: AppColors.planTextSub,
      ),
    );
  }
}

class _DetailsButton extends StatelessWidget {
  const _DetailsButton({required this.isComplete, this.onTap});
  final bool isComplete;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isComplete ? AppColors.planGreenLight : AppColors.planActiveLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Details',
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color:
                    isComplete ? AppColors.planGreen : AppColors.planBlueDark,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios,
              size: 11,
              color:
                  isComplete ? AppColors.planGreen : AppColors.planBlueDark,
            ),
          ],
        ),
      ),
    );
  }
}
