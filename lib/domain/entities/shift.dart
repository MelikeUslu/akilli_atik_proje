enum ShiftStatus { active, onBreak, completed }

final class Shift {
  const Shift({
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
  final ShiftStatus status;

  bool get isActive =>
      status == ShiftStatus.active || status == ShiftStatus.onBreak;
}
