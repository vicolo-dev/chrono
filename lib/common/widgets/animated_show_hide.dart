import 'package:flutter/material.dart';

/// A typedef for a custom animation transition builder used by
/// [AnimatedShowHide] and [AnimatedShowHideChild].
///
/// The [AnimatedShowHideTransitionBuilder] typedef represents a function that
/// takes the current build context, an animation object, and the child widget as
/// arguments and returns a widget. This function allows for custom animation
/// transitions when showing or hiding a child widget.
///
/// The animation object provides information about the current state of the
/// animation, including the value, which ranges from 0.0 to 1.0. You can use
/// this information to control the appearance and behavior of the child widget
/// during the transition.
///
/// {@tool snippet}
/// This example shows how to use a custom animation transition builder to
/// create a fade-in/fade-out animation.
///
/// ```dart
/// AnimatedShowHide(
///   child: const Text('Hello World!'),
///   transitionBuilder: (context, animation, child) {
///     return FadeTransition(
///       opacity: animation,
///       child: child,
///     );
///   },
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [AnimatedShowHide]
///  * [AnimatedShowHideChild]
///  * [FadeTransition]
typedef AnimatedShowHideTransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Widget? child,
);

/// A widget that manages the showing and hiding of a child widget based on
/// animation.
///
/// The [AnimatedShowHide] widget uses an [AnimationController] to animate the
/// showing and hiding of its child widget. The animation is controlled by the
/// [animate] property, which determines whether the child widget should be shown
/// or hidden.
///
/// The animation can be customized using the [duration], [curve], [axis], and
/// [axisAlignment] properties. The [transitionBuilder] property can be used to
/// provide a custom animation transition.
///
/// {@tool snippet}
/// This example shows how to use the [AnimatedShowHide] widget to animate the
/// showing and hiding of a child widget.
///
/// ```dart
/// AnimatedShowHide(
///   child: const Text('Hello World!'),
///   animate: true,
///   duration: const Duration(seconds: 1),
///   curve: Curves.bounceInOut,
///   axis: Axis.horizontal,
///   axisAlignment: 0.5,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [AnimatedShowHideChild]
///  * [AnimatedShowHideTransitionBuilder]
///  * [SizeTransition]
///  * [FadeTransition]
class AnimatedShowHide extends StatelessWidget {
  /// Creates a new [AnimatedShowHide] widget.
  ///
  /// The [child] property is the widget to be shown or hidden. The [animate]
  /// property determines whether the child widget should be shown or hidden. The
  /// [duration], [curve], [axis], and [axisAlignment] properties can be used to
  /// customize the animation. The [transitionBuilder] property can be used to
  /// provide a custom animation transition.
  const AnimatedShowHide({
    this.child,
    this.animate = true,
    this.duration = const Duration(milliseconds: 180),
    this.curve = Curves.ease,
    this.axis = Axis.vertical,
    this.axisAlignment = -1,
    this.transitionBuilder,
    super.key,
  });

  /// The widget to be shown or hidden.
  final Widget? child;

  /// Whether to animate the showing and hiding of the child widget.
  final bool animate;

  /// The duration of the animation.
  final Duration duration;

  /// The curve of the animation.
  final Curve curve;

  /// The axis of the animation.
  final Axis axis;

  /// The axis alignment of the animation.
  final double axisAlignment;

  /// A custom animation transition builder.
  final AnimatedShowHideTransitionBuilder? transitionBuilder;

