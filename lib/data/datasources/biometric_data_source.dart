abstract interface class BiometricDataSource {
  Future<bool> isAvailable();

  Future<bool> supportsFingerprint();

  Future<bool> supportsFaceAuthentication();

  Future<bool> authenticate();
}
