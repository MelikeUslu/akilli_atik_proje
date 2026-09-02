import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
final class HttpsOnlyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final uri = options.uri;

    if (uri.hasScheme && uri.scheme.toLowerCase() != 'https') {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badCertificate,
          error: StateError(
            'Güvenli olmayan HTTP bağlantılarına izin verilmez.',
          ),
        ),
      );

      return;
    }

    handler.next(options);
  }
}
