import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../core/constants/demo_config.dart';
import '../../core/utils/location_distance_calculator.dart';
import '../../domain/entities/location.dart';
import '../models/route_model.dart';
import '../models/route_stop_model.dart';
import '../models/waste_container_model.dart';

@lazySingleton
final class DemoWasteDataService {
  static const String _assetPath = 'assets/demo/demo_waste_data.json';

  List<_DemoContainerSeed>? _seeds;
  String? _zoneId;

  final Set<String> _completedContainerIds = <String>{};

  final Map<String, _LockedDemoRoute> _lockedRoutes =
      <String, _LockedDemoRoute>{};

  Future<List<WasteContainerModel>> getContainers({
    required String zoneId,
  }) async {
    await _ensureLoaded();

    final normalizedZoneId = zoneId.trim();

    if (normalizedZoneId.isEmpty) {
      throw const FormatException('Bölge bilgisi boş olamaz.');
    }

    if (normalizedZoneId != _zoneId) {
      return const <WasteContainerModel>[];
    }

    final phase = _currentPhase;

    return List<WasteContainerModel>.unmodifiable(
      _seeds!.map((seed) {
        return seed.toModel(phase: phase);
      }),
    );
  }

  Future<void> startShift({required String driverId}) async {
    final normalizedDriverId = driverId.trim();

    if (normalizedDriverId.isEmpty) {
      throw const FormatException('Şoför bilgisi boş olamaz.');
    }

    _completedContainerIds.clear();

    final route = await _createRouteSnapshot(driverId: normalizedDriverId);

    _lockedRoutes[normalizedDriverId] = route;
  }

  Future<void> endShift({required String driverId}) async {
    final normalizedDriverId = driverId.trim();

    if (normalizedDriverId.isEmpty) {
      throw const FormatException('Şoför bilgisi boş olamaz.');
    }

    _lockedRoutes.remove(normalizedDriverId);
    _completedContainerIds.clear();
  }

  Future<RouteModel> getActiveRoute({required String driverId}) async {
    final normalizedDriverId = driverId.trim();

    if (normalizedDriverId.isEmpty) {
      throw const FormatException('Şoför bilgisi boş olamaz.');
    }

    var lockedRoute = _lockedRoutes[normalizedDriverId];

    if (lockedRoute == null) {
      lockedRoute = await _createRouteSnapshot(driverId: normalizedDriverId);

      _lockedRoutes[normalizedDriverId] = lockedRoute;
    }

    return _toRouteModel(
      driverId: normalizedDriverId,
      lockedRoute: lockedRoute,
    );
  }

  Future<void> completeStop({required String stopId}) async {
    final containerId = _containerIdFromStopId(stopId);

    _completedContainerIds.add(containerId);
  }

  Future<void> skipStop({
    required String stopId,
    required String reason,
  }) async {
    final normalizedReason = reason.trim();

    if (normalizedReason.isEmpty) {
      throw const FormatException('Durak atlama nedeni boş olamaz.');
    }

    final containerId = _containerIdFromStopId(stopId);

    _completedContainerIds.add(containerId);
  }

  Future<_LockedDemoRoute> _createRouteSnapshot({
    required String driverId,
  }) async {
    final containers = await getContainers(zoneId: DemoConfig.zoneId);

    final collectableContainers =
        containers
            .where((container) {
              return container.status == 'active' &&
                  container.fillPercentage >=
                      DemoConfig.collectableMinimumFillPercentage;
            })
            .toList(growable: false)
          ..sort((first, second) {
            return second.fillPercentage.compareTo(first.fillPercentage);
          });

    final stops = <_LockedDemoStop>[];

    for (var index = 0; index < collectableContainers.length; index++) {
      final container = collectableContainers[index];

      stops.add(
        _LockedDemoStop(
          id: 'demo-stop-${container.id}',
          containerId: container.id,
          order: index + 1,
          latitude: container.latitude,
          longitude: container.longitude,
        ),
      );
    }

    return _LockedDemoRoute(
      stops: List<_LockedDemoStop>.unmodifiable(stops),
      totalDistanceKm: _calculateDistanceKm(stops),
    );
  }

