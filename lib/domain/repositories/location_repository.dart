import '../entities/location.dart';

enum LocationPermissionStatus { denied, deniedForever, granted }

abstract interface class LocationRepository {
  Future<Location> getCurrentLocation();

  Future<bool> isLocationServiceEnabled();

  Future<LocationPermissionStatus> checkPermission();

  Future<LocationPermissionStatus> requestPermission();

  Stream<bool> get locationServiceStatusStream;
}
