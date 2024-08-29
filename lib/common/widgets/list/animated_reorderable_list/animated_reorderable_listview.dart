import 'package:clock_app/common/widgets/list/animated_reorderable_list/animation/provider/animation_effect.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'builder/motion_list_base.dart';
import 'builder/motion_list_impl.dart';

///A [ListView] that enables users to interactively reorder items through dragging, with animated insertion and removal of items.
///
///  enterTransition: [FadeEffect(), ScaleEffect()],
///
/// Effects are always run in parallel (ie. the fade and scale effects in the
/// example above would be run simultaneously), but you can apply delays to
/// offset them or run them in sequence.
///
/// The [onReorder] parameter is required and will be called when a child
/// widget is dragged to a new position.
///
/// By default, on [TargetPlatformVariant.desktop] platforms each item will
/// have a drag handle added on top of it that will allow the user to grab it
/// to move the item. On [TargetPlatformVariant.mobile], no drag handle will be
/// added, but when the user long presses anywhere on the item it will start
/// moving the item.Displaying drag handles can be controlled with [AnimatedReorderableListView.buildDefaultDragHandles].
///
/// All list items must have a key.
///
/// While a drag is underway, the widget returned by the [AnimatedReorderableGridView.proxyDecorator]
/// callback serves as a "proxy" (a substitute) for the item in the list. The proxy is
/// created with the original list item as its child.

class AnimatedReorderableListView<E extends Object> extends StatelessWidget {
  /// The current list of items that this[AnimatedReorderableListView] should represent.
  final List<E> items;

  ///Called, as needed, to build list item widget
  final ItemBuilder itemBuilder;

  ///List of [AnimationEffect](s) used for the appearing animation when an item was inserted into the list.
  ///
  ///Defaults to [FadeAnimation()]
  final List<AnimationEffect>? enterTransition;

  ///List of [AnimationEffect](s) used for the disappearing animation when an item was removed from the list.
  ///
  ///Defaults to [FadeAnimation()]
  final List<AnimationEffect>? exitTransition;

  /// The duration of the animation when an item was inserted into the list.
  ///
  /// If you provide a specific duration for each AnimationEffect, it will override this [insertDuration].
  final Duration? insertDuration;

  /// The duration of the animation when an item was removed from the list.
  ///
  /// If you provide a specific duration for each AnimationEffect, it will override this [removeDuration].
  final Duration? removeDuration;

  /// A callback used by [ReorderableList] to report that a list item has moved
  /// to a new position in the list.
  ///
  /// Implementations should remove the corresponding list item at [oldIndex]
  /// and reinsert it at [newIndex].
  final ReorderCallback onReorder;

  /// A callback that is called when an item drag has started.
  ///
  /// The index parameter of the callback is the index of the selected item.
  final void Function(int)? onReorderStart;

  /// A callback that is called when the dragged item is dropped.
  ///
  /// The index parameter of the callback is the index where the item is
  /// dropped. Unlike [onReorder], this is called even when the list item is
  /// dropped in the same location.
  final void Function(int)? onReorderEnd;

  /// The axis along which the scroll view scrolls.
  ///
  /// Defaults to [Axis.vertical].
  final Axis scrollDirection;

  /// {@template flutter.widgets.reorderable_list.proxyDecorator}
  /// A callback that allows the app to add an animated decoration around
  /// an item when it is being dragged.
  /// {@endtemplate}
  final ReorderItemProxyDecorator? proxyDecorator;

  /// If true, on desktop platforms, a drag handle is stacked over the center of each item's trailing edge;
  /// on mobile platforms, a long press anywhere on the item starts a drag.
  ///
  /// The default desktop drag handle is just an [Icons.drag_handle] wrapped by [ReorderableDragStartListener].
  /// On mobile platforms, the entire item is wrapped with a [ReorderableDragStartListener].
  ///
  /// To change the appearance or the layout of the drag handles, make this parameter false
  /// and wrap each list item, or a widget within each list item, with [ReorderableDragStartListener]or
  /// a subclass of [ReorderableDragStartListener].
  ///
  /// To get the idea [Flutter Example](https://api.flutter.dev/flutter/material/ReorderableListView/buildDefaultDragHandles.html)

  final bool buildDefaultDragHandles;

  /// {@template flutter.widgets.scroll_view.reverse}
  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// For example, if the reading direction is left-to-right and
  /// [scrollDirection] is [Axis.horizontal], then the scroll view scrolls from
  /// left to right when [reverse] is false and from right to left when
  /// [reverse] is true.
  ///
  /// Similarly, if [scrollDirection] is [Axis.vertical], then the scroll view
  /// scrolls from top to bottom when [reverse] is false and from bottom to top
  /// when [reverse] is true.
  ///
  /// Defaults to false.
  /// {@endtemplate}
  final bool reverse;

