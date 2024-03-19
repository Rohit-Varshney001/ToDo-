import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white54 // Adjust color as needed
      ..strokeWidth = 1; // Adjust stroke width as needed

    double dashWidth = 5; // Adjust dash width as needed
    double dashSpace = 3; // Adjust space between dashes as needed

    double startX = 0;
    double endX = size.width;

    while (startX < endX) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
