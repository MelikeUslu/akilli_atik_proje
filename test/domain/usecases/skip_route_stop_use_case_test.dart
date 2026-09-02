import 'package:flutter_test/flutter_test.dart';

import 'package:akilli_atik_proje/domain/entities/route.dart';
import 'package:akilli_atik_proje/domain/repositories/route_repository.dart';
import 'package:akilli_atik_proje/domain/usecases/skip_route_stop_use_case.dart';

void main() {
  late _FakeRouteRepository repository;
  late SkipRouteStopUseCase useCase;

  setUp(() {
    repository = _FakeRouteRepository();
    useCase = SkipRouteStopUseCase(repository);
  });

  group('SkipRouteStopUseCase', () {
    test('geçerli neden repositoryye gönderilir', () async {
      await useCase(
        routeId: 'route-1',
        stopId: 'stop-1',
        reason: '  Konteyner erişilemiyor.  ',
      );

      expect(repository.skipStopCallCount, 1);
      expect(repository.skippedRouteId, 'route-1');
      expect(repository.skippedStopId, 'stop-1');
      expect(repository.skipReason, 'Konteyner erişilemiyor.');
    });

    test('boş neden FormatException fırlatır', () {
      expect(
        () => useCase(routeId: 'route-1', stopId: 'stop-1', reason: '   '),
        throwsA(isA<FormatException>()),
      );

      expect(repository.skipStopCallCount, 0);
    });
  });
}

final class _FakeRouteRepository implements RouteRepository {
  int skipStopCallCount = 0;

  String? skippedRouteId;
  String? skippedStopId;
  String? skipReason;

  @override
  Future<void> skipStop({
    required String routeId,
    required String stopId,
    required String reason,
  }) async {
    skipStopCallCount++;

    skippedRouteId = routeId;
    skippedStopId = stopId;
    skipReason = reason;
  }

  @override
  Future<void> completeStop({required String routeId, required String stopId}) {
    throw UnimplementedError();
  }

  @override
  Future<Route> getActiveRoute({required String driverId}) {
    throw UnimplementedError();
  }
}
