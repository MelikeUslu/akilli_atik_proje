import '../../domain/entities/waste_container.dart';

enum ContainerStatus { initial, loading, success, failure }

final class ContainerState {
  const ContainerState({
    this.status = ContainerStatus.initial,
    this.containers = const <WasteContainer>[],
    this.errorMessage,
  });

  static const Object _unset = Object();

  final ContainerStatus status;
  final List<WasteContainer> containers;
  final String? errorMessage;

  bool get isLoading => status == ContainerStatus.loading;

  bool get hasContainers => containers.isNotEmpty;

  int get totalContainerCount => containers.length;

  int get criticalContainerCount {
    return containers.where((container) => container.isCritical).length;
  }

  WasteContainer? findById(String containerId) {
    for (final container in containers) {
      if (container.id == containerId) {
        return container;
      }
    }

    return null;
  }

  ContainerState copyWith({
    ContainerStatus? status,
    List<WasteContainer>? containers,
    Object? errorMessage = _unset,
  }) {
    return ContainerState(
      status: status ?? this.status,
      containers: containers ?? this.containers,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
