import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/injection.dart';
import '../../domain/usecases/get_containers_by_zone_use_case.dart';
import 'container_notifier.dart';
import 'container_state.dart';

final containerProvider =
    StateNotifierProvider<ContainerNotifier, ContainerState>(
      (ref) => ContainerNotifier(getIt<GetContainersByZoneUseCase>()),
    );
