import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/location.dart';
import '../../domain/entities/route.dart' as domain;
import '../../domain/entities/route_stop.dart';
import '../../domain/entities/waste_container.dart';
import 'app_google_map.dart';
import 'container_marker_factory.dart';
import 'route_polyline.dart';
import 'route_stop_marker_factory.dart';

final class ContainerMapView extends StatefulWidget {
  const ContainerMapView({
    required this.currentLocation,
    required this.containers,
    required this.onContainerTap,
    required this.route,
    required this.onRouteStopTap,
    this.onMapCreated,
    super.key,
  });

  final Location currentLocation;
  final List<WasteContainer> containers;
  final ValueChanged<WasteContainer> onContainerTap;
  final domain.Route? route;
  final ValueChanged<RouteStop> onRouteStopTap;
  final ValueChanged<GoogleMapController>? onMapCreated;

  @override
  State<ContainerMapView> createState() => _ContainerMapViewState();
}

final class _ContainerMapViewState extends State<ContainerMapView> {
  Set<Marker> _containerMarkers = const <Marker>{};
  Set<Marker> _routeStopMarkers = const <Marker>{};

  int _markerGeneration = 0;

  @override
  void initState() {
    super.initState();
    _generateMarkers();
  }

  @override
  void didUpdateWidget(ContainerMapView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.containers != widget.containers ||
        oldWidget.route != widget.route) {
      _generateMarkers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppGoogleMap(
      currentLocation: LatLng(
        widget.currentLocation.latitude,
        widget.currentLocation.longitude,
      ),
      markers: <Marker>{..._containerMarkers, ..._routeStopMarkers},
      polylines: RoutePolyline.create(widget.route),
      onMapCreated: widget.onMapCreated,
    );
  }

  Future<void> _generateMarkers() async {
    final generation = ++_markerGeneration;

    final results = await Future.wait<Set<Marker>>([
      ContainerMarkerFactory.createAll(
        containers: widget.containers,
        onContainerTap: widget.onContainerTap,
      ),
      RouteStopMarkerFactory.createAll(
        route: widget.route,
        onStopTap: widget.onRouteStopTap,
      ),
    ]);

    if (!mounted || generation != _markerGeneration) {
      return;
    }

    setState(() {
      _containerMarkers = results[0];
      _routeStopMarkers = results[1];
    });
  }
}
