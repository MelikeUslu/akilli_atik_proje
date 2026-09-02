import 'package:injectable/injectable.dart';
import 'package:signalr_netcore/signalr_client.dart';

@lazySingleton
final class SignalRClient {
  SignalRClient();

  HubConnection? _connection;

  HubConnectionState? get state => _connection?.state;

  bool get isConnected => _connection?.state == HubConnectionState.Connected;

  Future<void> connect({required String hubUrl, String? accessToken}) async {
    final normalizedHubUrl = hubUrl.trim();

    if (normalizedHubUrl.isEmpty) {
      throw const FormatException('SignalR Hub URL boş olamaz.');
    }

    if (isConnected) {
      return;
    }

    await disconnect();

    final httpConnectionOptions = HttpConnectionOptions(
      accessTokenFactory: accessToken == null || accessToken.trim().isEmpty
          ? null
          : () async => accessToken.trim(),
    );

    final connection = HubConnectionBuilder()
        .withUrl(normalizedHubUrl, options: httpConnectionOptions)
        .withAutomaticReconnect()
        .build();

    _connection = connection;

    try {
      await connection.start();
    } catch (_) {
      _connection = null;
      rethrow;
    }
  }

  void on(String methodName, void Function(List<Object?>? arguments) handler) {
    final connection = _connection;

    if (connection == null) {
      throw StateError('SignalR bağlantısı henüz oluşturulmadı.');
    }

    connection.on(methodName, handler);
  }

  void off(String methodName) {
    _connection?.off(methodName);
  }

  Future<Object?> invoke(String methodName, {List<Object>? args}) async {
    final connection = _connection;

    if (connection == null ||
        connection.state != HubConnectionState.Connected) {
      throw StateError('SignalR bağlantısı aktif değil.');
    }

    return connection.invoke(methodName, args: args ?? const <Object>[]);
  }

  Future<void> disconnect() async {
    final connection = _connection;

    if (connection == null) {
      return;
    }

    _connection = null;

    await connection.stop();
  }
}
