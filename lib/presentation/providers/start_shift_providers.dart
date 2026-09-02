import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/connectivity_service.dart';
import '../../di/injection.dart';
import '../../domain/usecases/start_shift_use_case.dart';
import 'start_shift_notifier.dart';
import 'start_shift_state.dart';

final startShiftProvider =
    NotifierProvider<StartShiftNotifier, StartShiftState>(
      () => StartShiftNotifier(
        connectivityService: getIt<ConnectivityService>(),
        startShiftUseCase: getIt<StartShiftUseCase>(),
      ),
    );
