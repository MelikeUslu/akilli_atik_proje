import 'package:geolocator/geolocator.dart';

abstract interface class LocationDataSource {
  Future<bool> isLocationServiceEnabled();

  Future<LocationPermission> checkPermission();

  Future<LocationPermission> requestPermission();

  Future<Position> getCurrentPosition();

  Stream<bool> get locationServiceStatusStream;
}
