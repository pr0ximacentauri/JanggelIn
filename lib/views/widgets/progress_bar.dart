import 'package:flutter/material.dart';
import 'dart:math';

class ArcProgressBar extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final Color color;
  final double strokeWidth;

  const ArcProgressBar({
    super.key,
    required this.progress,
    required this.color,
    this.strokeWidth = 10,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(150, 150), 
      painter: ArcPainter(progress, color, strokeWidth),
    );
  }
}

class ArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  ArcPainter(this.progress, this.color, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint trackPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
      trackPaint,
    );


    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
