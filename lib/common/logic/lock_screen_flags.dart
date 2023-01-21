import 'package:flutter_windowmanager/flutter_windowmanager.dart';

Future<void> setLockScreenFlags() async {
  await FlutterWindowManager.addFlags(
      FlutterWindowManager.FLAG_DISMISS_KEYGUARD);
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_KEEP_SCREEN_ON);
  await FlutterWindowManager.addFlags(
      FlutterWindowManager.FLAG_SHOW_WHEN_LOCKED);
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_TURN_SCREEN_ON);
}

Future<void> clearLockScreenFlags() async {
  await FlutterWindowManager.clearFlags(
      FlutterWindowManager.FLAG_DISMISS_KEYGUARD);
  await FlutterWindowManager.clearFlags(
      FlutterWindowManager.FLAG_KEEP_SCREEN_ON);
  await FlutterWindowManager.clearFlags(
      FlutterWindowManager.FLAG_SHOW_WHEN_LOCKED);
  await FlutterWindowManager.clearFlags(
      FlutterWindowManager.FLAG_TURN_SCREEN_ON);
}
