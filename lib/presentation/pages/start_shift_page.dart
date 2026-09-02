import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../providers/login_providers.dart';
import '../providers/start_shift_providers.dart';
import '../widgets/connection_status_card.dart';
import '../widgets/driver_welcome_section.dart';
import '../widgets/start_shift_bottom_wave.dart';
import '../widgets/start_shift_button.dart';

final class StartShiftPage extends ConsumerWidget {
  const StartShiftPage({super.key});

  static const double _maximumContentWidth = 430;
  static const double _horizontalPadding = 24;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    final startShiftState = ref.watch(startShiftProvider);

    final user = loginState.authenticatedUser;

    final driverName = user?.fullName.trim().isNotEmpty == true
        ? user!.fullName.trim()
        : 'Şoför';

    ref.listen(startShiftProvider, (previous, next) {
      final wasSuccessful = previous?.isSuccessful ?? false;

      if (!wasSuccessful && next.isSuccessful) {
        context.go(AppRoutes.dashboard);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maximumContentWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
              ),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  DriverWelcomeSection(fullName: driverName),
                  const SizedBox(height: 48),
                  StartShiftButton(
                    isLoading: startShiftState.isLoading,
                    isEnabled: startShiftState.canStartShift,
                    onPressed: () async {
                      final driverId = user?.id.trim();

                      if (driverId == null || driverId.isEmpty) {
                        _showMessage(context, 'Şoför bilgisi bulunamadı.');
                        return;
                      }

                      await ref
                          .read(startShiftProvider.notifier)
                          .startShift(driverId: driverId);
                    },
                  ),
                  const SizedBox(height: 28),
                  ConnectionStatusCard(isOnline: startShiftState.isOnline),
                  if (startShiftState.errorMessage != null) ...[
                    const SizedBox(height: 20),
                    _ErrorMessage(message: startShiftState.errorMessage!),
                  ],
                  const Spacer(flex: 3),
                  const StartShiftBottomWave(),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

final class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(16),
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
    );
  }
}
