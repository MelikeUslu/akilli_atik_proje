import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final class AppGoogleMap extends StatelessWidget {
  const AppGoogleMap({
    required this.currentLocation,
    this.markers = const <Marker>{},
    this.polylines = const <Polyline>{},
    this.onMapCreated,
    super.key,
  });

  static const MarkerId _currentLocationMarkerId = MarkerId('current_location');

  final LatLng currentLocation;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final ValueChanged<GoogleMapController>? onMapCreated;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: currentLocation, zoom: 16),
      markers: _buildMarkers(),
      polylines: polylines,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      compassEnabled: true,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      onMapCreated: onMapCreated,
    );
  }

  Set<Marker> _buildMarkers() {
    return <Marker>{
      ...markers.where((marker) => marker.markerId != _currentLocationMarkerId),
      Marker(
        markerId: _currentLocationMarkerId,
        position: currentLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(
          title: 'Mevcut Konum',
          snippet: 'Şu anda buradasınız',
        ),
        zIndexInt: 1000,
      ),
    };
  }
}
