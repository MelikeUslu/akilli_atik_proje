import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_containers_by_zone_use_case.dart';
import 'container_state.dart';

final class ContainerNotifier extends StateNotifier<ContainerState> {
  ContainerNotifier(this._getContainersByZoneUseCase)
    : super(const ContainerState());

  final GetContainersByZoneUseCase _getContainersByZoneUseCase;

  Future<void> loadContainers({required String zoneId}) async {
    if (state.isLoading) {
      return;
    }

    state = state.copyWith(status: ContainerStatus.loading, errorMessage: null);

    try {
      final containers = await _getContainersByZoneUseCase(zoneId: zoneId);

      state = state.copyWith(
        status: ContainerStatus.success,
        containers: containers,
        errorMessage: null,
      );
    } on FormatException catch (error) {
      state = state.copyWith(
        status: ContainerStatus.failure,
        errorMessage: error.message,
      );
    } catch (_) {
      state = state.copyWith(
        status: ContainerStatus.failure,
        errorMessage: 'Konteyner bilgileri alınamadı.',
      );
    }
  }

  void clear() {
    state = const ContainerState();
  }
}
