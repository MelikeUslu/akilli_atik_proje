import 'package:flutter/material.dart';

import '../../core/theme/container_fill_colors.dart';
import '../../domain/entities/fill_level.dart';
import '../../domain/entities/waste_container.dart';
import 'fill_level_indicator.dart';

final class ContainerDetailBottomSheet extends StatelessWidget {
  const ContainerDetailBottomSheet({
    required this.container,
    required this.distanceMeters,
    required this.onNavigatePressed,
    this.onCompletePressed,
    this.onSkipPressed,
    this.isActionLoading = false,
    super.key,
  });

  final WasteContainer container;
  final double? distanceMeters;
  final VoidCallback? onNavigatePressed;
  final VoidCallback? onCompletePressed;
  final VoidCallback? onSkipPressed;
  final bool isActionLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fillColor = ContainerFillColors.fromFillLevel(container.fillLevel);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ContainerIndicator(color: fillColor),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        container.code,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _distanceText,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                FillLevelIndicator(fillLevel: container.fillLevel),
              ],
            ),
            const SizedBox(height: 24),
            _FillPercentageSection(
              percentage: container.fillPercentage,
              fillLevel: container.fillLevel,
            ),
            if (onCompletePressed != null || onSkipPressed != null) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  if (onSkipPressed != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isActionLoading ? null : onSkipPressed,
                        icon: const Icon(Icons.skip_next_rounded),
                        label: const Text('Atla'),
                      ),
                    ),
                  if (onSkipPressed != null && onCompletePressed != null)
                    const SizedBox(width: 12),
                  if (onCompletePressed != null)
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: isActionLoading ? null : onCompletePressed,
                        icon: isActionLoading
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.check_rounded),
                        label: const Text('Tamamla'),
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: isActionLoading ? null : onNavigatePressed,
              icon: const Icon(Icons.navigation_rounded),
              label: const Text('Sonraki Durağa Git'),
            ),
          ],
        ),
      ),
    );
  }

  String get _distanceText {
    final distance = distanceMeters;

    if (distance == null) {
      return 'Mesafe bilgisi alınamadı';
    }

    if (distance < 1000) {
      return '${distance.round()} m';
    }

    return '${(distance / 1000).toStringAsFixed(1)} km';
  }
}

final class _ContainerIndicator extends StatelessWidget {
  const _ContainerIndicator({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Icon(Icons.delete_outline_rounded, color: color, size: 28),
    );
  }
}

final class _FillPercentageSection extends StatelessWidget {
  const _FillPercentageSection({
    required this.percentage,
    required this.fillLevel,
  });

  final double percentage;
  final FillLevel fillLevel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = ContainerFillColors.fromFillLevel(fillLevel);

    final normalizedPercentage = (percentage / 100).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'Doluluk',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '%${percentage.round()}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: normalizedPercentage,
            minHeight: 10,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
