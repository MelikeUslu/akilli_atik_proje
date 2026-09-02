import 'location.dart';

final class RouteStop {
  const RouteStop({
    required this.id,
    required this.containerId,
    required this.order,
    required this.location,
    required this.isCompleted,
  });

  final String id;
  final String containerId;
  final int order;
  final Location location;
  final bool isCompleted;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RouteStop &&
            other.id == id &&
            other.containerId == containerId &&
            other.order == order &&
            other.location == location &&
            other.isCompleted == isCompleted;
  }

  @override
  int get hashCode =>
      Object.hash(id, containerId, order, location, isCompleted);
}
