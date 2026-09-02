// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:akilli_atik_proje/core/network/auth_interceptor.dart' as _i131;
import 'package:akilli_atik_proje/core/network/connectivity_service.dart'
    as _i855;
import 'package:akilli_atik_proje/core/network/https_only_interceptor.dart'
    as _i110;
import 'package:akilli_atik_proje/core/network/signalr_client.dart' as _i546;
import 'package:akilli_atik_proje/data/datasources/auth_local_data_source.dart'
    as _i724;
import 'package:akilli_atik_proje/data/datasources/auth_local_data_source_impl.dart'
    as _i795;
import 'package:akilli_atik_proje/data/datasources/auth_remote_data_source.dart'
    as _i1050;
import 'package:akilli_atik_proje/data/datasources/auth_remote_data_source_impl.dart'
    as _i80;
import 'package:akilli_atik_proje/data/datasources/biometric_data_source.dart'
    as _i878;
import 'package:akilli_atik_proje/data/datasources/biometric_data_source_impl.dart'
    as _i407;
import 'package:akilli_atik_proje/data/datasources/container_realtime_data_source.dart'
    as _i273;
import 'package:akilli_atik_proje/data/datasources/container_realtime_data_source_impl.dart'
    as _i661;
import 'package:akilli_atik_proje/data/datasources/location_data_source.dart'
    as _i160;
import 'package:akilli_atik_proje/data/datasources/location_data_source_impl.dart'
    as _i427;
import 'package:akilli_atik_proje/data/datasources/offline_route_action_local_data_source.dart'
    as _i597;
import 'package:akilli_atik_proje/data/datasources/offline_route_action_local_data_source_impl.dart'
    as _i574;
import 'package:akilli_atik_proje/data/datasources/route_local_data_source.dart'
    as _i167;
import 'package:akilli_atik_proje/data/datasources/route_local_data_source_impl.dart'
    as _i975;
import 'package:akilli_atik_proje/data/datasources/route_remote_data_source.dart'
    as _i891;
import 'package:akilli_atik_proje/data/datasources/route_remote_data_source_impl.dart'
    as _i575;
import 'package:akilli_atik_proje/data/datasources/shift_remote_data_source.dart'
    as _i26;
import 'package:akilli_atik_proje/data/datasources/shift_remote_data_source_impl.dart'
    as _i739;
import 'package:akilli_atik_proje/data/datasources/waste_container_local_data_source.dart'
    as _i63;
import 'package:akilli_atik_proje/data/datasources/waste_container_local_data_source_impl.dart'
    as _i1063;
import 'package:akilli_atik_proje/data/datasources/waste_container_remote_data_source.dart'
    as _i723;
import 'package:akilli_atik_proje/data/datasources/waste_container_remote_data_source_impl.dart'
    as _i245;
import 'package:akilli_atik_proje/data/repositories/auth_repository_impl.dart'
    as _i692;
import 'package:akilli_atik_proje/data/repositories/location_repository_impl.dart'
    as _i909;
import 'package:akilli_atik_proje/data/repositories/route_repository_impl.dart'
    as _i671;
import 'package:akilli_atik_proje/data/repositories/shift_repository_impl.dart'
    as _i393;
import 'package:akilli_atik_proje/data/repositories/waste_container_repository_impl.dart'
    as _i54;
import 'package:akilli_atik_proje/data/services/offline_route_action_queue.dart'
    as _i283;
import 'package:akilli_atik_proje/data/services/offline_route_sync_service.dart'
    as _i38;
import 'package:akilli_atik_proje/data/services/offline_sync_coordinator.dart'
    as _i899;
import 'package:akilli_atik_proje/di/register_module.dart' as _i375;
import 'package:akilli_atik_proje/domain/repositories/auth_repository.dart'
    as _i49;
import 'package:akilli_atik_proje/domain/repositories/location_repository.dart'
    as _i422;
import 'package:akilli_atik_proje/domain/repositories/route_repository.dart'
    as _i679;
import 'package:akilli_atik_proje/domain/repositories/shift_repository.dart'
    as _i40;
import 'package:akilli_atik_proje/domain/repositories/waste_container_repository.dart'
    as _i78;
