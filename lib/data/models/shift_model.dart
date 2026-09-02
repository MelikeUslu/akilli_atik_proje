import '../../domain/entities/shift.dart';

final class ShiftModel {
  const ShiftModel({
    required this.id,
    required this.driverId,
    required this.startedAt,
    required this.status,
    this.endedAt,
  });

  final String id;
  final String driverId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String status;

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id'] as String,
      driverId: json['driverId'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
      status: json['status'] as String,
    );
  }

  Shift toEntity() {
    return Shift(
      id: id,
      driverId: driverId,
      startedAt: startedAt,
      endedAt: endedAt,
      status: _mapStatus(status),
    );
  }

  ShiftStatus _mapStatus(String value) {
    switch (value) {
      case 'active':
        return ShiftStatus.active;
      case 'on_break':
        return ShiftStatus.onBreak;
      case 'completed':
        return ShiftStatus.completed;
      default:
        throw FormatException('Geçersiz vardiya durumu: $value');
    }
  }
}
