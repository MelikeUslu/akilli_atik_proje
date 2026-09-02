import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../models/route_model.dart';
import 'route_remote_data_source.dart';

@LazySingleton(as: RouteRemoteDataSource)
final class RouteRemoteDataSourceImpl implements RouteRemoteDataSource {
  const RouteRemoteDataSourceImpl({
    required this.dio,
    @Named('activeRouteEndpoint') required this.activeRouteEndpoint,
    @Named('completeRouteStopEndpoint') required this.completeRouteStopEndpoint,
    @Named('skipRouteStopEndpoint') required this.skipRouteStopEndpoint,
  });

  final Dio dio;
  final String activeRouteEndpoint;
  final String completeRouteStopEndpoint;
  final String skipRouteStopEndpoint;

  @override
  Future<RouteModel> getActiveRoute({required String driverId}) async {
    final normalizedDriverId = driverId.trim();

    if (normalizedDriverId.isEmpty) {
      throw const FormatException('Şoför bilgisi boş olamaz.');
    }

    final endpoint = activeRouteEndpoint.replaceFirst(
      '{id}',
      Uri.encodeComponent(normalizedDriverId),
    );

    final response = await dio.get<Map<String, dynamic>>(endpoint);

    final responseData = response.data;

    if (responseData == null) {
      throw const FormatException(
        'Sunucudan geçerli bir aktif rota cevabı alınamadı.',
      );
    }

    return RouteModel.fromJson(responseData);
  }

  @override
  Future<void> completeStop({
    required String routeId,
    required String stopId,
  }) async {
    final normalizedRouteId = routeId.trim();
    final normalizedStopId = stopId.trim();

    if (normalizedRouteId.isEmpty) {
      throw const FormatException('Rota bilgisi boş olamaz.');
    }

    if (normalizedStopId.isEmpty) {
      throw const FormatException('Durak bilgisi boş olamaz.');
    }

    final endpoint = completeRouteStopEndpoint
        .replaceFirst('{id}', Uri.encodeComponent(normalizedRouteId))
        .replaceFirst('{stopId}', Uri.encodeComponent(normalizedStopId));

    await dio.put<void>(endpoint);
  }

  @override
  Future<void> skipStop({
    required String routeId,
    required String stopId,
    required String reason,
  }) async {
    final normalizedRouteId = routeId.trim();
    final normalizedStopId = stopId.trim();
    final normalizedReason = reason.trim();

    if (normalizedRouteId.isEmpty) {
      throw const FormatException('Rota bilgisi boş olamaz.');
    }

    if (normalizedStopId.isEmpty) {
      throw const FormatException('Durak bilgisi boş olamaz.');
    }

    if (normalizedReason.isEmpty) {
      throw const FormatException('Durak atlama nedeni boş olamaz.');
    }

    final endpoint = skipRouteStopEndpoint
        .replaceFirst('{id}', Uri.encodeComponent(normalizedRouteId))
        .replaceFirst('{stopId}', Uri.encodeComponent(normalizedStopId));

    throw UnsupportedError(
      'Durak atlama isteğinin backend request body sözleşmesi henüz tanımlanmadı: $endpoint',
    );
  }
}
