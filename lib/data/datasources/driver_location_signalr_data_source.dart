import '../../domain/entities/location.dart';

abstract interface class DriverLocationSignalRDataSource {
  Future<void> sendLocation({
    required String driverId,
    required Location location,
  });
}
