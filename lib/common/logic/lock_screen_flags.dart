import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class LockScreenFlagManager {
  static bool _isLockScreenFlagsSet = false;

  static Future<void> initialize() async {
    // print("Clear Flags");

    await FlutterWindowManager.clearFlags(
        FlutterWindowManager.FLAG_DISMISS_KEYGUARD);
    await FlutterWindowManager.clearFlags(
        FlutterWindowManager.FLAG_KEEP_SCREEN_ON);
    await FlutterWindowManager.clearFlags(
        FlutterWindowManager.FLAG_SHOW_WHEN_LOCKED);
    await FlutterWindowManager.clearFlags(
        FlutterWindowManager.FLAG_TURN_SCREEN_ON);
  }

  static Future<void> setLockScreenFlags() async {
    // print("Set Flags");
    if (_isLockScreenFlagsSet) {
      // print("Set Flags (Already Set)");
      return;
    }
    await FlutterWindowManager.addFlags(
        FlutterWindowManager.FLAG_DISMISS_KEYGUARD);
    await FlutterWindowManager.addFlags(
        FlutterWindowManager.FLAG_KEEP_SCREEN_ON);
    await FlutterWindowManager.addFlags(
        FlutterWindowManager.FLAG_SHOW_WHEN_LOCKED);
    await FlutterWindowManager.addFlags(
        FlutterWindowManager.FLAG_TURN_SCREEN_ON);
    _isLockScreenFlagsSet = true;
  }

  static Future<void> clearLockScreenFlags() async {
    // print("Clear Flags");
    if (!_isLockScreenFlagsSet) {
      // print("Clear Flags (Already Cleared)");
      return;
    }
    await FlutterWindowManager.clearFlags(
        FlutterWindowManager.FLAG_DISMISS_KEYGUARD);
    await FlutterWindowManager.clearFlags(
        FlutterWindowManager.FLAG_KEEP_SCREEN_ON);
    await FlutterWindowManager.clearFlags(
        FlutterWindowManager.FLAG_SHOW_WHEN_LOCKED);
    await FlutterWindowManager.clearFlags(
        FlutterWindowManager.FLAG_TURN_SCREEN_ON);
    _isLockScreenFlagsSet = false;
  }
}
