import 'package:clock_app/common/widgets/list/animated_reorderable_list/animation/provider/animation_effect.dart';
import 'package:flutter/cupertino.dart';

class ScaleInRight extends AnimationEffect<double> {
  static const double beginValue = 0.0;
  static const double endValue = 1.0;
  final double? begin;
  final double? end;

  ScaleInRight(
      {super.delay, super.duration, super.curve, this.begin, this.end});

  @override
  Widget build(BuildContext context, Widget child, Animation<double> animation,
      EffectEntry entry, Duration totalDuration) {
    final Animation<double> scale = buildAnimation(entry, totalDuration,
            begin: begin ?? beginValue, end: endValue)
        .animate(animation);
    return ScaleTransition(
      alignment: Alignment.centerRight,
      scale: scale,
      child: child,
    );
  }
}
