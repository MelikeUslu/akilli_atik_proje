import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';

class BiometricLoginSection extends StatelessWidget {
  const BiometricLoginSection({
    super.key,
    required this.isAvailable,
    required this.supportsFaceAuthentication,
    required this.isLoading,
    required this.onPressed,
  });

  final bool isAvailable;
  final bool supportsFaceAuthentication;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (!isAvailable) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: Icon(
          supportsFaceAuthentication ? Icons.face_outlined : Icons.fingerprint,
        ),
        label: const Text(AppStrings.biometricLogin),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1B5E20),
          side: const BorderSide(color: Color(0xFF1B5E20)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
    );
  }
}
