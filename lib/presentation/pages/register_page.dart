import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';

final class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

final class _RegisterPageState extends State<RegisterPage> {
  static const double _maximumContentWidth = 430;

  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isPasswordConfirmationVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _maximumContentWidth,
                    ),
                    child: Form(
                      key: _formKey,
                      child: AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 12),
                            Icon(
                              Icons.person_add_alt_1_rounded,
                              size: 72,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Hesap Oluştur',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Hesap bilgilerinizi girin.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 32),
                            TextFormField(
                              controller: _fullNameController,
                              autofillHints: const [AutofillHints.name],
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Ad Soyad',
                                prefixIcon: Icon(Icons.person_outline_rounded),
                              ),
                              validator: _validateFullName,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              autofillHints: const [AutofillHints.email],
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autocorrect: false,
                              decoration: const InputDecoration(
                                labelText: 'E-posta',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: _validateEmail,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              autofillHints: const [AutofillHints.newPassword],
                              obscureText: !_isPasswordVisible,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Şifre',
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                              ),
                              validator: _validatePassword,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordConfirmationController,
                              autofillHints: const [AutofillHints.newPassword],
                              obscureText: !_isPasswordConfirmationVisible,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                labelText: 'Şifre Tekrar',
                                prefixIcon: const Icon(
                                  Icons.lock_reset_rounded,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordConfirmationVisible =
                                          !_isPasswordConfirmationVisible;
                                    });
                                  },
                                  icon: Icon(
                                    _isPasswordConfirmationVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                              ),
                              validator: _validatePasswordConfirmation,
                            ),
                            const SizedBox(height: 24),
                            FilledButton(
                              onPressed: _handleRegisterPressed,
                              child: const Text('Kayıt Ol'),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                context.go(AppRoutes.login);
                              },
                              child: const Text(
                                'Zaten hesabın var mı? Giriş Yap',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleRegisterPressed() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Kayıt servisi backend sözleşmesi bekleniyor.'),
        ),
      );
  }

  String? _validateFullName(String? value) {
    final normalizedValue = value?.trim() ?? '';

    if (normalizedValue.isEmpty) {
      return 'Ad soyad boş bırakılamaz.';
    }

    if (normalizedValue.length < 2) {
      return 'Geçerli bir ad soyad girin.';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final normalizedValue = value?.trim() ?? '';

    if (normalizedValue.isEmpty) {
      return 'E-posta boş bırakılamaz.';
    }

    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailPattern.hasMatch(normalizedValue)) {
      return 'Geçerli bir e-posta adresi girin.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final normalizedValue = value ?? '';

    if (normalizedValue.isEmpty) {
      return 'Şifre boş bırakılamaz.';
    }

    if (normalizedValue.length < 8) {
      return 'Şifre en az 8 karakter olmalıdır.';
    }

    return null;
  }

  String? _validatePasswordConfirmation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre tekrarı boş bırakılamaz.';
    }

    if (value != _passwordController.text) {
      return 'Şifreler eşleşmiyor.';
    }

    return null;
  }
}
