import '../../core/network/signalr_client.dart';
import '../../domain/entities/location.dart';
import 'driver_location_signalr_data_source.dart';

final class DriverLocationSignalRDataSourceImpl
    implements DriverLocationSignalRDataSource {
  const DriverLocationSignalRDataSourceImpl({required this.signalRClient});

  final SignalRClient signalRClient;

  @override
  Future<void> sendLocation({
    required String driverId,
    required Location location,
  }) async {
    final normalizedDriverId = driverId.trim();

    if (normalizedDriverId.isEmpty) {
      throw const FormatException('Şoför bilgisi boş olamaz.');
    }

    if (!location.isValid) {
      throw const FormatException('Geçersiz konum bilgisi.');
    }

    if (!signalRClient.isConnected) {
      throw StateError('Konum bildirimi için SignalR bağlantısı aktif değil.');
    }

    throw UnsupportedError(
      'Location Hub method adı ve request payload sözleşmesi backend tarafından henüz tanımlanmadı.',
    );
  }
}
