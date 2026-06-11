import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:planthor_ios_application/core/theme/app_colors.dart';

class PlanProgressRing extends StatelessWidget {
  const PlanProgressRing({
    super.key,
    required this.progress,
    required this.icon,
    this.size = 80,
  });

  final double progress; // 0.0–1.0 (clamped)
  final IconData icon;
  final double size;

  Color get _ringColor =>
      progress >= 1.0 ? AppColors.planGreen : AppColors.planBlueDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(progress: progress, color: _ringColor),
        child: Center(
          child: Icon(icon, size: size * 0.32, color: _ringColor),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8) / 2;
    const strokeWidth = 6.0;

    final trackPaint = Paint()
      ..color = AppColors.planChip
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
