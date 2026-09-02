import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../core/constants/hive_box_names.dart';
import '../models/waste_container_model.dart';
import 'waste_container_local_data_source.dart';

@LazySingleton(as: WasteContainerLocalDataSource)
final class WasteContainerLocalDataSourceImpl
    implements WasteContainerLocalDataSource {
  Future<Box<dynamic>> _openBox() {
    return Hive.openBox<dynamic>(HiveBoxNames.wasteContainers);
  }

  @override
  Future<void> cacheContainers({
    required String zoneId,
    required List<WasteContainerModel> containers,
  }) async {
    final normalizedZoneId = zoneId.trim();

    if (normalizedZoneId.isEmpty) {
      throw const FormatException('Bölge bilgisi boş olamaz.');
    }

    final box = await _openBox();

    final data = containers
        .map((container) => container.toJson())
        .toList(growable: false);

    await box.put(normalizedZoneId, data);
  }

  @override
  Future<List<WasteContainerModel>?> getCachedContainers({
    required String zoneId,
  }) async {
    final normalizedZoneId = zoneId.trim();

    if (normalizedZoneId.isEmpty) {
      return null;
    }

    final box = await _openBox();

    final rawContainers = box.get(normalizedZoneId);

    if (rawContainers is! List) {
      return null;
    }

    try {
      return rawContainers
          .map<WasteContainerModel>((item) {
            if (item is! Map) {
              throw const FormatException('Cache konteyner verisi geçersiz.');
            }

            return WasteContainerModel.fromJson(
              Map<String, dynamic>.from(item),
            );
          })
          .toList(growable: false);
    } on FormatException {
      await box.delete(normalizedZoneId);
      return null;
    } on TypeError {
      await box.delete(normalizedZoneId);
      return null;
    }
  }

  @override
  Future<void> clearContainers({required String zoneId}) async {
    final normalizedZoneId = zoneId.trim();

    if (normalizedZoneId.isEmpty) {
      return;
    }

    final box = await _openBox();

    await box.delete(normalizedZoneId);
  }

  @override
  Future<void> clearAllContainers() async {
    final box = await _openBox();

    await box.clear();
  }
}
