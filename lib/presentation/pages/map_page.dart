import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/demo_config.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/location_distance_calculator.dart';
import '../../domain/entities/route_stop.dart';
import '../../domain/entities/waste_container.dart';
import '../providers/complete_route_stop_providers.dart';
import '../providers/container_provider.dart';
import '../providers/end_shift_providers.dart';
import '../providers/login_providers.dart';
import '../providers/map_providers.dart';
import '../providers/map_state.dart';
import '../providers/skip_route_stop_providers.dart';
import '../providers/start_shift_providers.dart';
import '../widgets/container_detail_bottom_sheet.dart';
import '../widgets/container_map_view.dart';
import '../widgets/map_status_chip.dart';
import '../widgets/route_summary_card.dart';

final class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

final class _MapPageState extends ConsumerState<MapPage> {
  static const double _horizontalPadding = 20;
  static const double _topPadding = 20;
  static const double _sectionSpacing = 18;
  static const double _mapHeight = 420;
  static const double _mapBorderRadius = 28;

  bool _routeRequested = false;
  Timer? _demoRefreshTimer;

  @override
  void initState() {
    super.initState();

    if (DemoConfig.enabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_loadInitialDemoData());
      });

      _demoRefreshTimer = Timer.periodic(DemoConfig.updateInterval, (_) {
        unawaited(_refreshDemoContainers());
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _requestInitialRouteIfPossible();
  }

  @override
  void dispose() {
    _demoRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);
    final containerState = ref.watch(containerProvider);
    final endShiftState = ref.watch(endShiftProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshPage,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  _horizontalPadding,
                  _topPadding,
                  _horizontalPadding,
                  12,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Harita',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: _sectionSpacing),
                      _buildStatusSection(mapState),
                      const SizedBox(height: _sectionSpacing),
                      RouteSummaryCard(
                        currentStopNumber: mapState.currentStopNumber,
                        totalStopCount: mapState.totalStopCount,
                        remainingStopCount: mapState.remainingStopCount,
                        distanceKm: mapState.totalDistanceKm,
                        onTap: mapState.route == null
                            ? null
                            : () {
                                context.push(AppRoutes.routeDetail);
                              },
                      ),
                      if (mapState.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        _MapErrorCard(message: mapState.errorMessage!),
                      ],
                      if (containerState.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        _MapErrorCard(message: containerState.errorMessage!),
                      ],
                      if (endShiftState.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        _MapErrorCard(message: endShiftState.errorMessage!),
                      ],
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    _horizontalPadding,
                    8,
                    _horizontalPadding,
                    24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildMapContent(
                        mapState: mapState,
                        containers: containerState.containers,
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: endShiftState.isLoading ? null : _endShift,
                        icon: endShiftState.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.stop_circle_outlined),
                        label: Text(
                          endShiftState.isLoading
                              ? 'Vardiya Sonlandırılıyor...'
                              : 'Vardiyayı Bitir',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSection(MapState mapState) {
    return Row(
      children: [
        Expanded(
          child: MapStatusChip(
            label: 'Bağlantı',
            value: mapState.isOnline ? 'Çevrimiçi' : 'Çevrimdışı',
            icon: mapState.isOnline
                ? Icons.wifi_rounded
                : Icons.wifi_off_rounded,
            isActive: mapState.isOnline,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: MapStatusChip(
            label: 'GPS',
            value: mapState.gpsStatusText,
            icon: mapState.isGpsReady
                ? Icons.gps_fixed_rounded
                : Icons.gps_off_rounded,
            isActive: mapState.isGpsReady,
          ),
        ),
      ],
    );
  }

  Widget _buildMapContent({
    required MapState mapState,
    required List<WasteContainer> containers,
  }) {
    if (mapState.isLocationLoading) {
      return const _LocationLoadingCard(height: _mapHeight);
    }

    final currentLocation = mapState.currentLocation;

    if (currentLocation == null) {
      return _LocationUnavailableCard(
        height: _mapHeight,
        status: mapState.locationAccessStatus,
        isGpsEnabled: mapState.isGpsEnabled,
        onRetry: _retryLocation,
      );
    }

    return SizedBox(
      height: _mapHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_mapBorderRadius),
        child: ContainerMapView(
          currentLocation: currentLocation,
          containers: containers,
          route: mapState.route,
          onContainerTap: _showContainerDetails,
          onRouteStopTap: _handleRouteStopTap,
        ),
      ),
    );
  }

  Future<void> _showContainerDetails(WasteContainer container) async {
    final currentLocation = ref.read(mapProvider).currentLocation;

    final distanceMeters = currentLocation == null
        ? null
        : LocationDistanceCalculator.calculateMeters(
            from: currentLocation,
            to: container.location,
          );

    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: false,
      builder: (bottomSheetContext) {
        return ContainerDetailBottomSheet(
          container: container,
          distanceMeters: distanceMeters,
          onNavigatePressed: null,
        );
      },
    );
  }

  Future<void> _handleRouteStopTap(RouteStop stop) async {
    final mapState = ref.read(mapProvider);
    final route = mapState.route;

    if (route == null) {
      return;
    }

    final container = ref.read(containerProvider).findById(stop.containerId);

    if (container == null) {
      return;
    }

    final currentLocation = mapState.currentLocation;

    final distanceMeters = currentLocation == null
        ? null
        : LocationDistanceCalculator.calculateMeters(
            from: currentLocation,
            to: container.location,
          );

    final isNextStop = route.nextStop?.id == stop.id;

    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: false,
      builder: (bottomSheetContext) {
        return Consumer(
          builder: (context, ref, child) {
            final completeState = ref.watch(completeRouteStopProvider);

            final skipState = ref.watch(skipRouteStopProvider);

            final isActionLoading =
                completeState.isLoading || skipState.isLoading;

            return ContainerDetailBottomSheet(
              container: container,
              distanceMeters: distanceMeters,
              isActionLoading: isActionLoading,
              onNavigatePressed: isNextStop
                  ? () {
                      Navigator.of(bottomSheetContext).pop();
                    }
                  : null,
              onCompletePressed: isNextStop && currentLocation != null
                  ? () async {
                      final success = await ref
                          .read(completeRouteStopProvider.notifier)
                          .completeStop(
                            route: route,
                            stopId: stop.id,
                            currentLocation: currentLocation,
                          );

                      if (!success) {
                        if (!bottomSheetContext.mounted) {
                          return;
                        }

                        final message = ref
                            .read(completeRouteStopProvider)
                            .errorMessage;

                        if (message != null) {
                          ScaffoldMessenger.of(
                            bottomSheetContext,
                          ).showSnackBar(SnackBar(content: Text(message)));
                        }

                        return;
                      }

                      if (bottomSheetContext.mounted) {
                        Navigator.of(bottomSheetContext).pop();
                      }

                      if (!mounted) {
                        return;
                      }

                      await _refreshRouteAfterStopAction();
                    }
                  : null,
              onSkipPressed: isNextStop
                  ? () async {
                      final reason = await _requestSkipReason();

                      if (reason == null || !mounted) {
                        return;
                      }

                      final success = await ref
                          .read(skipRouteStopProvider.notifier)
                          .skipStop(
                            routeId: route.id,
                            stopId: stop.id,
                            reason: reason,
                          );

                      if (!success) {
                        if (!bottomSheetContext.mounted) {
                          return;
                        }

                        final message = ref
                            .read(skipRouteStopProvider)
                            .errorMessage;

                        if (message != null) {
                          ScaffoldMessenger.of(
                            bottomSheetContext,
                          ).showSnackBar(SnackBar(content: Text(message)));
                        }

                        return;
                      }

                      if (bottomSheetContext.mounted) {
                        Navigator.of(bottomSheetContext).pop();
                      }

                      if (!mounted) {
                        return;
                      }

                      await _refreshRouteAfterStopAction();
                    }
                  : null,
            );
          },
        );
      },
    );
  }

  Future<String?> _requestSkipReason() async {
    final controller = TextEditingController();

    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Durağı Atla'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Atlama nedeni',
              hintText: 'Durağın neden atlandığını yazın',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () {
                final normalizedReason = controller.text.trim();

                if (normalizedReason.isEmpty) {
                  return;
                }

                Navigator.of(dialogContext).pop(normalizedReason);
              },
              child: const Text('Atla'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    return reason;
  }

  Future<void> _loadInitialDemoData() async {
    if (!DemoConfig.enabled || !mounted) {
      return;
    }

    final driverId = _resolveDriverId();

    await Future.wait([
      ref
          .read(containerProvider.notifier)
          .loadContainers(zoneId: DemoConfig.zoneId),
      ref.read(mapProvider.notifier).loadActiveRoute(driverId: driverId),
    ]);
  }

  Future<void> _refreshDemoContainers() async {
    if (!DemoConfig.enabled || !mounted) {
      return;
    }

    await ref
        .read(containerProvider.notifier)
        .loadContainers(zoneId: DemoConfig.zoneId);
  }

  String _resolveDriverId() {
    final authenticatedUser = ref.read(loginProvider).authenticatedUser;

    final userId = authenticatedUser?.id.trim();

    if (userId != null && userId.isNotEmpty) {
      return userId;
    }

    if (DemoConfig.enabled) {
      return DemoConfig.driverId;
    }

    return '';
  }

  Future<void> _refreshRouteAfterStopAction() async {
    final driverId = _resolveDriverId();

    if (driverId.isEmpty) {
      return;
    }

    await ref.read(mapProvider.notifier).refreshActiveRoute(driverId: driverId);

    if (DemoConfig.enabled) {
      await _refreshDemoContainers();
    }
  }

  void _requestInitialRouteIfPossible() {
    if (_routeRequested) {
      return;
    }

    final driverId = _resolveDriverId();

    if (driverId.isEmpty) {
      return;
    }

    _routeRequested = true;

    Future.microtask(
      () => ref.read(mapProvider.notifier).loadActiveRoute(driverId: driverId),
    );
  }

  Future<void> _retryLocation() {
    return ref.read(mapProvider.notifier).loadCurrentLocation();
  }

  Future<void> _refreshPage() async {
    final notifier = ref.read(mapProvider.notifier);

    await Future.wait([
      notifier.loadCurrentLocation(),
      notifier.refreshConnectivityStatus(),
    ]);

    if (DemoConfig.enabled) {
      await _refreshDemoContainers();
      return;
    }

    final driverId = _resolveDriverId();

    if (driverId.isEmpty) {
      return;
    }

    await notifier.refreshActiveRoute(driverId: driverId);
  }

  Future<void> _endShift() async {
    final authenticatedUser = ref.read(loginProvider).authenticatedUser;

    final driverId = authenticatedUser?.id.trim();

    if (driverId == null || driverId.isEmpty) {
      if (DemoConfig.enabled) {
        _showDemoShiftMessage();
        return;
      }

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şoför bilgisi bulunamadı.')),
      );

      return;
    }

    final shouldEndShift = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Vardiyayı Bitir'),
          content: const Text(
            'Vardiyayı sonlandırmak istediğinizden emin misiniz?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Vardiyayı Bitir'),
            ),
          ],
        );
      },
    );

    if (shouldEndShift != true || !mounted) {
      return;
    }

    final shift = await ref
        .read(endShiftProvider.notifier)
        .endShift(driverId: driverId);

    if (!mounted) {
      return;
    }

    if (shift == null) {
      final errorMessage = ref.read(endShiftProvider).errorMessage;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage ?? 'Vardiya sonlandırılamadı.')),
      );

      return;
    }

    ref.read(startShiftProvider.notifier).clearActiveShift();

    ref.read(mapProvider.notifier).clear();

    context.go(AppRoutes.shiftSummary, extra: shift);
  }

  void _showDemoShiftMessage() {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text(
            'Demo harita aktif. Vardiya bitirme işlemi giriş yapılmış kullanıcı üzerinden çalışır.',
          ),
        ),
      );
  }
}

