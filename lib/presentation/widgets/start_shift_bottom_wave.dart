import 'package:flutter/material.dart';

final class StartShiftBottomWave extends StatelessWidget {
  const StartShiftBottomWave({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 90,
      child: CustomPaint(painter: _BottomWavePainter()),
    );
  }
}

final class _BottomWavePainter extends CustomPainter {
  const _BottomWavePainter();

  static const Color _lightGreen = Color(0xFF81C784);
  static const Color _darkGreen = Color(0xFF1B5E20);

  @override
  void paint(Canvas canvas, Size size) {
    final lightPaint = Paint()
      ..color = _lightGreen.withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;

    final darkPaint = Paint()
      ..color = _darkGreen.withValues(alpha: 0.75)
      ..style = PaintingStyle.fill;

    final lightPath = Path()
      ..moveTo(0, size.height * 0.48)
      ..cubicTo(
        size.width * 0.20,
        size.height * 0.15,
        size.width * 0.36,
        size.height * 0.80,
        size.width * 0.58,
        size.height * 0.50,
      )
      ..cubicTo(
        size.width * 0.75,
        size.height * 0.25,
        size.width * 0.88,
        size.height * 0.30,
        size.width,
        size.height * 0.18,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final darkPath = Path()
      ..moveTo(0, size.height * 0.65)
      ..cubicTo(
        size.width * 0.20,
        size.height * 0.35,
        size.width * 0.40,
        size.height * 0.90,
        size.width * 0.60,
        size.height * 0.62,
      )
      ..cubicTo(
        size.width * 0.76,
        size.height * 0.42,
        size.width * 0.90,
        size.height * 0.55,
        size.width,
        size.height * 0.38,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(lightPath, lightPaint);
    canvas.drawPath(darkPath, darkPaint);
  }

  @override
  bool shouldRepaint(covariant _BottomWavePainter oldDelegate) {
    return false;
  }
}
