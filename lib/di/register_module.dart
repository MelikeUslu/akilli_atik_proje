import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';

import '../core/constants/api_endpoints.dart';
import '../core/network/auth_interceptor.dart';
import '../core/network/https_only_interceptor.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio dio(
    AuthInterceptor authInterceptor,
    HttpsOnlyInterceptor httpsOnlyInterceptor,
  ) {
    final dio = Dio();

    dio.interceptors.addAll([httpsOnlyInterceptor, authInterceptor]);

    return dio;
  }

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  LocalAuthentication get localAuthentication => LocalAuthentication();

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @Named('loginEndpoint')
  String get loginEndpoint => ApiEndpoints.login;

  @Named('refreshTokenEndpoint')
  String get refreshTokenEndpoint => ApiEndpoints.refreshToken;

  @Named('startShiftEndpoint')
  String get startShiftEndpoint => ApiEndpoints.startShift;

  @Named('endShiftEndpoint')
  String get endShiftEndpoint => ApiEndpoints.endShift;

  @Named('activeRouteEndpoint')
  String get activeRouteEndpoint => ApiEndpoints.activeRoute;

  @Named('containersByZoneEndpoint')
  String get containersByZoneEndpoint => ApiEndpoints.containersByZone;

  @Named('completeRouteStopEndpoint')
  String get completeRouteStopEndpoint => ApiEndpoints.completeRouteStop;

  @Named('skipRouteStopEndpoint')
  String get skipRouteStopEndpoint => ApiEndpoints.skipRouteStop;

  @Named('unreadNotificationsEndpoint')
  String get unreadNotificationsEndpoint => ApiEndpoints.unreadNotifications;
}
