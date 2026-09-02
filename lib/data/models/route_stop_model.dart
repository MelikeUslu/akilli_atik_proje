import '../../domain/entities/location.dart';
import '../../domain/entities/route_stop.dart';

final class RouteStopModel {
  const RouteStopModel({
    required this.id,
    required this.containerId,
    required this.order,
    required this.latitude,
    required this.longitude,
    required this.isCompleted,
  });

  final String id;
  final String containerId;
  final int order;
  final double latitude;
  final double longitude;
  final bool isCompleted;

  factory RouteStopModel.fromJson(Map<String, dynamic> json) {
    return RouteStopModel(
      id: json['id'] as String,
      containerId: json['containerId'] as String,
      order: json['order'] as int,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isCompleted: json['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'containerId': containerId,
      'order': order,
      'latitude': latitude,
      'longitude': longitude,
      'isCompleted': isCompleted,
    };
  }

  RouteStop toEntity() {
    return RouteStop(
      id: id,
      containerId: containerId,
      order: order,
      location: Location(latitude: latitude, longitude: longitude),
      isCompleted: isCompleted,
    );
  }
}
