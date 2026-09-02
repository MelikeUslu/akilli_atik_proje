import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/connectivity_service.dart';
import '../../di/injection.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/get_active_route_use_case.dart';
import '../../domain/usecases/get_current_location_use_case.dart';
import 'map_notifier.dart';
import 'map_state.dart';

final mapProvider = NotifierProvider<MapNotifier, MapState>(
  () => MapNotifier(
    getIt<GetActiveRouteUseCase>(),
    getIt<GetCurrentLocationUseCase>(),
    getIt<LocationRepository>(),
    getIt<ConnectivityService>(),
  ),
);
