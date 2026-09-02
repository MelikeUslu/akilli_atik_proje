import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/connectivity_service.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/get_active_route_use_case.dart';
import '../../domain/usecases/get_current_location_use_case.dart';
import 'map_state.dart';

final class MapNotifier extends Notifier<MapState> {
  MapNotifier(
    this._getActiveRouteUseCase,
    this._getCurrentLocationUseCase,
    this._locationRepository,
    this._connectivityService,
  );

  final GetActiveRouteUseCase _getActiveRouteUseCase;
  final GetCurrentLocationUseCase _getCurrentLocationUseCase;
  final LocationRepository _locationRepository;
  final ConnectivityService _connectivityService;

  StreamSubscription<bool>? _gpsSubscription;
  StreamSubscription<bool>? _connectivitySubscription;

  @override
  MapState build() {
    ref.onDispose(() {
      _gpsSubscription?.cancel();
      _connectivitySubscription?.cancel();
    });

    Future.microtask(_initialize);

    return const MapState();
  }

  Future<void> loadActiveRoute({required String driverId}) async {
    final normalizedDriverId = driverId.trim();

    if (normalizedDriverId.isEmpty) {
      state = state.copyWith(
        status: MapStatus.failure,
        errorMessage: 'Şoför bilgisi bulunamadı.',
      );
      return;
    }

    if (state.isLoading) {
      return;
    }

    state = state.copyWith(status: MapStatus.loading, errorMessage: null);

    try {
      final route = await _getActiveRouteUseCase(driverId: normalizedDriverId);

      state = state.copyWith(
        status: MapStatus.success,
        route: route,
        errorMessage: null,
      );
    } catch (_) {
      state = state.copyWith(
        status: MapStatus.failure,
        route: null,
        errorMessage: 'Aktif rota bilgisi alınamadı.',
      );
    }
  }

  Future<void> loadCurrentLocation() async {
    state = state.copyWith(locationAccessStatus: LocationAccessStatus.checking);

    final serviceEnabled = await _locationRepository.isLocationServiceEnabled();

    if (!serviceEnabled) {
      state = state.copyWith(
        isGpsEnabled: false,
        currentLocation: null,
        locationAccessStatus: LocationAccessStatus.serviceDisabled,
      );
      return;
    }

    state = state.copyWith(isGpsEnabled: true);

    var permission = await _locationRepository.checkPermission();

    if (permission == LocationPermissionStatus.denied) {
      permission = await _locationRepository.requestPermission();
    }

    if (permission == LocationPermissionStatus.denied) {
      state = state.copyWith(
        currentLocation: null,
        locationAccessStatus: LocationAccessStatus.denied,
      );
      return;
    }

    if (permission == LocationPermissionStatus.deniedForever) {
      state = state.copyWith(
        currentLocation: null,
        locationAccessStatus: LocationAccessStatus.deniedForever,
      );
      return;
    }

    try {
      final currentLocation = await _getCurrentLocationUseCase();

      state = state.copyWith(
        isGpsEnabled: true,
        currentLocation: currentLocation,
        locationAccessStatus: LocationAccessStatus.granted,
        errorMessage: null,
      );
    } catch (_) {
      state = state.copyWith(
        currentLocation: null,
        locationAccessStatus: LocationAccessStatus.granted,
        errorMessage: 'Mevcut konum alınamadı.',
      );
    }
  }

  Future<void> refreshActiveRoute({required String driverId}) {
    return loadActiveRoute(driverId: driverId);
  }

  Future<void> refreshGpsStatus() async {
    final isGpsEnabled = await _locationRepository.isLocationServiceEnabled();

    if (!isGpsEnabled) {
      state = state.copyWith(
        isGpsEnabled: false,
        currentLocation: null,
        locationAccessStatus: LocationAccessStatus.serviceDisabled,
      );
      return;
    }

    state = state.copyWith(isGpsEnabled: true);
  }

  Future<void> refreshConnectivityStatus() async {
    final isOnline = await _connectivityService.isConnected;

    state = state.copyWith(isOnline: isOnline);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clear() {
    state = MapState(
      isGpsEnabled: state.isGpsEnabled,
      isOnline: state.isOnline,
      currentLocation: state.currentLocation,
      locationAccessStatus: state.locationAccessStatus,
    );
  }

  Future<void> _initialize() async {
    await refreshConnectivityStatus();
    await loadCurrentLocation();

    await _gpsSubscription?.cancel();
    await _connectivitySubscription?.cancel();

    _gpsSubscription = _locationRepository.locationServiceStatusStream.listen(
      _handleGpsStatusChanged,
    );

    _connectivitySubscription = _connectivityService.connectionStream.listen(
      _handleConnectivityChanged,
    );
  }

  Future<void> _handleGpsStatusChanged(bool isGpsEnabled) async {
    if (!isGpsEnabled) {
      state = state.copyWith(
        isGpsEnabled: false,
        currentLocation: null,
        locationAccessStatus: LocationAccessStatus.serviceDisabled,
      );
      return;
    }

    state = state.copyWith(isGpsEnabled: true);

    await loadCurrentLocation();
  }

  void _handleConnectivityChanged(bool isOnline) {
    state = state.copyWith(isOnline: isOnline);
  }
}
