import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/router/app_routes.dart';
import '../providers/login_providers.dart';
import '../providers/login_state.dart';
import '../widgets/app_logo.dart';
import '../widgets/biometric_login_section.dart';
import '../widgets/login_button.dart';
import '../widgets/login_email_field.dart';
import '../widgets/login_error_card.dart';
import '../widgets/login_password_field.dart';
import '../widgets/register_footer.dart';

final class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  static const double _maximumContentWidth = 400;
  static const double _horizontalPadding = 24;
  static const double _verticalPadding = 20;
  static const double _logoSize = 250;
  static const double _logoVerticalOffset = 24;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    final loginNotifier = ref.read(loginProvider.notifier);
    final theme = Theme.of(context);

    ref.listen<LoginState>(loginProvider, (previous, next) {
      final didLoginSucceed =
          previous?.status != LoginStatus.success &&
          next.status == LoginStatus.success;

      if (didLoginSucceed) {
        context.go(AppRoutes.startShift);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
                vertical: _verticalPadding,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - (_verticalPadding * 2),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _maximumContentWidth,
                    ),
                    child: AutofillGroup(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Transform.translate(
                            offset: const Offset(0, _logoVerticalOffset),
                            child: const Center(
                              child: AppLogo(size: _logoSize),
                            ),
                          ),
                          Text(
                            AppStrings.appName,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.loginDescription,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 32),
                          LoginEmailField(
                            enabled: !loginState.isLoading,
                            onChanged: loginNotifier.emailChanged,
                          ),
                          const SizedBox(height: 16),
                          LoginPasswordField(
                            password: loginState.password,
                            enabled: !loginState.isLoading,
                            isPasswordVisible: loginState.isPasswordVisible,
                            onChanged: loginNotifier.passwordChanged,
                            onVisibilityToggle:
                                loginNotifier.togglePasswordVisibility,
                            onSubmitted: (_) {
                              if (loginState.canSubmit) {
                                loginNotifier.login();
                              }
                            },
                          ),
                          RegisterFooter(
                            onForgotPasswordPressed: () {
                              context.push(AppRoutes.forgotPassword);
                            },
                            onRegisterPressed: () {
                              context.push(AppRoutes.register);
                            },
                          ),
                          if (loginState.errorMessage != null) ...[
                            const SizedBox(height: 8),
                            LoginErrorCard(message: loginState.errorMessage!),
                          ],
                          const SizedBox(height: 20),
                          LoginButton(
                            isLoading: loginState.isLoading,
                            isEnabled: loginState.canSubmit,
                            onPressed: loginNotifier.login,
                          ),
                          if (loginState.isBiometricAvailable) ...[
                            const SizedBox(height: 16),
                            BiometricLoginSection(
                              isAvailable: loginState.isBiometricAvailable,
                              supportsFaceAuthentication:
                                  loginState.supportsFaceAuthentication,
                              isLoading: loginState.isLoading,
                              onPressed: loginNotifier.loginWithBiometrics,
                            ),
                          ],
                          const SizedBox(height: 24),
                        ],
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
}
