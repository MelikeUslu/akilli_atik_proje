import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/route_stop.dart';

abstract final class RouteStopMarker {
  static const double _size = 52;

  static Future<Marker> create({
    required RouteStop stop,
    required bool isNextStop,
    required VoidCallback onTap,
  }) async {
    final icon = await _createIcon(
      order: stop.order,
      isCompleted: stop.isCompleted,
      isNextStop: isNextStop,
    );

    return Marker(
      markerId: MarkerId('route_stop_${stop.id}'),
      position: LatLng(stop.location.latitude, stop.location.longitude),
      icon: icon,
      anchor: const Offset(0.5, 0.5),
      onTap: onTap,
      zIndexInt: isNextStop ? 200 : 100,
    );
  }

  static Future<BitmapDescriptor> _createIcon({
    required int order,
    required bool isCompleted,
    required bool isNextStop,
  }) async {
    final recorder = ui.PictureRecorder();

    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, _size, _size));

    final backgroundColor = isCompleted ? AppColors.success : AppColors.primary;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = isNextStop ? AppColors.warning : AppColors.textOnPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = isNextStop ? 4 : 2;

    final center = const Offset(_size / 2, _size / 2);

    canvas.drawCircle(center, 22, backgroundPaint);

    canvas.drawCircle(center, 22, borderPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: order.toString(),
        style: const TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );

    final picture = recorder.endRecording();

    final image = await picture.toImage(_size.toInt(), _size.toInt());

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw StateError('Rota durak marker görseli oluşturulamadı.');
    }

    return BitmapDescriptor.bytes(byteData.buffer.asUint8List());
  }
}
