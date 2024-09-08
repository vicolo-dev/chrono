part of '../builder/motion_animated_builder.dart';

typedef _DragItemUpdate = void Function(
    _DragInfo item, Offset position, Offset delta);
typedef _DragItemCallback = void Function(_DragInfo item);

class _DragInfo extends Drag {
  final bool gridView;
  final Axis scrollDirection;
  final _DragItemUpdate? onUpdate;
  final _DragItemCallback? onEnd;
  final _DragItemCallback? onCancel;
  final VoidCallback? onDragCompleted;
  final ReorderItemProxyDecorator? proxyDecorator;
  final TickerProvider tickerProvider;

  late MotionBuilderState listState;
  late int index;
  late Widget child;
  late Offset dragPosition;
  late Offset dragOffset;
  late Size itemSize;
  late double itemExtent;
  late CapturedThemes capturedThemes;
  ScrollableState? scrollable;
  AnimationController? _proxyAnimation;

  _DragInfo({
    required MotionAnimatedContentState item,
    Offset initialPosition = Offset.zero,
    required this.gridView,
    this.scrollDirection = Axis.vertical,
    this.onUpdate,
    this.onEnd,
    this.onCancel,
    this.onDragCompleted,
    this.proxyDecorator,
    required this.tickerProvider,
  }) {
    final RenderBox itemRenderBox =
        item.context.findRenderObject()! as RenderBox;
    listState = item.listState;
    index = item.index;
    child = item.widget.child;
    capturedThemes = item.widget.capturedThemes!;
    dragPosition = initialPosition;
    dragOffset = itemRenderBox.globalToLocal(initialPosition);
    itemSize = item.context.size!;
    itemExtent = _sizeExtent(itemSize, scrollDirection);
    scrollable = Scrollable.of(item.context);
  }

  void dispose() {
    _proxyAnimation?.dispose();
  }

  void startDrag() {
    _proxyAnimation = AnimationController(
        vsync: tickerProvider, duration: const Duration(milliseconds: 250))
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _dropCompleted();
        }
      })
      ..forward();
  }

  @override
  void update(DragUpdateDetails details) {
    final Offset delta = !gridView
        ? _restrictAxis(details.delta, scrollDirection)
        : details.delta;
    dragPosition += delta;
    onUpdate?.call(this, dragPosition, details.delta);
  }

  @override
  void end(DragEndDetails details) {
    _proxyAnimation!.reverse();
    onEnd?.call(this);
  }

  @override
  void cancel() {
    _proxyAnimation?.dispose();
    _proxyAnimation = null;
    onCancel?.call(this);
  }

  void _dropCompleted() {
    _proxyAnimation?.dispose();
    _proxyAnimation = null;
    onDragCompleted?.call();
  }

  Widget createProxy(BuildContext context) {
    return capturedThemes.wrap(_DragItemProxy(
        listState: listState,
        index: index,
        position: dragPosition - dragOffset - _overlayOrigin(context),
        size: itemSize,
        animation: _proxyAnimation!,
        proxyDecorator: proxyDecorator,
        child: child));
  }
}

double _sizeExtent(Size size, Axis scrollDirection) {
  switch (scrollDirection) {
    case Axis.horizontal:
      return size.width;
    case Axis.vertical:
      return size.height;
  }
}

Offset _restrictAxis(Offset offset, Axis scrollDirection) {
  switch (scrollDirection) {
    case Axis.horizontal:
      return Offset(offset.dx, 0.0);
    case Axis.vertical:
      return Offset(0.0, offset.dy);
  }
}

Offset _overlayOrigin(BuildContext context) {
  final OverlayState overlay =
      Overlay.of(context, debugRequiredFor: context.widget);
  final RenderBox overlayBox = overlay.context.findRenderObject()! as RenderBox;
  return overlayBox.localToGlobal(Offset.zero);
}

class _DragItemProxy extends StatelessWidget {
  final MotionBuilderState listState;
  final int index;
  final Widget child;
  final Offset position;
  final Size size;
  final AnimationController animation;
  final ReorderItemProxyDecorator? proxyDecorator;

  const _DragItemProxy(
      {required this.listState,
      required this.index,
      required this.child,
      required this.position,
      required this.size,
      required this.animation,
      required this.proxyDecorator});

  @override
  Widget build(BuildContext context) {
    final Widget proxyChild =
        proxyDecorator?.call(child, index, animation.view) ?? child;
    final Offset overlayOrigin = _overlayOrigin(context);
    return MediaQuery(
        data: MediaQuery.of(context).removePadding(removeTop: true),
        child: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            Offset effectivePosition = position;
            final Offset? dropPosition = listState._finalDropPosition;
            if (dropPosition != null) {
              effectivePosition = Offset.lerp(
                  dropPosition - overlayOrigin,
                  effectivePosition,
                  Curves.easeOut.transform(animation.value))!;
            }
            return Positioned(
                left: effectivePosition.dx,
                top: effectivePosition.dy,
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: child,
                ));
          },
          child: proxyChild,
        ));
  }
}
