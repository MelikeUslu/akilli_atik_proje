import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/route_stop.dart';
import '../providers/map_providers.dart';

final class RouteDetailPage extends ConsumerWidget {
  const RouteDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapProvider);
    final route = mapState.route;

    return Scaffold(
      appBar: AppBar(title: const Text('Rota Detayı')),
      body: SafeArea(
        top: false,
        child: Builder(
          builder: (context) {
            if (mapState.isLoading && route == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (route == null) {
              return _EmptyRouteView(
                message: mapState.errorMessage ?? 'Aktif rota bulunamadı.',
              );
            }

            return RefreshIndicator(
              onRefresh: () {
                return ref
                    .read(mapProvider.notifier)
                    .refreshActiveRoute(driverId: route.driverId);
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    sliver: SliverToBoxAdapter(
                      child: _RouteOverviewCard(
                        totalStopCount: route.totalStopCount,
                        completedStopCount: route.completedStopCount,
                        remainingStopCount: route.remainingStopCount,
                        totalDistanceKm: route.totalDistanceKm,
                      ),
                    ),
                  ),
                  if (route.stops.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyRouteView(
                        message: 'Bu rotaya ait durak bulunmuyor.',
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      sliver: SliverList.separated(
                        itemCount: route.stops.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 12);
                        },
                        itemBuilder: (context, index) {
                          final stop = route.stops[index];

                          return _RouteStopCard(
                            stop: stop,
                            isNextStop: route.nextStop?.id == stop.id,
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

final class _RouteOverviewCard extends StatelessWidget {
  const _RouteOverviewCard({
    required this.totalStopCount,
    required this.completedStopCount,
    required this.remainingStopCount,
    required this.totalDistanceKm,
  });

  final int totalStopCount;
  final int completedStopCount;
  final int remainingStopCount;
  final double totalDistanceKm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aktif Rota',
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _SummaryValue(label: 'Toplam', value: '$totalStopCount'),
              ),
              Expanded(
                child: _SummaryValue(
                  label: 'Tamamlanan',
                  value: '$completedStopCount',
                ),
              ),
              Expanded(
                child: _SummaryValue(
                  label: 'Kalan',
                  value: '$remainingStopCount',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.route_rounded, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Text(
                '${totalDistanceKm.toStringAsFixed(1)} km',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _SummaryValue extends StatelessWidget {
  const _SummaryValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

final class _RouteStopCard extends StatelessWidget {
  const _RouteStopCard({required this.stop, required this.isNextStop});

  final RouteStop stop;
  final bool isNextStop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final statusIcon = stop.isCompleted
        ? Icons.check_circle_rounded
        : isNextStop
        ? Icons.navigation_rounded
        : Icons.radio_button_unchecked_rounded;

    final statusText = stop.isCompleted
        ? 'Tamamlandı'
        : isNextStop
        ? 'Sıradaki durak'
        : 'Bekliyor';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNextStop
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isNextStop
              ? theme.colorScheme.primary
              : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${stop.order}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Durak ${stop.order}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Konteyner: ${stop.containerId}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                statusIcon,
                color: stop.isCompleted || isNextStop
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 4),
              Text(
                statusText,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _EmptyRouteView extends StatelessWidget {
  const _EmptyRouteView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.route_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              message,
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
