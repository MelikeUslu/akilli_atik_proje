import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';

final class LoginPasswordField extends StatelessWidget {
  const LoginPasswordField({
    super.key,
    required this.password,
    required this.onChanged,
    required this.isPasswordVisible,
    required this.onVisibilityToggle,
    this.onSubmitted,
    this.enabled = true,
  });

  static const int _minimumPasswordLength = 6;

  final String password;
  final ValueChanged<String> onChanged;
  final bool isPasswordVisible;
  final VoidCallback onVisibilityToggle;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  bool get _hasValidLength {
    return password.length >= _minimumPasswordLength;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return TextField(
      enabled: enabled,
      obscureText: !isPasswordVisible,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      autocorrect: false,
      enableSuggestions: false,
      autofillHints: const [AutofillHints.password],
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: AppStrings.password,
        hintText: AppStrings.passwordHint,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          onPressed: enabled ? onVisibilityToggle : null,
          tooltip: isPasswordVisible ? 'Şifreyi gizle' : 'Şifreyi göster',
          icon: Icon(
            isPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        ),
        helper: Row(
          children: [
            Icon(
              _hasValidLength ? Icons.check_circle_outline : Icons.info_outline,
              size: 16,
              color: _hasValidLength
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              _hasValidLength
                  ? AppStrings.passwordRequirementMet
                  : AppStrings.passwordRequirement,
              style: textTheme.bodySmall?.copyWith(
                color: _hasValidLength
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(28)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}
