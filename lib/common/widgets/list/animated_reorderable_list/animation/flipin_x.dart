import 'dart:math';

import 'package:clock_app/common/widgets/list/animated_reorderable_list/animation/provider/animation_effect.dart';
import 'package:flutter/cupertino.dart';

class FlipInX extends AnimationEffect<double> {
  static const double beginValue = pi / 2;
  static const double endValue = 0.0;
  final double? begin;
  final double? end;

  FlipInX({super.delay, super.duration, super.curve, this.begin, this.end});

  @override
  Widget build(BuildContext context, Widget child, Animation<double> animation,
      EffectEntry entry, Duration totalDuration) {
    final Animation<double> rotation = buildAnimation(entry, totalDuration,
            begin: begin ?? beginValue, end: endValue)
        .animate(animation);
    return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return Transform(
            transform: Matrix4.rotationX(rotation.value),
            alignment: Alignment.center,
            child: child,
          );
        },
        child: child);
  }
}
