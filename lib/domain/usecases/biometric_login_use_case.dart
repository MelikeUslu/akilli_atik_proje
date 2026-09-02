import 'package:injectable/injectable.dart';

import '../repositories/auth_repository.dart';

@lazySingleton
final class BiometricLoginUseCase {
  const BiometricLoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<bool> isAvailable() {
    return _repository.isBiometricAvailable();
  }

  Future<bool> supportsFingerprint() {
    return _repository.supportsFingerprint();
  }

  Future<bool> supportsFaceAuthentication() {
    return _repository.supportsFaceAuthentication();
  }

  Future<bool> authenticate() {
    return _repository.authenticateWithBiometrics();
  }
}
