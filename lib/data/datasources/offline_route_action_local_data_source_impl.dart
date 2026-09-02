import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../core/constants/hive_box_names.dart';
import '../models/offline_route_action_model.dart';
import 'offline_route_action_local_data_source.dart';

@LazySingleton(as: OfflineRouteActionLocalDataSource)
final class OfflineRouteActionLocalDataSourceImpl
    implements OfflineRouteActionLocalDataSource {
  Future<Box<dynamic>> _openBox() {
    return Hive.openBox<dynamic>(HiveBoxNames.offlineActions);
  }

  @override
  Future<void> enqueue(OfflineRouteActionModel action) async {
    final box = await _openBox();

    await box.put(action.id, action.toJson());
  }

  @override
  Future<List<OfflineRouteActionModel>> getPendingActions() async {
    final box = await _openBox();

    final actions = <OfflineRouteActionModel>[];

    for (final value in box.values) {
      if (value is! Map) {
        continue;
      }

      try {
        actions.add(
          OfflineRouteActionModel.fromJson(Map<String, dynamic>.from(value)),
        );
      } on FormatException {
        continue;
      } on TypeError {
        continue;
      }
    }

    actions.sort(
      (first, second) => first.createdAt.compareTo(second.createdAt),
    );

    return List.unmodifiable(actions);
  }

  @override
  Future<void> remove({required String actionId}) async {
    final normalizedActionId = actionId.trim();

    if (normalizedActionId.isEmpty) {
      return;
    }

    final box = await _openBox();

    await box.delete(normalizedActionId);
  }

  @override
  Future<void> clear() async {
    final box = await _openBox();

    await box.clear();
  }
}
