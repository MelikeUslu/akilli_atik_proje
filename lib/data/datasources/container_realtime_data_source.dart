abstract interface class ContainerRealtimeDataSource {
  Future<void> connect({required String hubUrl, required String accessToken});

  Future<void> disconnect();

  bool get isConnected;
}
