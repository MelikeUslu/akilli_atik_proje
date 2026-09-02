import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/connectivity_service.dart';
import '../../domain/usecases/start_shift_use_case.dart';
import 'start_shift_state.dart';

final class StartShiftNotifier extends Notifier<StartShiftState> {
  StartShiftNotifier({
    required this.connectivityService,
    required this.startShiftUseCase,
  });

  final ConnectivityService connectivityService;
  final StartShiftUseCase startShiftUseCase;

  StreamSubscription<bool>? _connectivitySubscription;

  @override
  StartShiftState build() {
    ref.onDispose(() {
      _connectivitySubscription?.cancel();
    });

    Future.microtask(_initializeConnectivity);

    return const StartShiftState();
  }

  Future<void> startShift({required String driverId}) async {
    if (!state.canStartShift) {
      return;
    }

    final normalizedDriverId = driverId.trim();

    if (normalizedDriverId.isEmpty) {
      state = state.copyWith(
        status: StartShiftStatus.failure,
        errorMessage: 'Şoför bilgisi bulunamadı.',
      );
      return;
    }

    state = state.copyWith(
      status: StartShiftStatus.loading,
      errorMessage: null,
    );

    try {
      final shift = await startShiftUseCase(driverId: normalizedDriverId);

      state = state.copyWith(
        status: StartShiftStatus.success,
        shift: shift,
        errorMessage: null,
      );
    } catch (_) {
      state = state.copyWith(
        status: StartShiftStatus.failure,
        errorMessage: 'Vardiya başlatılamadı. Lütfen tekrar deneyin.',
      );
    }
  }

  void clearActiveShift() {
    state = state.copyWith(
      status: StartShiftStatus.initial,
      shift: null,
      errorMessage: null,
    );
  }

  void clearError() {
    state = state.copyWith(
      status: state.hasActiveShift
          ? StartShiftStatus.success
          : StartShiftStatus.initial,
      errorMessage: null,
    );
  }

  Future<void> _initializeConnectivity() async {
    final isOnline = await connectivityService.isConnected;

    state = state.copyWith(isOnline: isOnline);

    await _connectivitySubscription?.cancel();

    _connectivitySubscription = connectivityService.connectionStream.listen((
      isOnline,
    ) {
      state = state.copyWith(isOnline: isOnline);
    });
  }
}
