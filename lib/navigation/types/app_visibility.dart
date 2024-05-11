import 'dart:async';

import 'package:clock_app/common/utils/list_storage.dart';
import 'package:clock_app/navigation/data/fullscreen_intent.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';

class AppVisibility {
  static StreamSubscription<FGBGType>? subscription;

  static FGBGType _state = FGBGType.background;

  static FGBGType get state => _state;

  static void setState(FGBGType type) {
    _state = type;
  }

  static void initialize() {
    // if (loadTextFileSync(fullscreenIntentKey) == "true") {
    //   saveTextFile(fullscreenIntentKey, "false");
    // } else {
      setState(FGBGType.foreground);
    // }

    subscription = FGBGEvents.stream.listen((event) {
      setState(event);
    });
  }

  static void dispose() {
    subscription?.cancel();
  }
}
