import 'dart:async';
import 'dart:ui';

import 'package:clock_app/common/logic/callback_dispatcher.dart';
import 'package:flutter/services.dart';

class InitiateCalls {
  static const MethodChannel _channel = MethodChannel('main_channel');

  static Future<void> initialize() async {
    final CallbackHandle? callback =
        PluginUtilities.getCallbackHandle(callbackDispatcher);
    await _channel
        .invokeMethod('initialize', <dynamic>[callback?.toRawHandle()]);
  }

  static void test(void Function(String s) callback) async {
    final List<dynamic> args = <dynamic>[
      PluginUtilities.getCallbackHandle(callback)?.toRawHandle()
    ];
    await _channel.invokeMethod('run', args);
  }
}
