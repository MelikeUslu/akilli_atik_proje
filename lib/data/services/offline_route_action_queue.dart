import 'dart:math';

import 'package:injectable/injectable.dart';

import '../datasources/offline_route_action_local_data_source.dart';
import '../models/offline_route_action_model.dart';

@lazySingleton
final class OfflineRouteActionQueue {
  const OfflineRouteActionQueue({required this.localDataSource});

  final OfflineRouteActionLocalDataSource localDataSource;

  Future<void> enqueueCompleteStop({
    required String routeId,
    required String stopId,
  }) {
    final normalizedRouteId = routeId.trim();
    final normalizedStopId = stopId.trim();

    if (normalizedRouteId.isEmpty) {
      throw const FormatException('Rota bilgisi boş olamaz.');
    }

    if (normalizedStopId.isEmpty) {
      throw const FormatException('Durak bilgisi boş olamaz.');
    }

    return localDataSource.enqueue(
      OfflineRouteActionModel(
        id: _createLocalId(),
        type: OfflineRouteActionType.completeStop,
        routeId: normalizedRouteId,
        stopId: normalizedStopId,
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }

  Future<void> enqueueSkipStop({
    required String routeId,
    required String stopId,
    required String reason,
  }) {
    final normalizedRouteId = routeId.trim();
    final normalizedStopId = stopId.trim();
    final normalizedReason = reason.trim();

    if (normalizedRouteId.isEmpty) {
      throw const FormatException('Rota bilgisi boş olamaz.');
    }

    if (normalizedStopId.isEmpty) {
      throw const FormatException('Durak bilgisi boş olamaz.');
    }

    if (normalizedReason.isEmpty) {
      throw const FormatException('Durak atlama nedeni boş olamaz.');
    }

    return localDataSource.enqueue(
      OfflineRouteActionModel(
        id: _createLocalId(),
        type: OfflineRouteActionType.skipStop,
        routeId: normalizedRouteId,
        stopId: normalizedStopId,
        reason: normalizedReason,
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }

  Future<List<OfflineRouteActionModel>> getPendingActions() {
    return localDataSource.getPendingActions();
  }

  Future<void> remove({required String actionId}) {
    return localDataSource.remove(actionId: actionId);
  }

  String _createLocalId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;

    final random = Random.secure().nextInt(1 << 32);

    return '$timestamp-$random';
  }
}
