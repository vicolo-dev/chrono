import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

extension AnimateWidgetExtensions on Widget {
  Animate animateCard(dynamic key) => animate(delay: 50.ms, key: key)
      .slideY(begin: 0.15, end: 0, duration: 150.ms, curve: Curves.easeOut)
      .fade(duration: 150.ms, curve: Curves.easeOut);
  
}

extension AnimateListExtensions on List<Widget> {
  /// Wraps the target `List<Widget>` in an [AnimateList] instance, and returns
  /// the instance for chaining calls.
  /// Ex. `[foo, bar].animate()` is equivalent to `AnimateList(children: [foo, bar])`.
  AnimateList animateCardList() => animate()
      .slideY(begin: 0.15, end: 0, duration: 150.ms, curve: Curves.easeOut)
      .fade(duration: 150.ms, curve: Curves.easeOut);
}
