import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';
import 'package:planthor_ios_application/features/plans/domain/entities/personal_plan.dart';
import 'package:planthor_ios_application/features/plans/presentation/widgets/plan_progress_ring.dart';

/// Plan card — compact layout.
///
///  ┌──────────────────────────────────┐
///  │ Title                  [Details] │
///  │ Jan 1 – Dec 31                   │
///  │                                  │
///  │  56 / 100 km          [Ring 56%] │
///  │  40% ACHIEVED                    │
///  └──────────────────────────────────┘
class PlanCard extends StatelessWidget {
  const PlanCard({super.key, required this.plan, this.onTap});

  final PersonalPlan plan;
  final VoidCallback? onTap;

  bool get _isOverdue => plan.status == PlanStatus.overdue;
  bool get _isComplete => plan.progress >= 1.0 && !_isOverdue;

  Color get _accentColor {
    if (_isOverdue) return AppColors.planOverdue;
    if (_isComplete) return AppColors.achievementGreen;
    return AppColors.planthorBlue;
  }

  @override
  Widget build(BuildContext context) {
    final status = _isOverdue
        ? 'missed deadline'
        : '${plan.progressPercent} percent achieved';

    return Semantics(
      button: onTap != null,
      label: '${plan.name}, $status',
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.borderSubtle, width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A191C1E),
                blurRadius: 20,
                offset: Offset(0, 20),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top row: title + date + Details button ──
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
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textMain,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            plan.dateRange,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textMuted,
                              height: 1.33,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    _DetailsButton(onTap: onTap),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Bottom row: metric + status (left) | ring (right) ──
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _fmt(plan.current),
                                style: GoogleFonts.montserrat(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: _isOverdue
                                      ? AppColors.planOverdue
                                      : AppColors.textMain,
                                  height: 1.0,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '/ ${_fmt(plan.target)} ${plan.unit}',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textMuted,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              if (_isComplete) ...[
                                const SizedBox(width: 6),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Icon(
                                    Icons.check_circle,
                                    size: 18,
                                    color: AppColors.achievementGreen,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          if (_isOverdue)
                            const _StatusLabel(
                              text: 'MISSED DEADLINE',
                              color: AppColors.planOverdue,
                            )
                          else
                            _StatusLabel(
                              text: '${plan.progressPercent}% ACHIEVED',
                              color: _accentColor,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    PlanProgressRing(
                      progress: plan.progress,
                      icon: plan.icon,
                      size: 80,
                      isOverdue: _isOverdue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _fmt(double v) =>
      v == v.truncateToDouble() ? v.toInt().toString() : v.toString();
}

// ─────────────────────────────────────────────────────────────────────────────

class _DetailsButton extends StatelessWidget {
  const _DetailsButton({this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 64, minHeight: 44),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Details',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textMain,
          ),
        ),
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0.8,
      ),
    );
  }
}
