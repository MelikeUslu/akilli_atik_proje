import '../../domain/entities/location.dart';
import '../../domain/repositories/driver_location_repository.dart';
import '../datasources/driver_location_signalr_data_source.dart';

final class DriverLocationRepositoryImpl implements DriverLocationRepository {
  const DriverLocationRepositoryImpl({required this.remoteDataSource});

  final DriverLocationSignalRDataSource remoteDataSource;

  @override
  Future<void> sendLocation({
    required String driverId,
    required Location location,
  }) {
    return remoteDataSource.sendLocation(
      driverId: driverId,
      location: location,
    );
  }
}
