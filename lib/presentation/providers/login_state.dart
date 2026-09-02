import '../../core/utils/input_validators.dart';
import '../../domain/entities/authenticated_user.dart';

enum LoginStatus { initial, loading, success, failure, locked }

final class LoginState {
  const LoginState({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.status = LoginStatus.initial,
    this.errorMessage,
    this.failedAttempts = 0,
    this.lockedUntil,
    this.authenticatedUser,
    this.isBiometricAvailable = false,
    this.supportsFingerprint = false,
    this.supportsFaceAuthentication = false,
  });

  static const Object _unset = Object();

  final String email;
  final String password;
  final bool isPasswordVisible;
  final LoginStatus status;
  final String? errorMessage;
  final int failedAttempts;
  final DateTime? lockedUntil;
  final AuthenticatedUser? authenticatedUser;
  final bool isBiometricAvailable;
  final bool supportsFingerprint;
  final bool supportsFaceAuthentication;

  bool get isLoading => status == LoginStatus.loading;

  bool get isSuccessful => status == LoginStatus.success;

  bool get isLocked {
    final lockEndTime = lockedUntil;

    if (lockEndTime == null) {
      return false;
    }

    return DateTime.now().isBefore(lockEndTime);
  }

  bool get isFormValid {
    return InputValidators.isLoginFormValid(email: email, password: password);
  }

  bool get canSubmit {
    return isFormValid && !isLoading && !isLocked;
  }

  LoginState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    LoginStatus? status,
    Object? errorMessage = _unset,
    int? failedAttempts,
    Object? lockedUntil = _unset,
    Object? authenticatedUser = _unset,
    bool? isBiometricAvailable,
    bool? supportsFingerprint,
    bool? supportsFaceAuthentication,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      status: status ?? this.status,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockedUntil: identical(lockedUntil, _unset)
          ? this.lockedUntil
          : lockedUntil as DateTime?,
      authenticatedUser: identical(authenticatedUser, _unset)
          ? this.authenticatedUser
          : authenticatedUser as AuthenticatedUser?,
      isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
      supportsFingerprint: supportsFingerprint ?? this.supportsFingerprint,
      supportsFaceAuthentication:
          supportsFaceAuthentication ?? this.supportsFaceAuthentication,
    );
  }
}
