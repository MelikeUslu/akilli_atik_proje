import '../entities/location.dart';

abstract interface class DriverLocationRepository {
  Future<void> sendLocation({
    required String driverId,
    required Location location,
  });
}
