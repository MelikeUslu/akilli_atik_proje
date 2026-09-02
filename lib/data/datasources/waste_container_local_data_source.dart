import '../models/waste_container_model.dart';

abstract interface class WasteContainerLocalDataSource {
  Future<void> cacheContainers({
    required String zoneId,
    required List<WasteContainerModel> containers,
  });

  Future<List<WasteContainerModel>?> getCachedContainers({
    required String zoneId,
  });

  Future<void> clearContainers({required String zoneId});

  Future<void> clearAllContainers();
}
