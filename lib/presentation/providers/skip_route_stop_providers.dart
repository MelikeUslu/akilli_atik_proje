import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection.dart';
import '../../domain/repositories/route_repository.dart';
import '../../domain/usecases/skip_route_stop_use_case.dart';
import 'skip_route_stop_notifier.dart';
import 'skip_route_stop_state.dart';

final skipRouteStopProvider =
    NotifierProvider<SkipRouteStopNotifier, SkipRouteStopState>(
      () => SkipRouteStopNotifier(
        skipRouteStopUseCase: SkipRouteStopUseCase(getIt<RouteRepository>()),
      ),
    );
