import 'dart:isolate';

import 'package:flutter/foundation.dart';

void printIsolateInfo() {
  if (kDebugMode) {
    print(
        "Isolate: ${Isolate.current.debugName}, id: ${Isolate.current.hashCode}");
  }
}
