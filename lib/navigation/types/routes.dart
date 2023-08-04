import 'package:clock_app/app.dart';

class Routes {
  static const String rootRoute = '/';
  static const String alarmNotificationRoute = '/alarm-notification-screen';
  static const String timerNotificationRoute = '/timer-notification-screen';

  static String _currentRoute = rootRoute;
  static final List<String> _previousRoutes = [];

  static String get currentRoute => _currentRoute;
  static List<String> get previousRoutes => _previousRoutes;

  static void push(String route) {
    _previousRoutes.add(_currentRoute);
    _currentRoute = route;
  }

  static void pop({bool onlyUpdateRoute = false}) {
    if (!onlyUpdateRoute) {
      App.navigatorKey.currentState?.pop();
    }

    _currentRoute = _previousRoutes.removeLast();
  }

  static void popIf(String? route) {
    if (Routes.currentRoute == route) {
      Routes.pop();
    }
  }
}
