import '../entities/location.dart';
import '../repositories/driver_location_repository.dart';

final class SendDriverLocationUseCase {
  const SendDriverLocationUseCase(this._repository);

  final DriverLocationRepository _repository;

  Future<void> call({required String driverId, required Location location}) {
    final normalizedDriverId = driverId.trim();

    if (normalizedDriverId.isEmpty) {
      throw const FormatException('Şoför bilgisi boş olamaz.');
    }

    if (!location.isValid) {
      throw const FormatException('Geçersiz konum bilgisi.');
    }

    return _repository.sendLocation(
      driverId: normalizedDriverId,
      location: location,
    );
  }
}
