import 'package:flutter/material.dart';

int getId() {
  return UniqueKey().hashCode + DateTime.now().microsecondsSinceEpoch;
}
