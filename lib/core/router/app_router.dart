import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/shift.dart';
import '../../presentation/pages/dashboard_page.dart';
import '../../presentation/pages/forgot_password_page.dart';
import '../../presentation/pages/login_page.dart';
import '../../presentation/pages/map_page.dart';
import '../../presentation/pages/register_page.dart';
import '../../presentation/pages/route_detail_page.dart';
import '../../presentation/pages/shift_summary_page.dart';
import '../../presentation/pages/splash_page.dart';
import '../../presentation/pages/start_shift_page.dart';
import '../../presentation/widgets/active_shift_guard.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) {
        return const SplashPage();
      },
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) {
        return const RegisterPage();
      },
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) {
        return const ForgotPasswordPage();
      },
    ),
    GoRoute(
      path: AppRoutes.startShift,
      builder: (context, state) {
        return const StartShiftPage();
      },
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) {
        return const ActiveShiftGuard(child: DashboardPage());
      },
    ),
    GoRoute(
      path: AppRoutes.map,
      builder: (context, state) {
        return const ActiveShiftGuard(child: MapPage());
      },
    ),
    GoRoute(
      path: AppRoutes.routeDetail,
      builder: (context, state) {
        return const ActiveShiftGuard(child: RouteDetailPage());
      },
    ),
    GoRoute(
      path: AppRoutes.shiftSummary,
      builder: (context, state) {
        final shift = state.extra;

        if (shift is! Shift) {
          return const _MissingShiftSummaryDataPage();
        }

        return ShiftSummaryPage(shift: shift);
      },
    ),
  ],
);

final class _MissingShiftSummaryDataPage extends StatelessWidget {
  const _MissingShiftSummaryDataPage();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Vardiya Özeti')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 56,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Vardiya özeti bilgisi bulunamadı.',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  context.go(AppRoutes.startShift);
                },
                child: const Text('Ana Ekrana Dön'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
