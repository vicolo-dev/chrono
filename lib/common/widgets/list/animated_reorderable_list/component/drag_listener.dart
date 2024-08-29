import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import '../builder/motion_animated_builder.dart';

class ReorderableGridDragStartListener extends StatelessWidget {
  /// Creates a listener for a drag immediately following a pointer down
  /// event over the given child widget.
  ///
  /// This is most commonly used to wrap part of a grid item like a drag
  /// handle.
  const ReorderableGridDragStartListener({
    super.key,
    required this.child,
    required this.index,
    this.enabled = true,
  });

  /// The widget for which the application would like to respond to a tap and
  /// drag gesture by starting a reordering drag on a reorderable grid.
  final Widget child;

  /// The index of the associated item that will be dragged in the grid.
  final int index;

  /// Whether the [child] item can be dragged and moved in the grid.
  ///
  /// If true, the item can be moved to another location in the grid when the
  /// user taps on the child. If false, tapping on the child will be ignored.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: enabled
          ? (PointerDownEvent event) => _startDragging(context, event)
          : null,
      child: child,
    );
  }

  /// Provides the gesture recognizer used to indicate the start of a reordering
  /// drag operation.
  ///
  /// By default this returns an [ImmediateMultiDragGestureRecognizer] but
  /// subclasses can use this to customize the drag start gesture.
  @protected
  MultiDragGestureRecognizer createRecognizer() {
    return DelayedMultiDragGestureRecognizer(debugOwner: this,delay: const Duration(milliseconds: 1));
  }

  void _startDragging(BuildContext context, PointerDownEvent event) {
    final MotionBuilderState? list = MotionBuilder.maybeOf(context);
    list?.startItemDragReorder(
      index: index,
      event: event,
      recognizer: createRecognizer(),
    );
  }
}

/// A wrapper widget that will recognize the start of a drag operation by
/// looking for a long press event. Once it is recognized, it will start
/// a drag operation on the wrapped item in the reorderable grid.
///
/// See also:
///
///  * [ReorderableGridDragStartListener], a similar wrapper that will
///    recognize the start of the drag immediately after a pointer down event.
///  * [ReorderableGrid], a widget grid that allows the user to reorder
///    its items.
///  * [SliverReorderableGrid], a sliver grid that allows the user to reorder
///    its items.
///  * [ReorderableGridView], a material design grid that allows the user to
///    reorder its items.
class ReorderableGridDelayedDragStartListener
    extends ReorderableGridDragStartListener {
  /// Creates a listener for an drag following a long press event over the
  /// given child widget.
  ///
  /// This is most commonly used to wrap an entire grid item in a reorderable
  /// grid.
  const ReorderableGridDelayedDragStartListener({
    super.key,
    required super.child,
    required super.index,
    super.enabled,
  });

  @override
  MultiDragGestureRecognizer createRecognizer() {
    return DelayedMultiDragGestureRecognizer(debugOwner: this);
  }
}
