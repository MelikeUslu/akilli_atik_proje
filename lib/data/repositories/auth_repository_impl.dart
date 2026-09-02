import 'package:injectable/injectable.dart';

import '../../domain/entities/authenticated_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/biometric_data_source.dart';

@LazySingleton(as: AuthRepository)
final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.biometricDataSource,
  });

  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final BiometricDataSource biometricDataSource;

  @override
  Future<AuthenticatedUser> login({
    required String email,
    required String password,
  }) async {
    final response = await remoteDataSource.login(
      email: email,
      password: password,
    );

    await localDataSource.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );

    return response.toEntity();
  }

  @override
  Future<bool> isBiometricAvailable() {
    return biometricDataSource.isAvailable();
  }

  @override
  Future<bool> supportsFingerprint() {
    return biometricDataSource.supportsFingerprint();
  }

  @override
  Future<bool> supportsFaceAuthentication() {
    return biometricDataSource.supportsFaceAuthentication();
  }

  @override
  Future<bool> authenticateWithBiometrics() {
    return biometricDataSource.authenticate();
  }
}
