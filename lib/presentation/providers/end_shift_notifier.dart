import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/shift.dart';
import '../../domain/usecases/end_shift_use_case.dart';
import 'end_shift_state.dart';

final class EndShiftNotifier extends Notifier<EndShiftState> {
  EndShiftNotifier({required this.endShiftUseCase});

  final EndShiftUseCase endShiftUseCase;

  @override
  EndShiftState build() {
    return const EndShiftState();
  }

  Future<Shift?> endShift({required String driverId}) async {
    if (state.isLoading) {
      return null;
    }

    final normalizedDriverId = driverId.trim();

    if (normalizedDriverId.isEmpty) {
      state = state.copyWith(
        status: EndShiftStatus.failure,
        errorMessage: 'Şoför bilgisi bulunamadı.',
      );

      return null;
    }

    state = state.copyWith(status: EndShiftStatus.loading, errorMessage: null);

    try {
      final shift = await endShiftUseCase(driverId: normalizedDriverId);

      state = state.copyWith(
        status: EndShiftStatus.success,
        shift: shift,
        errorMessage: null,
      );

      return shift;
    } catch (_) {
      state = state.copyWith(
        status: EndShiftStatus.failure,
        errorMessage: 'Vardiya sonlandırılamadı. Lütfen tekrar deneyin.',
      );

      return null;
    }
  }

  void clearError() {
    state = state.copyWith(status: EndShiftStatus.initial, errorMessage: null);
  }

  void reset() {
    state = const EndShiftState();
  }
}
