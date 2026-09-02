import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({
    super.key,
    required this.onRegisterPressed,
    required this.onForgotPasswordPressed,
  });

  final VoidCallback onRegisterPressed;
  final VoidCallback onForgotPasswordPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onForgotPasswordPressed,
            child: const Text(AppStrings.forgotPassword),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(AppStrings.noAccount),
            TextButton(
              onPressed: onRegisterPressed,
              child: const Text(
                AppStrings.register,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
