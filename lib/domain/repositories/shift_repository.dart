import '../entities/shift.dart';

abstract interface class ShiftRepository {
  Future<Shift> startShift({required String driverId});

  Future<Shift> endShift({required String driverId});
}
