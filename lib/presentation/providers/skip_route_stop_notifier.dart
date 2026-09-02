import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/skip_route_stop_use_case.dart';
import 'skip_route_stop_state.dart';

final class SkipRouteStopNotifier extends Notifier<SkipRouteStopState> {
  SkipRouteStopNotifier({required this.skipRouteStopUseCase});

  final SkipRouteStopUseCase skipRouteStopUseCase;

  @override
  SkipRouteStopState build() {
    return const SkipRouteStopState();
  }

  Future<bool> skipStop({
    required String routeId,
    required String stopId,
    required String reason,
  }) async {
    if (state.isLoading) {
      return false;
    }

    state = state.copyWith(
      status: SkipRouteStopStatus.loading,
      errorMessage: null,
    );

    try {
      await skipRouteStopUseCase(
        routeId: routeId,
        stopId: stopId,
        reason: reason,
      );

      state = state.copyWith(
        status: SkipRouteStopStatus.success,
        errorMessage: null,
      );

      return true;
    } on FormatException catch (error) {
      state = state.copyWith(
        status: SkipRouteStopStatus.failure,
        errorMessage: error.message.toString(),
      );

      return false;
    } catch (_) {
      state = state.copyWith(
        status: SkipRouteStopStatus.failure,
        errorMessage: 'Durak atlama işlemi gerçekleştirilemedi.',
      );

      return false;
    }
  }

  void reset() {
    state = const SkipRouteStopState();
  }
}
