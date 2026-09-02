import 'fill_level.dart';
import 'location.dart';

final class WasteContainer {
  const WasteContainer({
    required this.id,
    required this.code,
    required this.location,
    required this.fillPercentage,
    required this.status,
  });

  final String id;
  final String code;
  final Location location;
  final double fillPercentage;
  final WasteContainerStatus status;

  FillLevel get fillLevel => FillLevel.fromPercentage(fillPercentage);

  bool get isCritical => fillLevel == FillLevel.critical;

  bool get isFull => fillPercentage >= 100;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is WasteContainer &&
            other.id == id &&
            other.code == code &&
            other.location == location &&
            other.fillPercentage == fillPercentage &&
            other.status == status;
  }

  @override
  int get hashCode {
    return Object.hash(id, code, location, fillPercentage, status);
  }
}

enum WasteContainerStatus { active, inactive, maintenance }
