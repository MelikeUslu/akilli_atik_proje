import '../../domain/entities/location.dart';
import '../../domain/entities/waste_container.dart';

final class WasteContainerModel {
  const WasteContainerModel({
    required this.id,
    required this.code,
    required this.latitude,
    required this.longitude,
    required this.fillPercentage,
    required this.status,
  });

  final String id;
  final String code;
  final double latitude;
  final double longitude;
  final double fillPercentage;
  final String status;

  factory WasteContainerModel.fromJson(Map<String, dynamic> json) {
    return WasteContainerModel(
      id: json['id'] as String,
      code: json['code'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      fillPercentage: (json['fillPercentage'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'latitude': latitude,
      'longitude': longitude,
      'fillPercentage': fillPercentage,
      'status': status,
    };
  }

  WasteContainer toEntity() {
    return WasteContainer(
      id: id,
      code: code,
      location: Location(latitude: latitude, longitude: longitude),
      fillPercentage: fillPercentage,
      status: _mapStatus(status),
    );
  }

  WasteContainerStatus _mapStatus(String value) {
    switch (value) {
      case 'active':
        return WasteContainerStatus.active;

      case 'inactive':
        return WasteContainerStatus.inactive;

      case 'maintenance':
        return WasteContainerStatus.maintenance;

      default:
        throw FormatException('Geçersiz konteyner durumu: $value');
    }
  }
}
