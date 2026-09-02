import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/login_response_model.dart';
import 'auth_remote_data_source.dart';

@LazySingleton(as: AuthRemoteDataSource)
final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required this.dio,
    @Named('loginEndpoint') required this.loginEndpoint,
  });

  final Dio dio;
  final String loginEndpoint;

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await dio.post<Map<String, dynamic>>(
      loginEndpoint,
      data: {'email': email.trim(), 'password': password},
    );

    final responseData = response.data;

    if (responseData == null) {
      throw const FormatException(
        'Sunucudan geçerli bir giriş cevabı alınamadı.',
      );
    }

    return LoginResponseModel.fromJson(responseData);
  }
}
