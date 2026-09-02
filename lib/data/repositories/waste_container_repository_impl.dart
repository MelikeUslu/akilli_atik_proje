import 'package:injectable/injectable.dart';

import '../../domain/entities/waste_container.dart';
import '../../domain/repositories/waste_container_repository.dart';
import '../datasources/waste_container_local_data_source.dart';
import '../datasources/waste_container_remote_data_source.dart';

@LazySingleton(as: WasteContainerRepository)
final class WasteContainerRepositoryImpl implements WasteContainerRepository {
  const WasteContainerRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final WasteContainerRemoteDataSource remoteDataSource;
  final WasteContainerLocalDataSource localDataSource;

  @override
  Future<List<WasteContainer>> getContainersByZone({
    required String zoneId,
  }) async {
    final normalizedZoneId = zoneId.trim();

    if (normalizedZoneId.isEmpty) {
      throw const FormatException('Bölge bilgisi boş olamaz.');
    }

    try {
      final models = await remoteDataSource.getContainersByZone(
        zoneId: normalizedZoneId,
      );

      await localDataSource.cacheContainers(
        zoneId: normalizedZoneId,
        containers: models,
      );

      return models.map((model) => model.toEntity()).toList(growable: false);
    } catch (_) {
      final cachedModels = await localDataSource.getCachedContainers(
        zoneId: normalizedZoneId,
      );

      if (cachedModels != null) {
        return cachedModels
            .map((model) => model.toEntity())
            .toList(growable: false);
      }

      rethrow;
    }
  }
}
