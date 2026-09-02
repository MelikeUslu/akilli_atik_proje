import 'dart:math' as math;

import '../entities/location.dart';
import '../entities/route.dart';
import '../entities/route_stop.dart';
import '../repositories/route_repository.dart';

final class CompleteRouteStopUseCase {
  const CompleteRouteStopUseCase(this._repository);

  static const double maximumCompletionDistanceMeters = 50;

  final RouteRepository _repository;

  Future<void> call({
    required Route route,
    required String stopId,
    required Location currentLocation,
  }) async {
    final normalizedStopId = stopId.trim();

    if (normalizedStopId.isEmpty) {
      throw const FormatException('Durak bilgisi boş olamaz.');
    }

    if (route.stops.isEmpty) {
      throw StateError('Aktif rotada tamamlanacak durak bulunamadı.');
    }

    final stop = _findStop(route: route, stopId: normalizedStopId);

    if (stop.isCompleted) {
      throw StateError('Bu durak zaten tamamlandı.');
    }

    final nextStop = route.nextStop;

    if (nextStop == null) {
      throw StateError('Tamamlanacak aktif durak bulunamadı.');
    }

    if (nextStop.id != stop.id) {
      throw StateError('Duraklar sırayla tamamlanmalıdır.');
    }

    final distanceMeters = _calculateDistanceMeters(
      from: currentLocation,
      to: stop.location,
    );

    if (distanceMeters > maximumCompletionDistanceMeters) {
      throw StateError(
        'Durağı tamamlamak için konteynere 50 metre yakınında olmalısınız.',
      );
    }

    await _repository.completeStop(routeId: route.id, stopId: stop.id);
  }

  RouteStop _findStop({required Route route, required String stopId}) {
    for (final stop in route.stops) {
      if (stop.id == stopId) {
        return stop;
      }
    }

    throw StateError('Durak aktif rota içerisinde bulunamadı.');
  }

  double _calculateDistanceMeters({
    required Location from,
    required Location to,
  }) {
    const earthRadiusMeters = 6371000.0;

    final latitude1 = _toRadians(from.latitude);
    final latitude2 = _toRadians(to.latitude);
    final latitudeDifference = _toRadians(to.latitude - from.latitude);
    final longitudeDifference = _toRadians(to.longitude - from.longitude);

    final haversine =
        math.sin(latitudeDifference / 2) * math.sin(latitudeDifference / 2) +
        math.cos(latitude1) *
            math.cos(latitude2) *
            math.sin(longitudeDifference / 2) *
            math.sin(longitudeDifference / 2);

    final angularDistance =
        2 * math.atan2(math.sqrt(haversine), math.sqrt(1 - haversine));

    return earthRadiusMeters * angularDistance;
  }

  double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }
}
