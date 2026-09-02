import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/shift_model.dart';
import 'shift_remote_data_source.dart';

@LazySingleton(as: ShiftRemoteDataSource)
final class ShiftRemoteDataSourceImpl implements ShiftRemoteDataSource {
  const ShiftRemoteDataSourceImpl({
    required this.dio,
    @Named('startShiftEndpoint') required this.startShiftEndpoint,
    @Named('endShiftEndpoint') required this.endShiftEndpoint,
  });

  final Dio dio;
  final String startShiftEndpoint;
  final String endShiftEndpoint;

  @override
  Future<ShiftModel> startShift({required String driverId}) async {
    final normalizedDriverId = driverId.trim();

    if (normalizedDriverId.isEmpty) {
      throw const FormatException('Şoför bilgisi boş olamaz.');
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
