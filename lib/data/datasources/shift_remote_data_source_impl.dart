import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../core/constants/demo_config.dart';
import '../models/shift_model.dart';
import '../services/demo_waste_data_service.dart';
import 'shift_remote_data_source.dart';

@LazySingleton(as: ShiftRemoteDataSource)
final class ShiftRemoteDataSourceImpl implements ShiftRemoteDataSource {
  const ShiftRemoteDataSourceImpl({
    required this.dio,
    required this.demoWasteDataService,
    @Named('startShiftEndpoint') required this.startShiftEndpoint,
    @Named('endShiftEndpoint') required this.endShiftEndpoint,
  });

  final Dio dio;
  final DemoWasteDataService demoWasteDataService;

  final String startShiftEndpoint;
  final String endShiftEndpoint;

  @override
  Future<ShiftModel> startShift({required String driverId}) async {
    final normalizedDriverId = driverId.trim();

    if (normalizedDriverId.isEmpty) {
      throw const FormatException('Şoför bilgisi boş olamaz.');
    }

    if (DemoConfig.enabled) {
      await demoWasteDataService.startShift(driverId: normalizedDriverId);

      return ShiftModel(
        id: 'demo-shift-$normalizedDriverId',
        driverId: normalizedDriverId,
        startedAt: DateTime.now(),
        status: 'active',
      );
    }

    final endpoint = startShiftEndpoint.replaceFirst(
      '{id}',
      Uri.encodeComponent(normalizedDriverId),
    );

    final response = await dio.post<Map<String, dynamic>>(endpoint);

    final responseData = response.data;

    if (responseData == null) {
      throw const FormatException(
        'Sunucudan geçerli bir vardiya cevabı alınamadı.',
      );
    }

    return ShiftModel.fromJson(responseData);
  }

  @override
  Future<ShiftModel> endShift({required String driverId}) async {
    final normalizedDriverId = driverId.trim();

    if (normalizedDriverId.isEmpty) {
      throw const FormatException('Şoför bilgisi boş olamaz.');
    }

    if (DemoConfig.enabled) {
      await demoWasteDataService.endShift(driverId: normalizedDriverId);

      final now = DateTime.now();

      return ShiftModel(
        id: 'demo-shift-$normalizedDriverId',
        driverId: normalizedDriverId,
        startedAt: now,
        endedAt: now,
        status: 'completed',
      );
    }

    final endpoint = endShiftEndpoint.replaceFirst(
      '{id}',
      Uri.encodeComponent(normalizedDriverId),
    );

    final response = await dio.post<Map<String, dynamic>>(endpoint);

    final responseData = response.data;

    if (responseData == null) {
      throw const FormatException(
        'Sunucudan geçerli bir vardiya sonlandırma cevabı alınamadı.',
      );
    }

    return ShiftModel.fromJson(responseData);
  }
}
