import '../entities/route.dart';

abstract interface class RouteRepository {
  Future<Route> getActiveRoute({required String driverId});

  Future<void> completeStop({required String routeId, required String stopId});

  Future<void> skipStop({
    required String routeId,
    required String stopId,
    required String reason,
  });
}