  Widget buildAnimationWidget(BuildContext context) {
    return AnimatedShowHideChild(
      transitionBuilder: transitionBuilder,
      duration: duration,
      curve: curve,
      axis: axis,
      axisAlignment: axisAlignment,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (animate) {
      return buildAnimationWidget(context);
    }
    return child ?? const SizedBox();
  }
}

/// A widget that manages the showing and hiding of a child widget based on animation.
///
/// The [AnimatedShowHideChild] widget uses an [AnimationController] to animate the
/// showing and hiding of its child widget.
///
/// The animation can be customized using the [duration], [curve], [axis], and
/// [axisAlignment] properties. The [transitionBuilder] property can be used to
/// provide a custom animation transition.
///
/// {@tool snippet}
/// This example shows how to use the [AnimatedShowHideChild] widget to animate the
/// showing and hiding of a child widget.
///
/// ```dart
/// AnimatedShowHideChild(
///   child: show ? const Text('Hello World!') : null,
///   animate: true,
///   duration: const Duration(seconds: 1),
///   curve: Curves.bounceInOut,
///   axis: Axis.horizontal,
///   axisAlignment: 0.5,
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [AnimatedShowHide]
///  * [AnimatedShowHideTransitionBuilder]
///  * [SizeTransition]
///  * [FadeTransition]
class AnimatedShowHideChild extends StatefulWidget {
  /// Creates a new [AnimatedShowHideChild] widget.
  ///
  /// The [child] property is the widget to be shown or hidden. The
  /// [duration], [curve], [axis], and [axisAlignment] properties can be used to
  /// customize the animation. The [transitionBuilder] property can be used to
  /// provide a custom animation transition.
  const AnimatedShowHideChild({
    this.child,
    this.duration = const Duration(milliseconds: 180),
    this.curve = Curves.ease,
    this.axis = Axis.vertical,
    this.axisAlignment = -1,
    this.transitionBuilder,
    super.key,
  });

  /// The widget to be shown or hidden.
  final Widget? child;

  /// The duration of the animation.
  final Duration duration;

  /// The curve of the animation.
  final Curve curve;

  /// The axis of the animation.
  final Axis axis;

  /// The axis alignment of the animation.
  final double axisAlignment;

  /// A custom animation transition builder.
  final AnimatedShowHideTransitionBuilder? transitionBuilder;

  @override
  State<AnimatedShowHideChild> createState() => _AnimatedShowHideChildState();
}

class _AnimatedShowHideChildState extends State<AnimatedShowHideChild>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  late Animation<double> animation;

  void _listener() {
    if (controller?.isDismissed ?? false) {
      setState(() {
        outGoingChild = const SizedBox();
      });
    }
  }

  Widget outGoingChild = const SizedBox();

  @override
  void initState() {
    controller ??= AnimationController(vsync: this, duration: widget.duration);
    controller!.addListener(_listener);
    animation = CurvedAnimation(
      parent: controller!.drive(Tween<double>(begin: 0, end: 1)),
      curve: widget.curve,
    );
    controller!.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller?.removeListener(_listener);
    controller?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedShowHideChild oldWidget) {
    super.didUpdateWidget(oldWidget);
    animatedOnChanges(oldWidget);
  }

  // This method manages the changes in the animated widget and ensures the appropriate actions are taken based on the properties of the current and previous widgets.
  //
  // If the `transitionBuilder` property of the current widget is null, it checks the `child` property of the previous widget. If the previous child is not null, it sets `_outGoingChild` to the previous child; otherwise, it sets it to `SizedBox()`.
  //
  // If the `child` property of the current widget is null, it calls `reverse()` on `_controller`; otherwise, it calls `forward()`.
  //
  // If the `transitionBuilder` property is not null, it checks and sets `_outGoingChild` based on the transition builder's call with the context, animation, and child properties. It then decides whether to call `reverse()` or `forward()` on `_controller` based on the transition builder's call result.
  void animatedOnChanges(covariant AnimatedShowHideChild oldWidget) {
    if (widget.transitionBuilder == null) {
      if (oldWidget.child != null) {
        outGoingChild = oldWidget.child ?? const SizedBox();
      }
      if (widget.child == null) {
        controller?.reverse();
      } else {
        controller?.forward();
      }
    } else {
      if (oldWidget.transitionBuilder?.call(context, animation, widget.child) !=
          null) {
        outGoingChild = oldWidget.transitionBuilder
                ?.call(context, animation, widget.child) ??
            const SizedBox();
      }
      if (widget.transitionBuilder?.call(context, animation, widget.child) ==
          null) {
        controller?.reverse();
      } else {
        controller?.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.transitionBuilder != null) {
      return widget.transitionBuilder!(
        context,
        animation,
        widget.child,
      );
    }
    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: widget.axisAlignment,
      axis: widget.axis,
      child: widget.child ?? outGoingChild,
    );
  }
}
