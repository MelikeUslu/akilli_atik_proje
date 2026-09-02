import 'package:flutter/material.dart';

import '../../core/theme/container_fill_colors.dart';
import '../../domain/entities/fill_level.dart';

final class FillLevelIndicator extends StatelessWidget {
  const FillLevelIndicator({required this.fillLevel, super.key});

  final FillLevel fillLevel;

  @override
  Widget build(BuildContext context) {
    final color = ContainerFillColors.fromFillLevel(fillLevel);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String get _label {
    return switch (fillLevel) {
      FillLevel.low => 'Düşük',
      FillLevel.medium => 'Orta',
      FillLevel.high => 'Yüksek',
      FillLevel.critical => 'Kritik',
    };
  }
}
