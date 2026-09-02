import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/location.dart';
import '../../domain/entities/route.dart';
import '../../domain/usecases/complete_route_stop_use_case.dart';
import 'complete_route_stop_state.dart';

final class CompleteRouteStopNotifier extends Notifier<CompleteRouteStopState> {
  CompleteRouteStopNotifier({required this.completeRouteStopUseCase});

  final CompleteRouteStopUseCase completeRouteStopUseCase;

  @override
  CompleteRouteStopState build() {
    return const CompleteRouteStopState();
  }

  Future<bool> completeStop({
    required Route route,
    required String stopId,
    required Location currentLocation,
  }) async {
    if (state.isLoading) {
      return false;
    }

    state = state.copyWith(
      status: CompleteRouteStopStatus.loading,
      errorMessage: null,
    );

    try {
      await completeRouteStopUseCase(
        route: route,
        stopId: stopId,
        currentLocation: currentLocation,
      );

      state = state.copyWith(
        status: CompleteRouteStopStatus.success,
        errorMessage: null,
      );

      return true;
    } on FormatException catch (error) {
      state = state.copyWith(
        status: CompleteRouteStopStatus.failure,
        errorMessage: error.message.toString(),
      );

      return false;
    } on StateError catch (error) {
      state = state.copyWith(
        status: CompleteRouteStopStatus.failure,
        errorMessage: error.message.toString(),
      );

      return false;
    } catch (_) {
      state = state.copyWith(
        status: CompleteRouteStopStatus.failure,
        errorMessage: 'Durak tamamlama işlemi gerçekleştirilemedi.',
      );

      return false;
    }
  }

  void reset() {
    state = const CompleteRouteStopState();
  }
}
