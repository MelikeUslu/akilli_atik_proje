import 'package:flutter_test/flutter_test.dart';

import 'package:akilli_atik_proje/domain/entities/location.dart';
import 'package:akilli_atik_proje/domain/entities/route.dart';
import 'package:akilli_atik_proje/domain/entities/route_stop.dart';

void main() {
  const location = Location(latitude: 39.920770, longitude: 32.854110);

  const firstStop = RouteStop(
    id: 'stop-1',
    containerId: 'container-1',
    order: 1,
    location: location,
    isCompleted: true,
  );

  const secondStop = RouteStop(
    id: 'stop-2',
    containerId: 'container-2',
    order: 2,
    location: location,
    isCompleted: false,
  );

  const thirdStop = RouteStop(
    id: 'stop-3',
    containerId: 'container-3',
    order: 3,
    location: location,
    isCompleted: false,
  );

  group('Route', () {
    test('totalStopCount toplam durak sayısını döner', () {
      const route = Route(
        id: 'route-1',
        driverId: 'driver-1',
        stops: [firstStop, secondStop, thirdStop],
        totalDistanceKm: 4.2,
      );

      expect(route.totalStopCount, 3);
    });

    test('completedStopCount tamamlanan durakları sayar', () {
      const route = Route(
        id: 'route-1',
        driverId: 'driver-1',
        stops: [firstStop, secondStop, thirdStop],
        totalDistanceKm: 4.2,
      );

      expect(route.completedStopCount, 1);
    });

    test('remainingStopCount kalan durakları doğru hesaplar', () {
      const route = Route(
        id: 'route-1',
        driverId: 'driver-1',
        stops: [firstStop, secondStop, thirdStop],
        totalDistanceKm: 4.2,
      );

      expect(route.remainingStopCount, 2);
    });

    test('nextStop ilk tamamlanmamış durağı döner', () {
      const route = Route(
        id: 'route-1',
        driverId: 'driver-1',
        stops: [firstStop, secondStop, thirdStop],
        totalDistanceKm: 4.2,
      );

      expect(route.nextStop, secondStop);
    });

    test('currentStopNumber sıradaki durak numarasını döner', () {
      const route = Route(
        id: 'route-1',
        driverId: 'driver-1',
        stops: [firstStop, secondStop, thirdStop],
        totalDistanceKm: 4.2,
      );

      expect(route.currentStopNumber, 2);
    });

    test('tüm duraklar tamamlandığında rota tamamlanmıştır', () {
      const completedSecondStop = RouteStop(
        id: 'stop-2',
        containerId: 'container-2',
        order: 2,
        location: location,
        isCompleted: true,
      );

      const route = Route(
        id: 'route-1',
        driverId: 'driver-1',
        stops: [firstStop, completedSecondStop],
        totalDistanceKm: 2.5,
      );

      expect(route.isCompleted, isTrue);
      expect(route.nextStop, isNull);
      expect(route.currentStopNumber, 2);
      expect(route.remainingStopCount, 0);
    });

    test('boş rota tamamlanmış kabul edilmez', () {
      const route = Route(
        id: 'route-1',
        driverId: 'driver-1',
        stops: [],
        totalDistanceKm: 0,
      );

      expect(route.totalStopCount, 0);
      expect(route.completedStopCount, 0);
      expect(route.remainingStopCount, 0);
      expect(route.currentStopNumber, 0);
      expect(route.isCompleted, isFalse);
      expect(route.nextStop, isNull);
    });
  });
}
