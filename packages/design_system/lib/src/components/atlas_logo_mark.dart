import 'package:flutter/material.dart';
import '../theme/atlas_colors.dart';

/// Renders the signature Atlas arc + dot mark from Nexus Chat Mock.html:
/// `<path d="M10 33a17 17 0 0 1 28 0" />` and `<circle cx="24" cy="35.5" r="2.6" />`
class AtlasLogoMark extends StatelessWidget {
  const AtlasLogoMark({
    super.key,
    this.size = 38,
    this.borderRadius = 11,
  });

  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.atlasColors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.text,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: CustomPaint(
        painter: _AtlasArcPainter(foreground: colors.bg),
      ),
    );
  }
}

class _AtlasArcPainter extends CustomPainter {
  const _AtlasArcPainter({required this.foreground});

  final Color foreground;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 48.0;
    final arcPaint = Paint()
      ..color = foreground
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.4 * scale
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(
      center: Offset(24 * scale, 33 * scale),
      radius: 14 * scale,
    );
    canvas.drawArc(rect, 3.14159265, 3.14159265, false, arcPaint);

    final dotPaint = Paint()
      ..color = foreground
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(24 * scale, 35.5 * scale),
      2.6 * scale,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _AtlasArcPainter oldDelegate) =>
      oldDelegate.foreground != foreground;
}
