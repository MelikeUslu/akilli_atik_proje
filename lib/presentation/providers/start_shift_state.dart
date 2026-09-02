import '../../domain/entities/shift.dart';

enum StartShiftStatus { initial, loading, success, failure }

final class StartShiftState {
  const StartShiftState({
    this.status = StartShiftStatus.initial,
    this.isOnline = false,
    this.shift,
    this.errorMessage,
  });

  static const Object _unset = Object();

  final StartShiftStatus status;
  final bool isOnline;
  final Shift? shift;
  final String? errorMessage;

  bool get isLoading => status == StartShiftStatus.loading;

  bool get isSuccessful => status == StartShiftStatus.success;

  bool get hasActiveShift => shift?.isActive ?? false;

  bool get canStartShift => isOnline && !isLoading && !hasActiveShift;

  StartShiftState copyWith({
    StartShiftStatus? status,
    bool? isOnline,
    Object? shift = _unset,
    Object? errorMessage = _unset,
  }) {
    return StartShiftState(
      status: status ?? this.status,
      isOnline: isOnline ?? this.isOnline,
      shift: identical(shift, _unset) ? this.shift : shift as Shift?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
