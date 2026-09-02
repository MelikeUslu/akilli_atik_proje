enum OfflineRouteActionType { completeStop, skipStop }

final class OfflineRouteActionModel {
  const OfflineRouteActionModel({
    required this.id,
    required this.type,
    required this.routeId,
    required this.stopId,
    required this.createdAt,
    this.reason,
  });

  final String id;
  final OfflineRouteActionType type;
  final String routeId;
  final String stopId;
  final DateTime createdAt;
  final String? reason;

  factory OfflineRouteActionModel.fromJson(Map<String, dynamic> json) {
    return OfflineRouteActionModel(
      id: json['id'] as String,
      type: _typeFromJson(json['type'] as String),
      routeId: json['routeId'] as String,
      stopId: json['stopId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      reason: json['reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': _typeToJson(type),
      'routeId': routeId,
      'stopId': stopId,
      'createdAt': createdAt.toUtc().toIso8601String(),
      if (reason != null) 'reason': reason,
    };
  }

  static OfflineRouteActionType _typeFromJson(String value) {
    switch (value) {
      case 'complete_stop':
        return OfflineRouteActionType.completeStop;

      case 'skip_stop':
        return OfflineRouteActionType.skipStop;

      default:
        throw FormatException('Geçersiz offline rota işlem tipi: $value');
    }
  }

  static String _typeToJson(OfflineRouteActionType type) {
    switch (type) {
      case OfflineRouteActionType.completeStop:
        return 'complete_stop';

      case OfflineRouteActionType.skipStop:
        return 'skip_stop';
    }
  }
}
