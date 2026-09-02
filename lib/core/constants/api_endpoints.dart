abstract final class ApiEndpoints {
  static const String login = '/api/auth/login';

  static const String refreshToken = '/api/auth/refresh';

  static const String startShift = '/api/drivers/{id}/shift/start';

  static const String activeRoute = '/api/drivers/{id}/active-route';

  static const String endShift = '/api/drivers/{id}/shift/end';

  static const String containersByZone = '/api/containers?zoneId={zoneId}';

  static const String completeRouteStop =
      '/api/routes/{id}/stops/{stopId}/complete';

  static const String skipRouteStop = '/api/routes/{id}/stops/{stopId}/skip';

  static const String unreadNotifications = '/api/notifications?unread=true';
}
