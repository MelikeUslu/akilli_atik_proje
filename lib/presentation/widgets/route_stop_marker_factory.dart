import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/route.dart';
import '../../domain/entities/route_stop.dart';
import 'route_stop_marker.dart';

abstract final class RouteStopMarkerFactory {
  static Future<Set<Marker>> createAll({
    required Route? route,
    required void Function(RouteStop stop) onStopTap,
  }) async {
    if (route == null || route.stops.isEmpty) {
      return const <Marker>{};
    }

    final orderedStops = [...route.stops]
      ..sort((first, second) => first.order.compareTo(second.order));

    final nextStopId = route.nextStop?.id;

    final markers = await Future.wait(
      orderedStops.map(
        (stop) => RouteStopMarker.create(
          stop: stop,
          isNextStop: stop.id == nextStopId,
          onTap: () => onStopTap(stop),
        ),
      ),
    );

    return Set<Marker>.unmodifiable(markers);
  }
}
