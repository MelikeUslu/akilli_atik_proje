import 'package:flutter/material.dart';

final class StartShiftButton extends StatelessWidget {
  const StartShiftButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.isEnabled,
  });

  static const Color _primaryGreen = Color(0xFF1B5E20);
  static const double _buttonHeight = 85;
  static const double _borderRadius = 200;

  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: _buttonHeight,
      child: FilledButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            return _primaryGreen;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            return Colors.white;
          }),
          elevation: const WidgetStatePropertyAll(2),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
            ),
          ),
        ),
        child: isLoading
            ? const SizedBox.square(
                dimension: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              )
            : const Text(
                'VARDİYA BAŞLAT',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
      ),
    );
  }
}
