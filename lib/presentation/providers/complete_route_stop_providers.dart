import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection.dart';
import '../../domain/repositories/route_repository.dart';
import '../../domain/usecases/complete_route_stop_use_case.dart';
import 'complete_route_stop_notifier.dart';
import 'complete_route_stop_state.dart';

final completeRouteStopProvider =
    NotifierProvider<CompleteRouteStopNotifier, CompleteRouteStopState>(
      () => CompleteRouteStopNotifier(
        completeRouteStopUseCase: CompleteRouteStopUseCase(
          getIt<RouteRepository>(),
        ),
      ),
    );
