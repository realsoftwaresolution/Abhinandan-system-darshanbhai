import 'package:flutter/material.dart';

/// A scalable vector faceted brilliant-cut diamond logo widget.
class DiamondLogo extends StatelessWidget {
  final double size;
  final Color primaryColor;
  final Color accentColor;
  final Color outlineColor;

  const DiamondLogo({
    super.key,
    this.size = 40,
    this.primaryColor = const Color(0xFF1D4ED8), // Royal Blue
    this.accentColor = const Color(0xFF93C5FD),  // Light Blue / Highlight
    this.outlineColor = const Color(0xFFE2E8F0),
  });

  /// Dark theme / hero banner variant (white outline, cyan/blue facet accents)
  factory DiamondLogo.lightOnDark({double size = 44}) {
    return DiamondLogo(
      size: size,
      primaryColor: const Color(0xFF60A5FA),
      accentColor: const Color(0xFFBFDBFE),
      outlineColor: Colors.white,
    );
  }

  /// Light theme variant (navy & royal blue on white background)
  factory DiamondLogo.blueOnLight({double size = 40}) {
    return DiamondLogo(
      size: size,
      primaryColor: const Color(0xFF1E40AF),
      accentColor: const Color(0xFF3B82F6),
      outlineColor: const Color(0xFF1E3A8A),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.85,
      child: CustomPaint(
        painter: _FacetedDiamondPainter(
          primaryColor: primaryColor,
          accentColor: accentColor,
          outlineColor: outlineColor,
        ),
      ),
    );
  }
}

class _FacetedDiamondPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;
  final Color outlineColor;

  _FacetedDiamondPainter({
    required this.primaryColor,
    required this.accentColor,
    required this.outlineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Key geometric vertices
    // Top table vertices
    final pT1 = Offset(w * 0.22, h * 0.05);
    final pT2 = Offset(w * 0.40, h * 0.05);
    final pT3 = Offset(w * 0.60, h * 0.05);
    final pT4 = Offset(w * 0.78, h * 0.05);

    // Girdle (widest edge)
    final pG0 = Offset(w * 0.03, h * 0.38);
    final pG1 = Offset(w * 0.28, h * 0.38);
    final pG2 = Offset(w * 0.50, h * 0.38);
    final pG3 = Offset(w * 0.72, h * 0.38);
    final pG4 = Offset(w * 0.97, h * 0.38);

    // Culet (bottom point)
    final pBottom = Offset(w * 0.50, h * 0.96);

    final linePaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    void drawFacet(List<Offset> points, Color color) {
      final path = Path()..moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      path.close();

      final fillPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, linePaint);
    }

    // 1. Crown Facets
    drawFacet([pT2, pT3, pG2], accentColor.withValues(alpha: 0.85));
    drawFacet([pT1, pT2, pG2, pG1], primaryColor.withValues(alpha: 0.75));
    drawFacet([pT3, pT4, pG3, pG2], primaryColor.withValues(alpha: 0.90));
    drawFacet([pT1, pG1, pG0], primaryColor.withValues(alpha: 0.60));
    drawFacet([pT4, pG4, pG3], primaryColor.withValues(alpha: 0.95));

    // 2. Pavilion Facets (converging to bottom point)
    drawFacet([pG0, pG1, pBottom], primaryColor.withValues(alpha: 0.70));
    drawFacet([pG1, pG2, pBottom], accentColor.withValues(alpha: 0.80));
    drawFacet([pG2, pG3, pBottom], primaryColor.withValues(alpha: 0.85));
    drawFacet([pG3, pG4, pBottom], primaryColor.withValues(alpha: 0.95));

    // Outer perimeter line highlight
    final outerPath = Path()
      ..moveTo(pT1.dx, pT1.dy)
      ..lineTo(pT4.dx, pT4.dy)
      ..lineTo(pG4.dx, pG4.dy)
      ..lineTo(pBottom.dx, pBottom.dy)
      ..lineTo(pG0.dx, pG0.dy)
      ..close();

    final outerPaint = Paint()
      ..color = outlineColor.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(outerPath, outerPaint);
  }

  @override
  bool shouldRepaint(covariant _FacetedDiamondPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.outlineColor != outlineColor;
  }
}
