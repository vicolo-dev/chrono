import 'dart:async';

import 'package:clock_app/settings/types/settings_manager.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get_storage/get_storage.dart';

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
        "Is Alarm Recently Triggered: ${GetStorage().read<bool>("fullScreenNotificationRecentlyShown")}");
    if (GetStorage().read<bool>("fullScreenNotificationRecentlyShown") ==
        true) {
      GetStorage().write("fullScreenNotificationRecentlyShown", false);
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
