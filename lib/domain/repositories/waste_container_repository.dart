import '../entities/waste_container.dart';

abstract interface class WasteContainerRepository {
  Future<List<WasteContainer>> getContainersByZone({required String zoneId});
}