import 'package:akilli_atik_proje/domain/usecases/biometric_login_use_case.dart'
    as _i366;
import 'package:akilli_atik_proje/domain/usecases/get_active_route_use_case.dart'
    as _i20;
import 'package:akilli_atik_proje/domain/usecases/get_containers_by_zone_use_case.dart'
    as _i285;
import 'package:akilli_atik_proje/domain/usecases/get_current_location_use_case.dart'
    as _i598;
import 'package:akilli_atik_proje/domain/usecases/login_use_case.dart' as _i417;
import 'package:akilli_atik_proje/domain/usecases/start_shift_use_case.dart'
    as _i933;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:local_auth/local_auth.dart' as _i152;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i110.HttpsOnlyInterceptor>(
      () => _i110.HttpsOnlyInterceptor(),
    );
    gh.lazySingleton<_i546.SignalRClient>(() => _i546.SignalRClient());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i152.LocalAuthentication>(
      () => registerModule.localAuthentication,
    );
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i597.OfflineRouteActionLocalDataSource>(
      () => _i574.OfflineRouteActionLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i167.RouteLocalDataSource>(
      () => _i975.RouteLocalDataSourceImpl(),
    );
    gh.factory<String>(
      () => registerModule.refreshTokenEndpoint,
      instanceName: 'refreshTokenEndpoint',
    );
    gh.lazySingleton<_i878.BiometricDataSource>(
      () => _i407.BiometricDataSourceImpl(
        localAuthentication: gh<_i152.LocalAuthentication>(),
      ),
    );
    gh.factory<String>(
      () => registerModule.completeRouteStopEndpoint,
      instanceName: 'completeRouteStopEndpoint',
    );
    gh.lazySingleton<_i283.OfflineRouteActionQueue>(
      () => _i283.OfflineRouteActionQueue(
        localDataSource: gh<_i597.OfflineRouteActionLocalDataSource>(),
      ),
    );
    gh.factory<String>(
      () => registerModule.endShiftEndpoint,
      instanceName: 'endShiftEndpoint',
    );
    gh.factory<String>(
      () => registerModule.containersByZoneEndpoint,
      instanceName: 'containersByZoneEndpoint',
    );
    gh.factory<String>(
      () => registerModule.activeRouteEndpoint,
      instanceName: 'activeRouteEndpoint',
    );
    gh.lazySingleton<_i273.ContainerRealtimeDataSource>(
      () => _i661.ContainerRealtimeDataSourceImpl(gh<_i546.SignalRClient>()),
    );
    gh.lazySingleton<_i160.LocationDataSource>(
      () => const _i427.LocationDataSourceImpl(),
    );
    gh.factory<String>(
      () => registerModule.startShiftEndpoint,
      instanceName: 'startShiftEndpoint',
    );
    gh.lazySingleton<_i63.WasteContainerLocalDataSource>(
      () => _i1063.WasteContainerLocalDataSourceImpl(),
    );
    gh.factory<String>(
      () => registerModule.skipRouteStopEndpoint,
      instanceName: 'skipRouteStopEndpoint',
    );
    gh.factory<String>(
      () => registerModule.loginEndpoint,
      instanceName: 'loginEndpoint',
    );
    gh.factory<String>(
      () => registerModule.unreadNotificationsEndpoint,
      instanceName: 'unreadNotificationsEndpoint',
    );
    gh.lazySingleton<_i855.ConnectivityService>(
      () => _i855.ConnectivityService(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i724.AuthLocalDataSource>(
      () => _i795.AuthLocalDataSourceImpl(
        secureStorage: gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i422.LocationRepository>(
      () => _i909.LocationRepositoryImpl(
        locationDataSource: gh<_i160.LocationDataSource>(),
      ),
    );
    gh.lazySingleton<_i131.AuthInterceptor>(
      () => _i131.AuthInterceptor(
        localDataSource: gh<_i724.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i598.GetCurrentLocationUseCase>(
      () => _i598.GetCurrentLocationUseCase(gh<_i422.LocationRepository>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(
        gh<_i131.AuthInterceptor>(),
        gh<_i110.HttpsOnlyInterceptor>(),
      ),
    );
    gh.lazySingleton<_i723.WasteContainerRemoteDataSource>(
      () => _i245.WasteContainerRemoteDataSourceImpl(
        gh<_i361.Dio>(),
        gh<String>(instanceName: 'containersByZoneEndpoint'),
      ),
    );
    gh.lazySingleton<_i1050.AuthRemoteDataSource>(
      () => _i80.AuthRemoteDataSourceImpl(
        dio: gh<_i361.Dio>(),
        loginEndpoint: gh<String>(instanceName: 'loginEndpoint'),
      ),
    );
    gh.lazySingleton<_i78.WasteContainerRepository>(
      () => _i54.WasteContainerRepositoryImpl(
        remoteDataSource: gh<_i723.WasteContainerRemoteDataSource>(),
        localDataSource: gh<_i63.WasteContainerLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i26.ShiftRemoteDataSource>(
      () => _i739.ShiftRemoteDataSourceImpl(
        dio: gh<_i361.Dio>(),
        startShiftEndpoint: gh<String>(instanceName: 'startShiftEndpoint'),
        endShiftEndpoint: gh<String>(instanceName: 'endShiftEndpoint'),
      ),
    );
    gh.lazySingleton<_i40.ShiftRepository>(
      () => _i393.ShiftRepositoryImpl(
        remoteDataSource: gh<_i26.ShiftRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i891.RouteRemoteDataSource>(
      () => _i575.RouteRemoteDataSourceImpl(
        dio: gh<_i361.Dio>(),
        activeRouteEndpoint: gh<String>(instanceName: 'activeRouteEndpoint'),
        completeRouteStopEndpoint: gh<String>(
          instanceName: 'completeRouteStopEndpoint',
        ),
        skipRouteStopEndpoint: gh<String>(
          instanceName: 'skipRouteStopEndpoint',
        ),
      ),
    );
    gh.lazySingleton<_i38.OfflineRouteSyncService>(
      () => _i38.OfflineRouteSyncService(
        remoteDataSource: gh<_i891.RouteRemoteDataSource>(),
        offlineRouteActionQueue: gh<_i283.OfflineRouteActionQueue>(),
      ),
    );
    gh.lazySingleton<_i285.GetContainersByZoneUseCase>(
      () =>
          _i285.GetContainersByZoneUseCase(gh<_i78.WasteContainerRepository>()),
    );
    gh.lazySingleton<_i679.RouteRepository>(
      () => _i671.RouteRepositoryImpl(
        remoteDataSource: gh<_i891.RouteRemoteDataSource>(),
        localDataSource: gh<_i167.RouteLocalDataSource>(),
        connectivityService: gh<_i855.ConnectivityService>(),
        offlineRouteActionQueue: gh<_i283.OfflineRouteActionQueue>(),
      ),
    );
    gh.lazySingleton<_i20.GetActiveRouteUseCase>(
      () => _i20.GetActiveRouteUseCase(gh<_i679.RouteRepository>()),
    );
    gh.lazySingleton<_i49.AuthRepository>(
      () => _i692.AuthRepositoryImpl(
        remoteDataSource: gh<_i1050.AuthRemoteDataSource>(),
        localDataSource: gh<_i724.AuthLocalDataSource>(),
        biometricDataSource: gh<_i878.BiometricDataSource>(),
      ),
    );
    gh.lazySingleton<_i933.StartShiftUseCase>(
      () => _i933.StartShiftUseCase(gh<_i40.ShiftRepository>()),
    );
    gh.lazySingleton<_i366.BiometricLoginUseCase>(
      () => _i366.BiometricLoginUseCase(gh<_i49.AuthRepository>()),
    );
    gh.lazySingleton<_i417.LoginUseCase>(
      () => _i417.LoginUseCase(gh<_i49.AuthRepository>()),
    );
    gh.lazySingleton<_i899.OfflineSyncCoordinator>(
      () => _i899.OfflineSyncCoordinator(
        connectivityService: gh<_i855.ConnectivityService>(),
        offlineRouteSyncService: gh<_i38.OfflineRouteSyncService>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i375.RegisterModule {}
