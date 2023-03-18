import 'package:clock_app/app.dart';

class Routes {
  static const String rootRoute = '/';
  static const String alarmNotificationRoute = '/alarm-notification-screen';
  static const String timerNotificationRoute = '/timer-notification-screen';

  static String _currentRoute = rootRoute;
  static String _previousRoute = '';

  static String get currentRoute => _currentRoute;
  static String get previousRoute => _previousRoute;

  static void push(String route) {
    _previousRoute = _currentRoute;
    _currentRoute = route;
  }

  static void pop() {
    App.navigatorKey.currentState?.pop();
    _currentRoute = _previousRoute;
  }

  static void popIf(String? route) {
    if (Routes.currentRoute == route) {
      Routes.pop();
    }
  }
}