final class _LocationLoadingCard extends StatelessWidget {
  const _LocationLoadingCard({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 18),
            Text(
              'Konum bilgisi alınıyor...',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _LocationUnavailableCard extends StatelessWidget {
  const _LocationUnavailableCard({
    required this.height,
    required this.status,
    required this.isGpsEnabled,
    required this.onRetry,
  });

  final double height;
  final LocationAccessStatus status;
  final bool isGpsEnabled;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _resolveIcon(),
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            _resolveMessage(),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _resolveDescription(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              onRetry();
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Tekrar Dene'),
          ),
        ],
      ),
    );
  }

  IconData _resolveIcon() {
    switch (status) {
      case LocationAccessStatus.serviceDisabled:
        return Icons.gps_off_rounded;

      case LocationAccessStatus.denied:
      case LocationAccessStatus.deniedForever:
        return Icons.location_disabled_rounded;

      case LocationAccessStatus.granted:
      case LocationAccessStatus.unknown:
      case LocationAccessStatus.checking:
        return isGpsEnabled
            ? Icons.location_searching_rounded
            : Icons.gps_off_rounded;
    }
  }

  String _resolveMessage() {
    switch (status) {
      case LocationAccessStatus.serviceDisabled:
        return 'GPS kapalı';

      case LocationAccessStatus.denied:
        return 'Konum izni gerekli';

      case LocationAccessStatus.deniedForever:
        return 'Konum erişimi engellendi';

      case LocationAccessStatus.granted:
        return 'Konum bilgisi alınamadı';

      case LocationAccessStatus.unknown:
      case LocationAccessStatus.checking:
        return 'Konum kontrol ediliyor';
    }
  }

  String _resolveDescription() {
    switch (status) {
      case LocationAccessStatus.serviceDisabled:
        return 'Haritayı kullanabilmek için cihazınızın konum servisini açın.';

      case LocationAccessStatus.denied:
        return 'Haritada mevcut konumunuzu gösterebilmek için konum izni vermeniz gerekiyor.';

      case LocationAccessStatus.deniedForever:
        return 'Konum izni kalıcı olarak engellenmiş. Cihaz veya tarayıcı ayarlarından konum erişimine izin verin.';

      case LocationAccessStatus.granted:
        return 'Konum izni mevcut ancak güncel konum bilgisi alınamadı.';

      case LocationAccessStatus.unknown:
      case LocationAccessStatus.checking:
        return 'Konum servisinin durumu kontrol ediliyor.';
    }
  }
}

final class _MapErrorCard extends StatelessWidget {
  const _MapErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: colorScheme.onErrorContainer,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
