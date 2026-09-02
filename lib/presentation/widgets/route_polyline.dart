import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/route.dart';

abstract final class RoutePolyline {
  static const PolylineId _id = PolylineId('active_route');

  static Set<Polyline> create(Route? route) {
    if (route == null || route.stops.length < 2) {
      return const <Polyline>{};
    }

    final orderedStops = [...route.stops]
      ..sort((first, second) => first.order.compareTo(second.order));

    final points = orderedStops
        .map((stop) => LatLng(stop.location.latitude, stop.location.longitude))
        .toList(growable: false);

    return <Polyline>{
      Polyline(
        polylineId: _id,
        points: points,
        color: AppColors.primary,
        width: 6,
        geodesic: true,
      ),
    };
  }
}
