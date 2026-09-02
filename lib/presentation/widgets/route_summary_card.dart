import 'package:flutter/material.dart';

final class RouteSummaryCard extends StatelessWidget {
  const RouteSummaryCard({
    super.key,
    required this.currentStopNumber,
    required this.totalStopCount,
    required this.remainingStopCount,
    required this.distanceKm,
    this.onTap,
  });

  final int currentStopNumber;
  final int totalStopCount;
  final int remainingStopCount;
  final double distanceKm;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(26);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 13,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  icon: Icons.map_outlined,
                  label: 'Rota',
                  value: '$currentStopNumber / $totalStopCount',
                ),
              ),
              const _VerticalDivider(),
              Expanded(
                child: _SummaryItem(
                  icon: Icons.route_rounded,
                  label: 'Kalan',
                  value: '$remainingStopCount Durak',
                ),
              ),
              const _VerticalDivider(),
              Expanded(
                child: _SummaryItem(
                  icon: Icons.social_distance_rounded,
                  label: 'Mesafe',
                  value: '${distanceKm.toStringAsFixed(1)} km',
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

final class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 24, color: const Color(0xFF1B5E20)),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

final class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
    );
  }
}
