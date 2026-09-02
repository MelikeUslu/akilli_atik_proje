import '../repositories/route_repository.dart';

final class SkipRouteStopUseCase {
  const SkipRouteStopUseCase(this._repository);

  final RouteRepository _repository;

  Future<void> call({
    required String routeId,
    required String stopId,
    required String reason,
  }) {
    final normalizedReason = reason.trim();

    if (normalizedReason.isEmpty) {
      throw const FormatException('Durak atlama nedeni boş olamaz.');
    }

    return _repository.skipStop(
      routeId: routeId,
      stopId: stopId,
      reason: normalizedReason,
    );
  }
}
