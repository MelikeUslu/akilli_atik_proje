import 'package:injectable/injectable.dart';

import '../datasources/route_remote_data_source.dart';
import '../models/offline_route_action_model.dart';
import 'offline_route_action_queue.dart';

@lazySingleton
final class OfflineRouteSyncService {
  const OfflineRouteSyncService({
    required this.remoteDataSource,
    required this.offlineRouteActionQueue,
  });

  final RouteRemoteDataSource remoteDataSource;
  final OfflineRouteActionQueue offlineRouteActionQueue;

  Future<void> synchronize() async {
    final pendingActions = await offlineRouteActionQueue.getPendingActions();

    for (final action in pendingActions) {
      final synchronized = await _synchronizeAction(action);

      if (!synchronized) {
        return;
      }

      await offlineRouteActionQueue.remove(actionId: action.id);
    }
  }

  Future<bool> _synchronizeAction(OfflineRouteActionModel action) async {
    try {
      switch (action.type) {
        case OfflineRouteActionType.completeStop:
          await remoteDataSource.completeStop(
            routeId: action.routeId,
            stopId: action.stopId,
          );

          return true;

        case OfflineRouteActionType.skipStop:
          return false;
      }
    } catch (_) {
      return false;
    }
  }
}
