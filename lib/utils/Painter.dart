import "package:flutter/material.dart";
import 'dart:math';

class CircleProgressPainter extends CustomPainter {
  final double percentage; // e.g., 68 for 68%

  CircleProgressPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 5;

    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    final foregroundPaint = Paint()
      ..color = const Color.fromARGB(255, 16, 73, 231)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    // Draw background circle
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw progress arc
    double sweepAngle = 2 * pi * (percentage / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // start from top
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}