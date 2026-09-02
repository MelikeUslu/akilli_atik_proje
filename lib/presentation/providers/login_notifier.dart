import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_strings.dart';
import '../../domain/usecases/biometric_login_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import 'login_state.dart';

final class LoginNotifier extends Notifier<LoginState> {
  LoginNotifier({
    required this.loginUseCase,
    required this.biometricLoginUseCase,
  });

  static const int _maximumFailedAttempts = 3;
  static const Duration _lockDuration = Duration(minutes: 5);

  final LoginUseCase loginUseCase;
  final BiometricLoginUseCase biometricLoginUseCase;

  @override
  LoginState build() {
    Future.microtask(_initializeBiometrics);

    return const LoginState();
  }

  void emailChanged(String value) {
    state = state.copyWith(
      email: value,
      status: LoginStatus.initial,
      errorMessage: null,
    );
  }

  void passwordChanged(String value) {
    state = state.copyWith(
      password: value,
      status: LoginStatus.initial,
      errorMessage: null,
    );
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  Future<void> login() async {
    if (state.isLoading) {
      return;
    }

    if (_refreshLockStatus()) {
      return;
    }

    if (!state.isFormValid) {
      state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: AppStrings.loginFailed,
      );
      return;
    }

    state = state.copyWith(status: LoginStatus.loading, errorMessage: null);

    try {
      final user = await loginUseCase(
        email: state.email,
        password: state.password,
      );

      state = state.copyWith(
        status: LoginStatus.success,
        authenticatedUser: user,
        failedAttempts: 0,
        lockedUntil: null,
        errorMessage: null,
      );
    } catch (_) {
      _registerFailedAttempt();
    }
  }

  Future<void> loginWithBiometrics() async {
    if (state.isLoading || !state.isBiometricAvailable) {
      return;
    }

    if (_refreshLockStatus()) {
      return;
    }

    state = state.copyWith(status: LoginStatus.loading, errorMessage: null);

    try {
      final isAuthenticated = await biometricLoginUseCase.authenticate();

      if (!isAuthenticated) {
        state = state.copyWith(
          status: LoginStatus.failure,
          errorMessage: AppStrings.loginFailed,
        );
        return;
      }

      state = state.copyWith(
        status: LoginStatus.success,
        failedAttempts: 0,
        lockedUntil: null,
        errorMessage: null,
      );
    } catch (_) {
      state = state.copyWith(
        status: LoginStatus.failure,
        errorMessage: AppStrings.loginFailed,
      );
    }
  }

  void clearError() {
    state = state.copyWith(status: LoginStatus.initial, errorMessage: null);
  }

  Future<void> _initializeBiometrics() async {
    try {
      final results = await Future.wait<bool>([
        biometricLoginUseCase.isAvailable(),
        biometricLoginUseCase.supportsFingerprint(),
        biometricLoginUseCase.supportsFaceAuthentication(),
      ]);

      state = state.copyWith(
        isBiometricAvailable: results[0],
        supportsFingerprint: results[1],
        supportsFaceAuthentication: results[2],
      );
    } catch (_) {
      state = state.copyWith(
        isBiometricAvailable: false,
        supportsFingerprint: false,
        supportsFaceAuthentication: false,
      );
    }
  }

  void _registerFailedAttempt() {
    final failedAttempts = state.failedAttempts + 1;

    if (failedAttempts >= _maximumFailedAttempts) {
      state = state.copyWith(
        status: LoginStatus.locked,
        failedAttempts: failedAttempts,
        lockedUntil: DateTime.now().add(_lockDuration),
        errorMessage: AppStrings.accountLocked,
      );
      return;
    }

    state = state.copyWith(
      status: LoginStatus.failure,
      failedAttempts: failedAttempts,
      errorMessage: AppStrings.loginFailed,
    );
  }

  bool _refreshLockStatus() {
    if (!state.isLocked) {
      if (state.lockedUntil != null) {
        state = state.copyWith(
          status: LoginStatus.initial,
          failedAttempts: 0,
          lockedUntil: null,
          errorMessage: null,
        );
      }

      return false;
    }

    state = state.copyWith(
      status: LoginStatus.locked,
      errorMessage: AppStrings.accountLocked,
    );

    return true;
  }
}
