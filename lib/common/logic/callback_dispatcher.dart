import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void callbackDispatcher() {
  const MethodChannel backgroundChannel = MethodChannel('background_channel');
  WidgetsFlutterBinding.ensureInitialized();

  backgroundChannel.setMethodCallHandler((MethodCall call) async {
    final List<dynamic> args = call.arguments;
    final Function? callbackThis = PluginUtilities.getCallbackFromHandle(
        CallbackHandle.fromRawHandle(args[0]));
    assert(callbackThis != null);
    String s = args[1] as String;
    callbackThis!(s);
  });
}
