import 'dart:async';

import 'package:clock_app/settings/types/settings_manager.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';

class AppVisibilityListener {
  static StreamSubscription<FGBGType>? subscription;

  static FGBGType _state = FGBGType.background;

  static FGBGType get state => _state;

  static void setState(FGBGType type) {
    print("FGBGType: $type");
    _state = type;
  }

  static void initialize() {
    print(
        "Is Alarm Recently Triggered: ${SettingsManager.preferences?.getBool("fullScreenNotificationRecentlyShown")}");
    if (SettingsManager.preferences
            ?.getBool("fullScreenNotificationRecentlyShown") ==
        true) {
      SettingsManager.preferences
          ?.setBool("fullScreenNotificationRecentlyShown", false);
    } else {
      setState(FGBGType.foreground);
    }

    subscription = FGBGEvents.stream.listen((event) {
      setState(event);
    });
  }

  static void dispose() {
    subscription?.cancel();
  }
}
