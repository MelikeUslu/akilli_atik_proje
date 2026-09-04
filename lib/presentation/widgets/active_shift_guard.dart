import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/demo_config.dart';
import '../../core/router/app_routes.dart';
import '../providers/start_shift_providers.dart';

final class ActiveShiftGuard extends ConsumerWidget {
  const ActiveShiftGuard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (DemoConfig.enabled) {
      return child;
    }

    final startShiftState = ref.watch(startShiftProvider);

    if (startShiftState.hasActiveShift) {
      return child;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) {
        return;
      }

      context.go(AppRoutes.startShift);
    });

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
