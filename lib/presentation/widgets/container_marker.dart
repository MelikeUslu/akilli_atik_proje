import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/theme/container_fill_colors.dart';
import '../../domain/entities/waste_container.dart';

final class ContainerMarker {
  const ContainerMarker._();

  static const double _markerWidth = 56;
  static const double _markerHeight = 72;
  static const double _circleRadius = 22;

  static Future<Marker> create({
    required WasteContainer container,
    required VoidCallback onTap,
  }) async {
    final icon = await _createMarkerIcon(
      color: ContainerFillColors.fromFillLevel(container.fillLevel),
    );

    return Marker(
      markerId: MarkerId('container_${container.id}'),
      position: LatLng(
        container.location.latitude,
        container.location.longitude,
      ),
      icon: icon,
      anchor: const Offset(0.5, 1),
      infoWindow: InfoWindow.noText,
      onTap: onTap,
      zIndexInt: container.isCritical ? 100 : 10,
    );
  }

  static Future<BitmapDescriptor> _createMarkerIcon({
    required Color color,
  }) async {
    final recorder = ui.PictureRecorder();

    final canvas = Canvas(
      recorder,
      const Rect.fromLTWH(0, 0, _markerWidth, _markerHeight),
    );

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final center = Offset(_markerWidth / 2, _circleRadius + 4);

    final path = Path()
      ..moveTo(center.dx, _markerHeight)
      ..lineTo(center.dx - 12, center.dy + 12)
      ..lineTo(center.dx + 12, center.dy + 12)
      ..close();

    canvas.drawPath(path, fillPaint);

    canvas.drawCircle(center, _circleRadius, fillPaint);

    canvas.drawCircle(center, _circleRadius, borderPaint);

    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 7, innerPaint);

    final picture = recorder.endRecording();

    final image = await picture.toImage(
      _markerWidth.toInt(),
      _markerHeight.toInt(),
    );

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw StateError('Konteyner marker görseli oluşturulamadı.');
    }

    return BitmapDescriptor.bytes(byteData.buffer.asUint8List());
  }
}
