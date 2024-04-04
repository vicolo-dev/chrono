import 'dart:isolate';

import 'package:flutter/foundation.dart';

void printIsolateInfo() {
    printDebug(
        "Isolate: ${Isolate.current.debugName}, id: ${Isolate.current.hashCode}");
}

void printDebug(String message) {
  if (kDebugMode) {
    print(message);
  }
}
