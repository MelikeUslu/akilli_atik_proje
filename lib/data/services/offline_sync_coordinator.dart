import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../core/network/connectivity_service.dart';
import 'offline_route_sync_service.dart';

@lazySingleton
final class OfflineSyncCoordinator {
  OfflineSyncCoordinator({
    required this.connectivityService,
    required this.offlineRouteSyncService,
  });

  final ConnectivityService connectivityService;
  final OfflineRouteSyncService offlineRouteSyncService;

  StreamSubscription<bool>? _connectivitySubscription;
  bool _isSynchronizing = false;
  bool _isStarted = false;

  Future<void> start() async {
    if (_isStarted) {
      return;
    }

    _isStarted = true;

    final isConnected = await connectivityService.isConnected;

    if (isConnected) {
      await _synchronize();
    }

    _connectivitySubscription = connectivityService.connectionStream.listen((
      isOnline,
    ) {
      if (!isOnline) {
        return;
      }

      unawaited(_synchronize());
    });
  }

  Future<void> _synchronize() async {
    if (_isSynchronizing) {
      return;
    }

    _isSynchronizing = true;

    try {
      await offlineRouteSyncService.synchronize();
    } finally {
      _isSynchronizing = false;
    }
  }

  Future<void> stop() async {
    await _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
    _isStarted = false;
  }
}
