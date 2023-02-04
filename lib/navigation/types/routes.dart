import 'package:clock_app/navigation/types/app_visibility.dart';
import 'package:flutter/cupertino.dart';

class Routes {
  static const String rootRoute = '/';
  static const String alarmNotificationRoute = '/alarm-notification-screen';

  static String _currentRoute = rootRoute;

  static String get currentRoute => _currentRoute;

  static void setCurrentRoute(String route) {
    _currentRoute = route;
  }
}
