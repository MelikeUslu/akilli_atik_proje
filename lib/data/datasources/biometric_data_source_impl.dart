import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';

import 'biometric_data_source.dart';

@LazySingleton(as: BiometricDataSource)
final class BiometricDataSourceImpl implements BiometricDataSource {
  const BiometricDataSourceImpl({required this.localAuthentication});

  final LocalAuthentication localAuthentication;

  @override
  Future<bool> isAvailable() async {
    final canCheckBiometrics = await localAuthentication.canCheckBiometrics;

    final isDeviceSupported = await localAuthentication.isDeviceSupported();

    return canCheckBiometrics && isDeviceSupported;
  }

  @override
  Future<bool> supportsFingerprint() async {
    final availableBiometrics = await localAuthentication
        .getAvailableBiometrics();

    return availableBiometrics.contains(BiometricType.fingerprint);
  }

  @override
  Future<bool> supportsFaceAuthentication() async {
    final availableBiometrics = await localAuthentication
        .getAvailableBiometrics();

    return availableBiometrics.contains(BiometricType.face);
  }

  @override
  Future<bool> authenticate() {
    return localAuthentication.authenticate(
      localizedReason:
          'Akıllı Atık uygulamasına giriş yapmak için kimliğinizi doğrulayın.',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
  }
}