  RouteModel _toRouteModel({
    required String driverId,
    required _LockedDemoRoute lockedRoute,
  }) {
    return RouteModel(
      id: 'demo-route-$driverId',
      driverId: driverId,
      stops: lockedRoute.stops
          .map((stop) {
            return RouteStopModel(
              id: stop.id,
              containerId: stop.containerId,
              order: stop.order,
              latitude: stop.latitude,
              longitude: stop.longitude,
              isCompleted: _completedContainerIds.contains(stop.containerId),
            );
          })
          .toList(growable: false),
      totalDistanceKm: lockedRoute.totalDistanceKm,
    );
  }

  int get _currentPhase {
    final milliseconds = DemoConfig.updateInterval.inMilliseconds;

    if (milliseconds <= 0) {
      return 0;
    }

    return DateTime.now().millisecondsSinceEpoch ~/ milliseconds;
  }

  Future<void> _ensureLoaded() async {
    if (_seeds != null) {
      return;
    }

    final source = await rootBundle.loadString(_assetPath);

    final decoded = jsonDecode(source);

    if (decoded is! Map) {
      throw const FormatException('Demo JSON verisi geçersiz.');
    }

    final json = Map<String, dynamic>.from(decoded);

    final zoneId = json['zoneId'];
    final rawContainers = json['containers'];

    if (zoneId is! String || rawContainers is! List) {
      throw const FormatException('Demo JSON yapısı geçersiz.');
    }

    final seeds = rawContainers
        .map<_DemoContainerSeed>((value) {
          if (value is! Map) {
            throw const FormatException('Demo konteyner verisi geçersiz.');
          }

          return _DemoContainerSeed.fromJson(Map<String, dynamic>.from(value));
        })
        .toList(growable: false);

    _zoneId = zoneId;
    _seeds = seeds;
  }

  double _calculateDistanceKm(List<_LockedDemoStop> stops) {
    if (stops.length < 2) {
      return 0;
    }

    var totalMeters = 0.0;

    for (var index = 1; index < stops.length; index++) {
      final previous = stops[index - 1];
      final current = stops[index];

      totalMeters += LocationDistanceCalculator.calculateMeters(
        from: Location(
          latitude: previous.latitude,
          longitude: previous.longitude,
        ),
        to: Location(latitude: current.latitude, longitude: current.longitude),
      );
    }

    return totalMeters / 1000;
  }

  String _containerIdFromStopId(String stopId) {
    final normalizedStopId = stopId.trim();

    const prefix = 'demo-stop-';

    if (!normalizedStopId.startsWith(prefix)) {
      throw const FormatException('Demo durak bilgisi geçersiz.');
    }

    final containerId = normalizedStopId.substring(prefix.length);

    if (containerId.isEmpty) {
      throw const FormatException('Demo konteyner bilgisi bulunamadı.');
    }

    return containerId;
  }
}

final class _LockedDemoRoute {
  const _LockedDemoRoute({required this.stops, required this.totalDistanceKm});

  final List<_LockedDemoStop> stops;
  final double totalDistanceKm;
}

final class _LockedDemoStop {
  const _LockedDemoStop({
    required this.id,
    required this.containerId,
    required this.order,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String containerId;
  final int order;
  final double latitude;
  final double longitude;
}

final class _DemoContainerSeed {
  const _DemoContainerSeed({
    required this.id,
    required this.code,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.fillSequence,
  });

  final String id;
  final String code;
  final double latitude;
  final double longitude;
  final String status;
  final List<double> fillSequence;

  factory _DemoContainerSeed.fromJson(Map<String, dynamic> json) {
    final rawSequence = json['fillSequence'];

    if (rawSequence is! List || rawSequence.isEmpty) {
      throw const FormatException('Demo doluluk sırası bulunamadı.');
    }

    return _DemoContainerSeed(
      id: json['id'] as String,
      code: json['code'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      status: json['status'] as String,
      fillSequence: rawSequence
          .map<double>((value) {
            return (value as num).toDouble();
          })
          .toList(growable: false),
    );
  }

  WasteContainerModel toModel({required int phase}) {
    final index = phase % fillSequence.length;

    return WasteContainerModel(
      id: id,
      code: code,
      latitude: latitude,
      longitude: longitude,
      fillPercentage: fillSequence[index],
      status: status,
    );
  }
}
