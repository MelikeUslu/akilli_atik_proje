import '../../domain/entities/route.dart';
import 'route_stop_model.dart';

final class RouteModel {
  const RouteModel({
    required this.id,
    required this.driverId,
    required this.stops,
    required this.totalDistanceKm,
  });

  final String id;
  final String driverId;
  final List<RouteStopModel> stops;
  final double totalDistanceKm;

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    final rawStops = json['stops'] as List<dynamic>? ?? const [];

    return RouteModel(
      id: json['id'] as String,
      driverId: json['driverId'] as String,
      stops: rawStops
          .map(
            (item) =>
                RouteStopModel.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(growable: false),
      totalDistanceKm: (json['totalDistanceKm'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'stops': stops.map((stop) => stop.toJson()).toList(growable: false),
      'totalDistanceKm': totalDistanceKm,
    };
  }

  Route toEntity() {
    return Route(
      id: id,
      driverId: driverId,
      stops: stops.map((stop) => stop.toEntity()).toList(growable: false),
      totalDistanceKm: totalDistanceKm,
    );
  }
}
