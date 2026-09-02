import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection.dart';
import '../../domain/repositories/shift_repository.dart';
import '../../domain/usecases/end_shift_use_case.dart';
import 'end_shift_notifier.dart';
import 'end_shift_state.dart';

final endShiftProvider = NotifierProvider<EndShiftNotifier, EndShiftState>(
  () => EndShiftNotifier(
    endShiftUseCase: EndShiftUseCase(getIt<ShiftRepository>()),
  ),
);
