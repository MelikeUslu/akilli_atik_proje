import 'route_stop.dart';

final class Route {
  const Route({
    required this.id,
    required this.driverId,
    required this.stops,
    required this.totalDistanceKm,
  });

  final String id;
  final String driverId;
  final List<RouteStop> stops;
  final double totalDistanceKm;

  int get totalStopCount => stops.length;

  int get completedStopCount {
    return stops.where((stop) => stop.isCompleted).length;
  }

  int get remainingStopCount {
    return totalStopCount - completedStopCount;
  }

  int get currentStopNumber {
    if (stops.isEmpty) {
      return 0;
    }

    final nextStopIndex = stops.indexWhere((stop) => !stop.isCompleted);

    if (nextStopIndex == -1) {
      return totalStopCount;
    }

    return nextStopIndex + 1;
  }

  bool get isCompleted {
    return stops.isNotEmpty && remainingStopCount == 0;
  }

  RouteStop? get nextStop {
    for (final stop in stops) {
      if (!stop.isCompleted) {
        return stop;
      }
    }

    return null;
  }
}
