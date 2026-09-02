import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../domain/entities/shift.dart';

final class ShiftSummaryPage extends StatelessWidget {
  const ShiftSummaryPage({required this.shift, super.key});

  final Shift shift;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final duration = _calculateDuration();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Vardiya Özeti'),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Icon(
                Icons.check_circle_rounded,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Vardiya Tamamlandı',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Vardiya başarıyla sonlandırıldı.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              _SummaryCard(
                children: [
                  _SummaryRow(
                    icon: Icons.badge_outlined,
                    label: 'Vardiya',
                    value: shift.id,
                  ),
                  const Divider(height: 32),
                  _SummaryRow(
                    icon: Icons.play_circle_outline_rounded,
                    label: 'Başlangıç',
                    value: _formatDateTime(shift.startedAt),
                  ),
                  if (shift.endedAt != null) ...[
                    const Divider(height: 32),
                    _SummaryRow(
                      icon: Icons.stop_circle_outlined,
                      label: 'Bitiş',
                      value: _formatDateTime(shift.endedAt!),
                    ),
                  ],
                  if (duration != null) ...[
                    const Divider(height: 32),
                    _SummaryRow(
                      icon: Icons.schedule_rounded,
                      label: 'Toplam Süre',
                      value: _formatDuration(duration),
                    ),
                  ],
                  const Divider(height: 32),
                  _SummaryRow(
                    icon: Icons.info_outline_rounded,
                    label: 'Durum',
                    value: _statusText(shift.status),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () {
                  context.go(AppRoutes.startShift);
                },
                icon: const Icon(Icons.home_rounded),
                label: const Text('Ana Ekrana Dön'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Duration? _calculateDuration() {
    final endedAt = shift.endedAt;

    if (endedAt == null) {
      return null;
    }

    return endedAt.difference(shift.startedAt);
  }

  String _formatDateTime(DateTime value) {
    final local = value.toLocal();

    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');

    return '$day.$month.$year $hour:$minute';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours == 0) {
      return '$minutes dk';
    }

    return '$hours sa $minutes dk';
  }

  String _statusText(ShiftStatus status) {
    switch (status) {
      case ShiftStatus.active:
        return 'Aktif';
      case ShiftStatus.onBreak:
        return 'Molada';
      case ShiftStatus.completed:
        return 'Tamamlandı';
    }
  }
}

final class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.children});

  final List<Widget> children;

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
      child: Column(children: children),
    );
  }
}

final class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
