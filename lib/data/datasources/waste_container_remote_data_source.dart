import '../models/waste_container_model.dart';

abstract interface class WasteContainerRemoteDataSource {
  Future<List<WasteContainerModel>> getContainersByZone({
    required String zoneId,
  });
}
