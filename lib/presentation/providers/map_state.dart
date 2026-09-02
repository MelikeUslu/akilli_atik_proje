import '../../domain/entities/location.dart';
import '../../domain/entities/route.dart';

enum MapStatus { initial, loading, success, failure }

enum LocationAccessStatus {
  unknown,
  checking,
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

final class MapState {
  const MapState({
    this.status = MapStatus.initial,
    this.route,
    this.currentLocation,
    this.errorMessage,
    this.isGpsEnabled = false,
    this.isOnline = false,
    this.locationAccessStatus = LocationAccessStatus.unknown,
  });

  static const Object _unset = Object();

  final MapStatus status;
  final Route? route;
  final Location? currentLocation;
  final String? errorMessage;
  final bool isGpsEnabled;
  final bool isOnline;
  final LocationAccessStatus locationAccessStatus;

  bool get isLoading => status == MapStatus.loading;

  bool get hasRoute => route != null;

  bool get hasCurrentLocation => currentLocation != null;

  bool get isLocationLoading {
    return locationAccessStatus == LocationAccessStatus.unknown ||
        locationAccessStatus == LocationAccessStatus.checking;
  }

  bool get canUseLocation {
    return isGpsEnabled &&
        locationAccessStatus == LocationAccessStatus.granted &&
        currentLocation != null;
  }

  String get gpsStatusText {
    if (!isGpsEnabled ||
        locationAccessStatus == LocationAccessStatus.serviceDisabled) {
      return 'Kapalı';
    }

    switch (locationAccessStatus) {
      case LocationAccessStatus.unknown:
      case LocationAccessStatus.checking:
        return 'Kontrol Ediliyor';
      case LocationAccessStatus.denied:
      case LocationAccessStatus.deniedForever:
        return 'İzin Gerekli';
      case LocationAccessStatus.granted:
        return 'Açık';
      case LocationAccessStatus.serviceDisabled:
        return 'Kapalı';
    }
  }

  bool get isGpsReady {
    return isGpsEnabled && locationAccessStatus == LocationAccessStatus.granted;
  }

  int get currentStopNumber {
    return route?.currentStopNumber ?? 0;
  }

  int get totalStopCount {
    return route?.totalStopCount ?? 0;
  }

  int get remainingStopCount {
    return route?.remainingStopCount ?? 0;
  }

  double get totalDistanceKm {
    return route?.totalDistanceKm ?? 0;
  }

  MapState copyWith({
    MapStatus? status,
    Object? route = _unset,
    Object? currentLocation = _unset,
    Object? errorMessage = _unset,
    bool? isGpsEnabled,
    bool? isOnline,
    LocationAccessStatus? locationAccessStatus,
  }) {
    return MapState(
      status: status ?? this.status,
      route: identical(route, _unset) ? this.route : route as Route?,
      currentLocation: identical(currentLocation, _unset)
          ? this.currentLocation
          : currentLocation as Location?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
      isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled,
      isOnline: isOnline ?? this.isOnline,
      locationAccessStatus: locationAccessStatus ?? this.locationAccessStatus,
    );
  }
}
