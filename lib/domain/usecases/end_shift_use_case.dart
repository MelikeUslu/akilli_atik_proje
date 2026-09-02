import '../entities/shift.dart';
import '../repositories/shift_repository.dart';

final class EndShiftUseCase {
  const EndShiftUseCase(this._repository);

  final ShiftRepository _repository;

  Future<Shift> call({required String driverId}) {
    final normalizedDriverId = driverId.trim();

    if (normalizedDriverId.isEmpty) {
      throw const FormatException('Şoför bilgisi boş olamaz.');
    }

    return _repository.endShift(driverId: normalizedDriverId);
  }
}
