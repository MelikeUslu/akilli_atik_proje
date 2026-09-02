import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
final class ConnectivityService {
  ConnectivityService(this._connectivity);

  final Connectivity _connectivity;

  Stream<bool> get connectionStream {
    return _connectivity.onConnectivityChanged.map(_hasNetworkConnection);
  }

  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();

    return _hasNetworkConnection(result);
  }

  bool _hasNetworkConnection(List<ConnectivityResult> results) {
    if (results.isEmpty) {
      return false;
    }

    return results.any((result) => result != ConnectivityResult.none);
  }
}
