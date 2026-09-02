import '../../domain/entities/shift.dart';

enum EndShiftStatus { initial, loading, success, failure }

final class EndShiftState {
  const EndShiftState({
    this.status = EndShiftStatus.initial,
    this.shift,
    this.errorMessage,
  });

  static const Object _unset = Object();

  final EndShiftStatus status;
  final Shift? shift;
  final String? errorMessage;

  bool get isLoading => status == EndShiftStatus.loading;

  bool get isSuccessful => status == EndShiftStatus.success;

  bool get isCompleted => shift?.status == ShiftStatus.completed;

  EndShiftState copyWith({
    EndShiftStatus? status,
    Object? shift = _unset,
    Object? errorMessage = _unset,
  }) {
    return EndShiftState(
      status: status ?? this.status,
      shift: identical(shift, _unset) ? this.shift : shift as Shift?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }
}
