import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';

enum PlanFilter { all, active, completed, overdue }

class PlanFilterTabs extends StatelessWidget {
  const PlanFilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
    this.counts,
  });

  final PlanFilter selected;
  final ValueChanged<PlanFilter> onChanged;

  /// Optional map of filter → count to display badges.
  final Map<PlanFilter, int>? counts;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: PlanFilter.values.map((filter) {
          final isSelected = filter == selected;
          final count = counts?[filter];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onChanged(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.planFilterActive
                      : AppColors.planFilterInactive,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      filter.label,
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : AppColors.planFilterText,
                      ),
                    ),
                    if (count != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.25)
                              : AppColors.planTextSub.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : AppColors.planFilterText,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

extension on PlanFilter {
  String get label {
    return switch (this) {
      PlanFilter.all => 'All',
      PlanFilter.active => 'Active',
      PlanFilter.completed => 'Completed',
      PlanFilter.overdue => 'Overdue',
    };
  }
}
