import 'package:injectable/injectable.dart';

import '../../core/network/signalr_client.dart';
import 'container_realtime_data_source.dart';

@LazySingleton(as: ContainerRealtimeDataSource)
final class ContainerRealtimeDataSourceImpl
    implements ContainerRealtimeDataSource {
  const ContainerRealtimeDataSourceImpl(this._signalRClient);

  final SignalRClient _signalRClient;

  @override
  bool get isConnected => _signalRClient.isConnected;

  @override
  Future<void> connect({required String hubUrl, required String accessToken}) {
    return _signalRClient.connect(hubUrl: hubUrl, accessToken: accessToken);
  }

  @override
  Future<void> disconnect() {
    return _signalRClient.disconnect();
  }
}
