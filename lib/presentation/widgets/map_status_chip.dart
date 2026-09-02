import 'package:flutter/material.dart';

final class MapStatusChip extends StatelessWidget {
  const MapStatusChip({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.isActive,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isActive;

  static const Color _activeColor = Color(0xFF1B5E20);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = isActive ? _activeColor : colorScheme.error;
    final backgroundColor = isActive
        ? const Color(0x99C3FCC8)
        : colorScheme.errorContainer;

    return Semantics(
      label: '$label $value',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: statusColor),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
