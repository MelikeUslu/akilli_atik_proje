import '../models/route_model.dart';

abstract interface class RouteLocalDataSource {
  Future<void> cacheActiveRoute(RouteModel route);

  Future<RouteModel?> getCachedActiveRoute({required String driverId});

  Future<void> clearActiveRoute();
}
