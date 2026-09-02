import '../models/offline_route_action_model.dart';

abstract interface class OfflineRouteActionLocalDataSource {
  Future<void> enqueue(OfflineRouteActionModel action);

  Future<List<OfflineRouteActionModel>> getPendingActions();

  Future<void> remove({required String actionId});

  Future<void> clear();
}
