import 'package:injectable/injectable.dart';

import '../../core/network/connectivity_service.dart';
import '../../domain/entities/route.dart';
import '../../domain/repositories/route_repository.dart';
import '../datasources/route_local_data_source.dart';
import '../datasources/route_remote_data_source.dart';
import '../services/offline_route_action_queue.dart';

@LazySingleton(as: RouteRepository)
final class RouteRepositoryImpl implements RouteRepository {
  const RouteRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivityService,
    required this.offlineRouteActionQueue,
  });

  final RouteRemoteDataSource remoteDataSource;
  final RouteLocalDataSource localDataSource;
  final ConnectivityService connectivityService;
  final OfflineRouteActionQueue offlineRouteActionQueue;

  @override
  Future<Route> getActiveRoute({required String driverId}) async {
    final normalizedDriverId = driverId.trim();

    if (normalizedDriverId.isEmpty) {
      throw const FormatException('Şoför bilgisi boş olamaz.');
    }

    final isOnline = await connectivityService.isConnected;

    if (!isOnline) {
      final cachedRoute = await localDataSource.getCachedActiveRoute(
        driverId: normalizedDriverId,
      );

      if (cachedRoute == null) {
        throw StateError('Çevrimdışı kullanılabilecek aktif rota bulunamadı.');
      }

      return cachedRoute.toEntity();
    }

    try {
      final routeModel = await remoteDataSource.getActiveRoute(
        driverId: normalizedDriverId,
      );

      await localDataSource.cacheActiveRoute(routeModel);

      return routeModel.toEntity();
    } catch (_) {
      final cachedRoute = await localDataSource.getCachedActiveRoute(
        driverId: normalizedDriverId,
      );

      if (cachedRoute != null) {
        return cachedRoute.toEntity();
      }

      rethrow;
    }
  }

  @override
  Future<void> completeStop({
    required String routeId,
    required String stopId,
  }) async {
    final normalizedRouteId = routeId.trim();
    final normalizedStopId = stopId.trim();

    if (normalizedRouteId.isEmpty) {
      throw const FormatException('Rota bilgisi boş olamaz.');
    }

    if (normalizedStopId.isEmpty) {
      throw const FormatException('Durak bilgisi boş olamaz.');
    }

    final isOnline = await connectivityService.isConnected;

    if (!isOnline) {
      await offlineRouteActionQueue.enqueueCompleteStop(
        routeId: normalizedRouteId,
        stopId: normalizedStopId,
      );

      return;
    }

    await remoteDataSource.completeStop(
      routeId: normalizedRouteId,
      stopId: normalizedStopId,
    );
  }

  @override
  Future<void> skipStop({
    required String routeId,
    required String stopId,
    required String reason,
  }) async {
    final normalizedRouteId = routeId.trim();
    final normalizedStopId = stopId.trim();
    final normalizedReason = reason.trim();

    if (normalizedRouteId.isEmpty) {
      throw const FormatException('Rota bilgisi boş olamaz.');
    }

    if (normalizedStopId.isEmpty) {
      throw const FormatException('Durak bilgisi boş olamaz.');
    }

    if (normalizedReason.isEmpty) {
      throw const FormatException('Durak atlama nedeni boş olamaz.');
    }

    final isOnline = await connectivityService.isConnected;

    if (!isOnline) {
      await offlineRouteActionQueue.enqueueSkipStop(
        routeId: normalizedRouteId,
        stopId: normalizedStopId,
        reason: normalizedReason,
      );

      return;
    }

    await remoteDataSource.skipStop(
      routeId: normalizedRouteId,
      stopId: normalizedStopId,
      reason: normalizedReason,
    );
  }
}
