enum SkipRouteStopStatus { initial, loading, success, failure }

final class SkipRouteStopState {
  const SkipRouteStopState({
    this.status = SkipRouteStopStatus.initial,
    this.errorMessage,
  });

  final SkipRouteStopStatus status;
  final String? errorMessage;

  bool get isLoading => status == SkipRouteStopStatus.loading;

  bool get isSuccessful => status == SkipRouteStopStatus.success;

  SkipRouteStopState copyWith({
    SkipRouteStopStatus? status,
    Object? errorMessage = _unset,
  }) {
    return SkipRouteStopState(
      status: status ?? this.status,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}

const Object _unset = Object();
