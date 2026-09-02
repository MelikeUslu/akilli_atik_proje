import 'package:flutter_test/flutter_test.dart';

import 'package:akilli_atik_proje/domain/entities/location.dart';
import 'package:akilli_atik_proje/domain/entities/route.dart';
import 'package:akilli_atik_proje/domain/entities/route_stop.dart';
import 'package:akilli_atik_proje/domain/repositories/route_repository.dart';
import 'package:akilli_atik_proje/domain/usecases/complete_route_stop_use_case.dart';

void main() {
  late _FakeRouteRepository repository;
  late CompleteRouteStopUseCase useCase;

  setUp(() {
    repository = _FakeRouteRepository();
    useCase = CompleteRouteStopUseCase(repository);
  });

  group('CompleteRouteStopUseCase', () {
    test(
      'sıradaki durak 50 metre içindeyse repository completeStop çağrılır',
      () async {
        const stop = RouteStop(
          id: 'stop-1',
          containerId: 'container-1',
          order: 1,
          location: Location(latitude: 39.920770, longitude: 32.854110),
          isCompleted: false,
        );

        const route = Route(
          id: 'route-1',
          driverId: 'driver-1',
          stops: [stop],
          totalDistanceKm: 1.2,
        );

        const currentLocation = Location(
          latitude: 39.920770,
          longitude: 32.854110,
        );

        await useCase(
          route: route,
          stopId: stop.id,
          currentLocation: currentLocation,
        );

        expect(repository.completeStopCallCount, 1);
        expect(repository.completedRouteId, 'route-1');
        expect(repository.completedStopId, 'stop-1');
      },
    );

    test('konteyner 50 metreden uzaktaysa StateError fırlatır', () async {
      const stop = RouteStop(
        id: 'stop-1',
        containerId: 'container-1',
        order: 1,
        location: Location(latitude: 39.920770, longitude: 32.854110),
        isCompleted: false,
      );

      const route = Route(
        id: 'route-1',
        driverId: 'driver-1',
        stops: [stop],
        totalDistanceKm: 1.2,
      );

      const currentLocation = Location(
        latitude: 39.930770,
        longitude: 32.854110,
      );

      expect(
        () => useCase(
          route: route,
          stopId: stop.id,
          currentLocation: currentLocation,
        ),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('50 metre'),
          ),
        ),
      );

      expect(repository.completeStopCallCount, 0);
    });

    test('sıradaki durak olmayan bir durak tamamlanamaz', () async {
      const firstStop = RouteStop(
        id: 'stop-1',
        containerId: 'container-1',
        order: 1,
        location: Location(latitude: 39.920770, longitude: 32.854110),
        isCompleted: false,
      );

      const secondStop = RouteStop(
        id: 'stop-2',
        containerId: 'container-2',
        order: 2,
        location: Location(latitude: 39.920770, longitude: 32.854110),
        isCompleted: false,
      );

      const route = Route(
        id: 'route-1',
        driverId: 'driver-1',
        stops: [firstStop, secondStop],
        totalDistanceKm: 2.4,
      );

      const currentLocation = Location(
        latitude: 39.920770,
        longitude: 32.854110,
      );

      expect(
        () => useCase(
          route: route,
          stopId: secondStop.id,
          currentLocation: currentLocation,
        ),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            'Duraklar sırayla tamamlanmalıdır.',
          ),
        ),
      );

      expect(repository.completeStopCallCount, 0);
    });

    test('zaten tamamlanmış durak tekrar tamamlanamaz', () async {
      const stop = RouteStop(
        id: 'stop-1',
        containerId: 'container-1',
        order: 1,
        location: Location(latitude: 39.920770, longitude: 32.854110),
        isCompleted: true,
      );

      const route = Route(
        id: 'route-1',
        driverId: 'driver-1',
        stops: [stop],
        totalDistanceKm: 1.2,
      );

      const currentLocation = Location(
        latitude: 39.920770,
        longitude: 32.854110,
      );

      expect(
        () => useCase(
          route: route,
          stopId: stop.id,
          currentLocation: currentLocation,
        ),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            'Bu durak zaten tamamlandı.',
          ),
        ),
      );

      expect(repository.completeStopCallCount, 0);
    });

    test('boş stopId FormatException fırlatır', () async {
      const route = Route(
        id: 'route-1',
        driverId: 'driver-1',
        stops: [],
        totalDistanceKm: 0,
      );

      const currentLocation = Location(
        latitude: 39.920770,
        longitude: 32.854110,
      );

      expect(
        () => useCase(
          route: route,
          stopId: '   ',
          currentLocation: currentLocation,
        ),
        throwsA(isA<FormatException>()),
      );

      expect(repository.completeStopCallCount, 0);
    });
  });
}

final class _FakeRouteRepository implements RouteRepository {
  int completeStopCallCount = 0;

  String? completedRouteId;
  String? completedStopId;

  @override
  Future<void> completeStop({
    required String routeId,
    required String stopId,
  }) async {
    completeStopCallCount++;
    completedRouteId = routeId;
    completedStopId = stopId;
  }

  @override
  Future<Route> getActiveRoute({required String driverId}) {
    throw UnimplementedError();
  }

  @override
  Future<void> skipStop({
    required String routeId,
    required String stopId,
    required String reason,
  }) {
    throw UnimplementedError();
  }
}
