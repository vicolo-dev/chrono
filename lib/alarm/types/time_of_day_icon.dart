import 'package:clock_app/common/types/time.dart';
import 'package:flutter/material.dart';

class TimeIcon {
  final IconData icon;
  final Color color;
  final Time startTime;
  final Time endTime;

  TimeIcon(this.icon, this.color, this.startTime, this.endTime);
}
