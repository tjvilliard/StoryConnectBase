import 'package:flutter/widgets.dart';

class CustomHighlightPainter extends CustomPainter {
  final List<Rect> rects;
  final Color color;
  final double scale;

  CustomHighlightPainter(
      {required this.rects, required this.color, required this.scale});

  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (final rect in rects) {
      final center = rect.center.translate(0, 5);

      final scaledRect = Rect.fromCenter(
        center: center,
        width: rect.width * scale,
        height: rect.height * scale,
      );

      final radius = Radius.circular(8); // set the corner radius
      final roundedRect = RRect.fromRectAndRadius(scaledRect, radius);

      canvas.drawRRect(roundedRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
