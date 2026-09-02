import '../models/route_model.dart';

abstract interface class RouteRemoteDataSource {
  Future<RouteModel> getActiveRoute({required String driverId});

  Future<void> completeStop({required String routeId, required String stopId});

  Future<void> skipStop({
    required String routeId,
    required String stopId,
    required String reason,
  });
}
