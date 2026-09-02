abstract final class AppThresholds {
  static const double routeStopCompletionDistanceMeters = 50;

  static const double lowFillMaximumPercentage = 40;

  static const double mediumFillMaximumPercentage = 70;

  static const double highFillMaximumPercentage = 89;

  static const double criticalFillMinimumPercentage = 90;

  static const Duration driverLocationUpdateInterval = Duration(seconds: 10);

  static const int maximumFailedLoginAttempts = 3;

  static const Duration loginLockDuration = Duration(minutes: 5);
}
