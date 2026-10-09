import 'dart:math';
import 'package:flutter/material.dart';

/// Painter that draws subtle starry diamond sparkle glints and ambient bokeh glows.
class DiamondSparklePainter extends CustomPainter {
  final double animationValue;

  DiamondSparklePainter({this.animationValue = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Fixed sparkle positions (relative coordinates)
    const sparkles = [
      _Sparkle(0.12, 0.18, 14, Color(0xFF60A5FA), 0.55),
      _Sparkle(0.24, 0.10, 18, Color(0xFF93C5FD), 0.70),
      _Sparkle(0.08, 0.42, 10, Color(0xFF38BDF8), 0.45),
      _Sparkle(0.18, 0.78, 16, Color(0xFF818CF8), 0.60),
      _Sparkle(0.85, 0.15, 14, Color(0xFF60A5FA), 0.50),
      _Sparkle(0.92, 0.35, 20, Color(0xFF93C5FD), 0.65),
      _Sparkle(0.88, 0.75, 12, Color(0xFF38BDF8), 0.40),
      _Sparkle(0.80, 0.88, 16, Color(0xFF818CF8), 0.55),
      _Sparkle(0.05, 0.90, 12, Color(0xFF60A5FA), 0.35),
    ];

    for (final s in sparkles) {
      final center = Offset(s.x * w, s.y * h);
      _drawGlint(canvas, center, s.size, s.color.withValues(alpha: s.opacity));
    }
  }

  void _drawGlint(Canvas canvas, Offset center, double size, Color color) {
    // 1. Soft radial glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [color, color.withValues(alpha: 0.0)],
      ).createShader(Rect.fromCircle(center: center, radius: size * 1.5));
    canvas.drawCircle(center, size * 1.5, glowPaint);

    // 2. Cross 4-point star glint
    final starPaint = Paint()
      ..color = Colors.white.withValues(alpha: min(1.0, color.a * 1.3))
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    // Horizontal beam
    canvas.drawLine(
      Offset(center.dx - size, center.dy),
      Offset(center.dx + size, center.dy),
      starPaint,
    );
    // Vertical beam
    canvas.drawLine(
      Offset(center.dx, center.dy - size),
      Offset(center.dx, center.dy + size),
      starPaint,
    );
    // Center bright dot
    canvas.drawCircle(
      center,
      1.5,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant DiamondSparklePainter oldDelegate) => false;
}

class _Sparkle {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double opacity;

  const _Sparkle(this.x, this.y, this.size, this.color, this.opacity);
}
