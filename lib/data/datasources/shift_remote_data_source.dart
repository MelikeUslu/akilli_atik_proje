import '../models/shift_model.dart';

abstract interface class ShiftRemoteDataSource {
  Future<ShiftModel> startShift({required String driverId});

  Future<ShiftModel> endShift({required String driverId});
}
