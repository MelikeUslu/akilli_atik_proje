import 'package:injectable/injectable.dart';

import '../entities/shift.dart';
import '../repositories/shift_repository.dart';

@lazySingleton
final class StartShiftUseCase {
  const StartShiftUseCase(this._repository);

  final ShiftRepository _repository;

  Future<Shift> call({required String driverId}) {
    return _repository.startShift(driverId: driverId);
  }
}
