import '../entities/authenticated_user.dart';

abstract interface class AuthRepository {
  Future<AuthenticatedUser> login({
    required String email,
    required String password,
  });

  Future<bool> isBiometricAvailable();

  Future<bool> supportsFingerprint();

  Future<bool> supportsFaceAuthentication();

  Future<bool> authenticateWithBiometrics();
}
