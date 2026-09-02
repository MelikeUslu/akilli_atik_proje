import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../core/constants/hive_box_names.dart';
import '../models/route_model.dart';
import 'route_local_data_source.dart';

@LazySingleton(as: RouteLocalDataSource)
final class RouteLocalDataSourceImpl implements RouteLocalDataSource {
  static const String _routeKey = 'route';

  Future<Box<dynamic>> _openBox() {
    return Hive.openBox<dynamic>(HiveBoxNames.activeRoute);
  }

  @override
  Future<void> cacheActiveRoute(RouteModel route) async {
    final box = await _openBox();

    await box.put(_routeKey, route.toJson());
  }

  @override
  Future<RouteModel?> getCachedActiveRoute({required String driverId}) async {
    final normalizedDriverId = driverId.trim();

    if (normalizedDriverId.isEmpty) {
      return null;
    }

    final box = await _openBox();
    final rawRoute = box.get(_routeKey);

    if (rawRoute is! Map) {
      return null;
    }

    final route = RouteModel.fromJson(Map<String, dynamic>.from(rawRoute));

    if (route.driverId != normalizedDriverId) {
      return null;
    }

    return route;
  }

  @override
  Future<void> clearActiveRoute() async {
    final box = await _openBox();

    await box.delete(_routeKey);
  }
}
