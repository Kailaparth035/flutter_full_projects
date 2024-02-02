import 'package:flutter/widgets.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1

    Paint paintFill = Paint()
      ..color = const Color.fromARGB(255, 228, 199, 46)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(size.width * 0.1666667, size.height * 0.0100000);
    path_0.lineTo(size.width, 0);
    path_0.lineTo(size.width * 1.0033333, size.height);
    path_0.lineTo(size.width * 0.1666667, size.height);
    path_0.lineTo(0, size.height * 0.5000000);
    path_0.lineTo(size.width * 0.1666667, size.height * 0.0100000);
    path_0.close();

    canvas.drawPath(path_0, paintFill);

    // Layer 1

    Paint paintStroke0 = Paint()
      ..color = const Color.fromARGB(255, 228, 199, 46)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path_0, paintStroke0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
