import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_data_source.dart';

@LazySingleton(as: LocationRepository)
final class LocationRepositoryImpl implements LocationRepository {
  const LocationRepositoryImpl({required this.locationDataSource});

  final LocationDataSource locationDataSource;

  @override
  Future<Location> getCurrentLocation() async {
    final position = await locationDataSource.getCurrentPosition();

    return Location(latitude: position.latitude, longitude: position.longitude);
  }

  @override
  Future<bool> isLocationServiceEnabled() {
    return locationDataSource.isLocationServiceEnabled();
  }

  @override
  Future<LocationPermissionStatus> checkPermission() async {
    final permission = await locationDataSource.checkPermission();

    return _mapPermission(permission);
  }

  @override
  Future<LocationPermissionStatus> requestPermission() async {
    final permission = await locationDataSource.requestPermission();

    return _mapPermission(permission);
  }

  @override
  Stream<bool> get locationServiceStatusStream {
    return locationDataSource.locationServiceStatusStream;
  }

  LocationPermissionStatus _mapPermission(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return LocationPermissionStatus.granted;
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.denied;
    }
  }
}
