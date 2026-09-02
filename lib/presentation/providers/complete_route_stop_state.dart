enum CompleteRouteStopStatus { initial, loading, success, failure }

final class CompleteRouteStopState {
  const CompleteRouteStopState({
    this.status = CompleteRouteStopStatus.initial,
    this.errorMessage,
  });

  static const Object _unset = Object();

  final CompleteRouteStopStatus status;
  final String? errorMessage;

  bool get isLoading => status == CompleteRouteStopStatus.loading;

  bool get isSuccessful => status == CompleteRouteStopStatus.success;

  CompleteRouteStopState copyWith({
    CompleteRouteStopStatus? status,
    Object? errorMessage = _unset,
  }) {
    return CompleteRouteStopState(
      status: status ?? this.status,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
