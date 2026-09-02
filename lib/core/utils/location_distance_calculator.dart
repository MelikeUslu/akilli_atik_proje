import 'dart:math' as math;

import '../../domain/entities/location.dart';

abstract final class LocationDistanceCalculator {
  static const double _earthRadiusMeters = 6371000;

  static double calculateMeters({
    required Location from,
    required Location to,
  }) {
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

    return _earthRadiusMeters * angularDistance;
  }

  static double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }
}
