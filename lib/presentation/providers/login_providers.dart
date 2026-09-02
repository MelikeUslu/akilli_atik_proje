import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection.dart';
import '../../domain/usecases/biometric_login_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import 'login_notifier.dart';
import 'login_state.dart';

final loginProvider = NotifierProvider<LoginNotifier, LoginState>(
  () => LoginNotifier(
    loginUseCase: getIt<LoginUseCase>(),
    biometricLoginUseCase: getIt<BiometricLoginUseCase>(),
  ),
);
