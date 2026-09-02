import 'package:injectable/injectable.dart';

import '../entities/route.dart';
import '../repositories/route_repository.dart';

@lazySingleton
final class GetActiveRouteUseCase {
  const GetActiveRouteUseCase(this._repository);

  final RouteRepository _repository;

  Future<Route> call({required String driverId}) {
    return _repository.getActiveRoute(driverId: driverId);
  }
}
