import 'package:clock_app/common/widgets/list/animated_reorderable_list/animation/provider/animation_effect.dart';
import 'package:flutter/material.dart';

import 'motion_animated_builder.dart';
import 'motion_list_base.dart';

class MotionListImpl<E extends Object> extends MotionListBase<Widget, E> {
  const MotionListImpl({
    super.key,
    required super.items,
    required super.itemBuilder,
    super.enterTransition,
    super.exitTransition,
    super.insertDuration,
    super.removeDuration,
    super.onReorder,
    super.onReorderStart,
    super.onReorderEnd,
    super.proxyDecorator,
    required super.scrollDirection,
    super.insertItemBuilder,
    super.removeItemBuilder,
    super.buildDefaultDragHandles,
    super.useDefaultDragListeners = true,
    super.longPressDraggable,
    super.isSameItem,
  });

  const MotionListImpl.grid({
    Key? key,
    required List<E> items,
    required ItemBuilder itemBuilder,
    required SliverGridDelegate sliverGridDelegate,
    List<AnimationEffect>? enterTransition,
    List<AnimationEffect>? exitTransition,
    ReorderCallback? onReorder,
    void Function(int)? onReorderStart,
    void Function(int)? onReorderEnd,
    ReorderItemProxyDecorator? proxyDecorator,
    Duration? insertDuration,
    Duration? removeDuration,
    required Axis scrollDirection,
    AnimatedWidgetBuilder? insertItemBuilder,
    AnimatedWidgetBuilder? removeItemBuilder,
    bool? buildDefaultDragHandles,
    bool useDefaultDragListeners = true,
    bool? longPressDraggable,
    bool Function(E a, E b)? isSameItem,
  }) : super(
            key: key,
            items: items,
            itemBuilder: itemBuilder,
            sliverGridDelegate: sliverGridDelegate,
            enterTransition: enterTransition,
            exitTransition: exitTransition,
            insertDuration: insertDuration,
            removeDuration: removeDuration,
            onReorder: onReorder,
            onReorderStart: onReorderStart,
            onReorderEnd: onReorderEnd,
            proxyDecorator: proxyDecorator,
            scrollDirection: scrollDirection,
            insertItemBuilder: insertItemBuilder,
            removeItemBuilder: removeItemBuilder,
            buildDefaultDragHandles: buildDefaultDragHandles,
            longPressDraggable: longPressDraggable,
            useDefaultDragListeners: useDefaultDragListeners,
            isSameItem: isSameItem);

  @override
  MotionListImplState<E> createState() => MotionListImplState<E>();
}

class MotionListImplState<E extends Object>
    extends MotionListBaseState<Widget, MotionListImpl<E>, E> {
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasOverlay(context));
    return MotionBuilder(
      key: listKey,
      initialCount: oldList.length,
      onReorder: onReorder,
      onReorderStart: onReorderStart,
      onReorderEnd: onReorderEnd,
      proxyDecorator: proxyDecorator,
      insertAnimationBuilder: insertAnimationBuilder,
      removeAnimationBuilder: removeAnimationBuilder,
      itemBuilder: itemBuilder,
      scrollDirection: scrollDirection,
      delegateBuilder: sliverGridDelegate,
      buildDefaultDragHandles: buildDefaultDragHandles,
      longPressDraggable: longPressDraggable,
     useDefaultDragListeners: useDefaultDragListeners,
    );
  }
}
