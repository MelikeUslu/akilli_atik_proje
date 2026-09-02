import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../data/datasources/auth_local_data_source.dart';

@lazySingleton
final class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.localDataSource});

  final AuthLocalDataSource localDataSource;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await localDataSource.getAccessToken();
    final normalizedAccessToken = accessToken?.trim();

    if (normalizedAccessToken != null &&
        normalizedAccessToken.isNotEmpty &&
        !_hasAuthorizationHeader(options)) {
      options.headers['Authorization'] = 'Bearer $normalizedAccessToken';
    }

    handler.next(options);
  }

  bool _hasAuthorizationHeader(RequestOptions options) {
    return options.headers.keys.any(
      (key) => key.toLowerCase() == 'authorization',
    );
  }
}
