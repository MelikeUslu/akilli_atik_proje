import 'package:injectable/injectable.dart';

import '../entities/waste_container.dart';
import '../repositories/waste_container_repository.dart';

@lazySingleton
final class GetContainersByZoneUseCase {
  const GetContainersByZoneUseCase(this._repository);

  final WasteContainerRepository _repository;

  Future<List<WasteContainer>> call({required String zoneId}) {
    final normalizedZoneId = zoneId.trim();

    if (normalizedZoneId.isEmpty) {
      throw const FormatException('Bölge bilgisi boş olamaz.');
    }

    return _repository.getContainersByZone(zoneId: normalizedZoneId);
  }
}