  /// [ScrollController] to get the current scroll position.
  ///
  ///  Must be null if [primary] is true.
  ///
  ///  It can be used to read the current
  //   scroll position (see [ScrollController.offset]), or change it (see
  //   [ScrollController.animateTo]).
  final ScrollController? controller;

  /// When this is true, the scroll view is scrollable even if it does not have
  /// sufficient content to actually scroll. Otherwise, by default the user can
  /// only scroll the view if it has sufficient content. See [physics].
  ///
  /// Cannot be true while a [ScrollController] is provided to `controller`,
  /// only one ScrollController can be associated with a ScrollView.
  ///
  /// Defaults to null.
  final bool? primary;

  /// {@template flutter.widgets.reorderable_list.padding}
  /// The amount of space by which to inset the list contents.
  ///
  /// It defaults to `EdgeInsets.all(0)`.
  /// {@endtemplate}
  final EdgeInsetsGeometry? padding;

  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions. Furthermore, if [primary] is
  /// false, then the user cannot scroll if there is insufficient content to
  /// scroll, while if [primary] is true, they can always attempt to scroll.
  final ScrollPhysics? physics;

  /// [ScrollBehavior]s also provide [ScrollPhysics]. If an explicit
  /// [ScrollPhysics] is provided in [physics], it will take precedence,
  /// followed by [scrollBehavior], and then the inherited ancestor
  /// [ScrollBehavior].
  final ScrollBehavior? scrollBehavior;

  /// Creates a ScrollView that creates custom scroll effects using slivers.
  /// See the ScrollView constructor for more details on these arguments.
  final String? restorationId;

  /// [ScrollViewKeyboardDismissBehavior] the defines how this [ScrollView] will
  /// dismiss the keyboard automatically.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// Defaults to [Clip.hardEdge].
  ///
  /// Creates a ScrollView that creates custom scroll effects using slivers.
  /// See the ScrollView constructor for more details on these arguments.
  final Clip clipBehavior;

  /// Creates a ScrollView that creates custom scroll effects using slivers.
  /// See the ScrollView constructor for more details on these arguments.
  final DragStartBehavior dragStartBehavior;

  /// A custom builder that is for adding items with animations.
  ///
  /// The child argument is the widget that is returned by [itemBuilder],
  ///  and the `animation` is an [Animation] that should be used to animate an exit
  /// transition for the widget that is built.
  final AnimatedWidgetBuilder? insertItemBuilder;

  /// A custom builder that is for removing items with animations.
  ///
  /// The child argument is the widget that is returned by [itemBuilder],
  ///  and the `animation` is an [Animation] that should be used to animate an exit
  /// transition for the widget that is built.
  final AnimatedWidgetBuilder? removeItemBuilder;

  /// Whether the items can be dragged by long pressing on them.
  final bool longPressDraggable;

  final bool useDefaultDragListeners;

  /// Whether the extent of the scroll view in the scrollDirection should be determined by the contents being viewed.
  final bool shrinkWrap;

  /// A function that compares two items to determine whether they are the same.
  final bool Function(E a, E b)? isSameItem;

  const AnimatedReorderableListView({
    Key? key,
    required this.items,
    required this.itemBuilder,
    required this.onReorder,
    this.enterTransition,
    this.exitTransition,
    this.insertDuration,
    this.removeDuration,
    this.onReorderStart,
    this.onReorderEnd,
    this.proxyDecorator,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.scrollBehavior,
    this.restorationId,
    this.buildDefaultDragHandles = true,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.insertItemBuilder,
    this.removeItemBuilder,
    this.longPressDraggable = true,
    this.useDefaultDragListeners = true,
    this.shrinkWrap = false,
    this.isSameItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
        scrollDirection: scrollDirection,
        reverse: reverse,
        controller: controller,
        primary: primary,
        physics: physics,
        scrollBehavior: scrollBehavior,
        restorationId: restorationId,
        keyboardDismissBehavior: keyboardDismissBehavior,
        dragStartBehavior: dragStartBehavior,
        clipBehavior: clipBehavior,
        shrinkWrap: shrinkWrap,
        slivers: [
          SliverPadding(
            padding: padding ?? EdgeInsets.zero,
            sliver: MotionListImpl(
              items: items,
              itemBuilder: itemBuilder,
              enterTransition: enterTransition,
              exitTransition: exitTransition,
              insertDuration: insertDuration,
              removeDuration: removeDuration,
              onReorder: onReorder,
              onReorderStart: onReorderStart,
              onReorderEnd: onReorderEnd,
              proxyDecorator: proxyDecorator,
              buildDefaultDragHandles: buildDefaultDragHandles,
              scrollDirection: scrollDirection,
              insertItemBuilder: insertItemBuilder,
              removeItemBuilder: removeItemBuilder,
              longPressDraggable: longPressDraggable,
              useDefaultDragListeners: useDefaultDragListeners,
              isSameItem: isSameItem,
            ),
          ),
        ]);
  }
}
