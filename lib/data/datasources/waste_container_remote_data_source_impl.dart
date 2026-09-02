import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/waste_container_model.dart';
import 'waste_container_remote_data_source.dart';

@LazySingleton(as: WasteContainerRemoteDataSource)
final class WasteContainerRemoteDataSourceImpl
    implements WasteContainerRemoteDataSource {
  const WasteContainerRemoteDataSourceImpl(
    this._dio,
    @Named('containersByZoneEndpoint') this._containersByZoneEndpoint,
  );

  final Dio _dio;
  final String _containersByZoneEndpoint;

  @override
  Future<List<WasteContainerModel>> getContainersByZone({
    required String zoneId,
  }) async {
    final endpoint = _containersByZoneEndpoint.replaceFirst(
      '{zoneId}',
      Uri.encodeComponent(zoneId),
    );

    final response = await _dio.get<dynamic>(endpoint);
    final data = response.data;

    if (data is! List<dynamic>) {
      throw const FormatException('Konteyner listesi beklenen formatta değil.');
    }

    return data
        .map<WasteContainerModel>(
          (item) => WasteContainerModel.fromJson(_asJsonMap(item)),
        )
        .toList(growable: false);
  }

  Map<String, dynamic> _asJsonMap(dynamic value) {
    if (value is! Map) {
      throw const FormatException('Konteyner verisi beklenen formatta değil.');
    }

    return Map<String, dynamic>.from(value);
  }
}
