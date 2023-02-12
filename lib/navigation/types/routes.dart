class Routes {
  static const String rootRoute = '/';
  static const String alarmNotificationRoute = '/alarm-notification-screen';

  static String _currentRoute = rootRoute;

  static String get currentRoute => _currentRoute;

  static void setCurrentRoute(String route) {
    _currentRoute = route;
  }
}
