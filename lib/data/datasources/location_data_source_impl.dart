import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import 'location_data_source.dart';

@LazySingleton(as: LocationDataSource)
final class LocationDataSourceImpl implements LocationDataSource {
  const LocationDataSourceImpl();

  @override
  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<LocationPermission> checkPermission() {
    return Geolocator.checkPermission();
  }

  @override
  Future<LocationPermission> requestPermission() {
    return Geolocator.requestPermission();
  }

  @override
  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  @override
  Stream<bool> get locationServiceStatusStream {
    return Geolocator.getServiceStatusStream()
        .map((status) => status == ServiceStatus.enabled)
        .distinct();
  }
}
