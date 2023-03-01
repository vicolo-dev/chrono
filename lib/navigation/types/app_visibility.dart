import 'dart:async';

import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:get_storage/get_storage.dart';

class AppVisibility {
  static StreamSubscription<FGBGType>? subscription;

  static FGBGType _state = FGBGType.background;

  static FGBGType get state => _state;

  static void setState(FGBGType type) {
    _state = type;
  }

  static void initialize() {
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
