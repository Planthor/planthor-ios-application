import 'package:flutter/material.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';

class PlanProgressBar extends StatelessWidget {
  const PlanProgressBar({
    super.key,
    required this.progress,
    this.height = 6,
    this.activeColor,
    this.trackColor,
  });

  /// Progress value from 0.0 to 1.0 (clamped internally).
  final double progress;

  /// Height of the progress bar.
  final double height;

  /// Override color for the filled portion.
  final Color? activeColor;

  /// Override color for the track.
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final fillColor = activeColor ??
        (clampedProgress >= 1.0 ? AppColors.planGreen : AppColors.planBlueDark);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final fillWidth = totalWidth * clampedProgress;

        return Container(
          height: height,
          decoration: BoxDecoration(
            color: trackColor ?? AppColors.planProgressTrack,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              width: fillWidth,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    fillColor,
                    fillColor.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        );
      },
    );
  }
}
