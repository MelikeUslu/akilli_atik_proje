import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/waste_container.dart';
import 'container_marker.dart';

final class ContainerMarkerFactory {
  const ContainerMarkerFactory._();

  static Future<Set<Marker>> createAll({
    required List<WasteContainer> containers,
    required void Function(WasteContainer container) onContainerTap,
  }) async {
    final markers = await Future.wait(
      containers.map(
        (container) => ContainerMarker.create(
          container: container,
          onTap: () => onContainerTap(container),
        ),
      ),
    );

    return Set<Marker>.unmodifiable(markers);
  }
}
