import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';

/// Circular progress ring used in plan cards.
///
/// Color coding:
/// - Overdue  → error red (#B31B25)
/// - Complete (≥100%) → achievement green (#34D399)
/// - Active (<100%) → Planthor blue (#18A0FB)
///
/// The track uses a 15% opacity version of the active color.
class PlanProgressRing extends StatelessWidget {
  const PlanProgressRing({
    super.key,
    required this.progress,
    required this.icon,
    this.size = 80,
    this.isOverdue = false,
  });

  final double progress; // 0.0–1.0+ (clamped for drawing)
  final IconData icon;
  final double size;
  final bool isOverdue;

  Color get _ringColor {
    if (isOverdue) return AppColors.planOverdue;
    if (progress >= 1.0) return AppColors.achievementGreen;
    return AppColors.planthorBlue;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          progress: progress,
          color: _ringColor,
          isOverdue: isOverdue,
        ),
        child: Center(
          child: Icon(icon, size: size * 0.32, color: _ringColor),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.progress,
    required this.color,
    required this.isOverdue,
  });

  final double progress;
  final Color color;
  final bool isOverdue;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8) / 2;
    const strokeWidth = 6.0;

    // Track — 15% opacity of active color
    final trackPaint = Paint()
      ..color = color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    final clampedProgress = progress.clamp(0.0, 1.0);
    if (clampedProgress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * clampedProgress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.isOverdue != isOverdue;
}
