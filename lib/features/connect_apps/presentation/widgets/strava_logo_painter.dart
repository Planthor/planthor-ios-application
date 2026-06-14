import 'package:flutter/material.dart';

/// Custom painter that draws the Strava logo SVG path.
///
/// The path is scaled to fit within the given [size].
class StravaLogoPainter extends CustomPainter {
  const StravaLogoPainter({this.color = Colors.white});

  final Color color;

  // Original Strava SVG path data (viewBox 0 0 24 24).
  static final Path _stravaPath = _buildPath();

  static Path _buildPath() {
    return Path()
      // Upper part
      ..moveTo(15.387, 17.944)
      ..lineTo(13.298, 13.828)
      ..lineTo(10.233, 13.828)
      ..lineTo(15.387, 24)
      ..lineTo(20.537, 13.828)
      ..lineTo(17.471, 13.828)
      ..close()
      // Lower part
      ..moveTo(8.379, 8.229)
      ..lineTo(11.215, 13.827)
      ..lineTo(15.387, 13.827)
      ..lineTo(10.463, 0)
      ..lineTo(3.463, 13.828)
      ..lineTo(7.632, 13.828)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Scale path from 24x24 viewBox to actual size.
    final scaleX = size.width / 24;
    final scaleY = size.height / 24;
    final matrix = Matrix4.diagonal3Values(scaleX, scaleY, 1.0);

    canvas.drawPath(_stravaPath.transform(matrix.storage), paint);
  }

  @override
  bool shouldRepaint(covariant StravaLogoPainter oldDelegate) =>
      color != oldDelegate.color;
}

/// Convenience widget wrapping the Strava logo painter.
class StravaLogo extends StatelessWidget {
  const StravaLogo({
    super.key,
    this.size = 32,
    this.color = Colors.white,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: StravaLogoPainter(color: color),
    );
  }
}
