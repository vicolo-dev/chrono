import 'dart:math';

import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:flutter/material.dart';

/// Slider call to action component
class SlideAction extends StatefulWidget {
  /// The size of the sliding icon
  final double sliderButtonIconSize;

  /// Tha padding of the sliding icon
  final double sliderButtonIconPadding;

  /// The offset on the y axis of the slider icon
  final double sliderButtonYOffset;

  /// If the slider icon rotates
  final bool sliderRotate;

  /// The child that is rendered instead of the default Text widget
  final Widget? child;

  /// The height of the component
  final double height;

  /// The text showed in the default Text widget
  final String? rightText;

  final String? leftText;

  /// Callback called on submit
  /// If this is null the component will not animate to complete
  final VoidCallback? onSubmitRight;

  final VoidCallback? onSubmitLeft;

  /// The widget to render instead of the default icon
  final Widget? sliderButtonIcon;

  /// The widget to render instead of the default submitted icon
  final Widget? submittedIcon;

  /// The duration of the animations
  final Duration animationDuration;

  /// Create a new instance of the widget
  const SlideAction({
    Key? key,
    this.sliderButtonIconSize = 24,
    this.sliderButtonIconPadding = 16,
    this.sliderButtonYOffset = 0,
    this.sliderRotate = true,
    this.height = 70,
    this.animationDuration = const Duration(milliseconds: 300),
    this.submittedIcon,
    this.onSubmitRight,
    this.child,
    this.sliderButtonIcon,
    this.onSubmitLeft,
    this.rightText,
    this.leftText,
  }) : super(key: key);
  @override
  SlideActionState createState() => SlideActionState();
}

/// Use a GlobalKey to access the state. This is the only way to call [SlideActionState.reset]
class SlideActionState extends State<SlideAction>
    with TickerProviderStateMixin {
  final GlobalKey _containerKey = GlobalKey();
  final GlobalKey _sliderKey = GlobalKey();
  double _maxPosition = 0;
  double _position = 0;
  double _initialPosition = 0;
  double get _progress => _position / _maxPosition;
  // leftProgress is 1 when _progress is 0 and 0 when _progress >= 0.5
  // double get leftProgress => max(1 - (1 / 0.5) * (_progress + 0.5), 0);
  double _endXPosition = 0;
  double? _containerWidth;
  late AnimationController _cancelAnimationController;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _containerKey,
      height: widget.height,
      width: _containerWidth,
      constraints: _containerWidth != null
          ? null
          : BoxConstraints.expand(height: widget.height),
      child: CardContainer(
        color: Theme.of(context).colorScheme.secondary,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              // opacity should be 1 at 0.5 progress and 0 at 1 progress or 0 progress
              opacity: (-2 * max(-(_progress - 0.5), (_progress - 0.5)) + 1)
                  .clamp(0.0, 1.0)
                  .toDouble(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      widget.leftText ?? 'Left',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                    const Spacer(),
                    Text(
                      widget.rightText ?? 'Right',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: widget.sliderButtonYOffset,
              child: Transform.translate(
                offset: Offset(_position, 0),
                child: Container(
                  key: _sliderKey,
                  child: GestureDetector(
                    onHorizontalDragUpdate: onHorizontalDragUpdate,
                    onHorizontalDragEnd: (details) async {
                      _endXPosition = _position;
                      if (_progress < 0.1) {
                        if (widget.onSubmitLeft != null) {
                          widget.onSubmitLeft!();
                        } else {
                          _cancelAnimation();
                        }
                      } else if (_progress > 0.9) {
                        if (widget.onSubmitRight != null) {
                          widget.onSubmitRight!();
                        } else {
                          _cancelAnimation();
                        }
                      } else {
                        _cancelAnimation();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CardContainer(
                        color: Theme.of(context).colorScheme.surface,
                        child: Container(
                          padding:
                              EdgeInsets.all(widget.sliderButtonIconPadding),
                          child: Center(
                            child: widget.sliderButtonIcon ??
                                Icon(
                                  FluxIcons.alarm,
                                  size: widget.sliderButtonIconSize,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _position = (_position + details.delta.dx).clamp(0.0, _maxPosition);
    });
  }

  /// Call this method to revert the animations
  Future reset() async {
    await _cancelAnimation();
  }

  Future _cancelAnimation() async {
    _cancelAnimationController.reset();
    final animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _cancelAnimationController,
      curve: Curves.fastOutSlowIn,
    ));

    animation.addListener(() {
      if (mounted) {
        setState(() {
          double delta = _endXPosition - _initialPosition;
          _position = (_endXPosition - (delta * animation.value));
        });
      }
    });
    _cancelAnimationController.forward().orCancel;
  }

  @override
  void initState() {
    super.initState();

    _cancelAnimationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox containerBox =
          _containerKey.currentContext!.findRenderObject() as RenderBox;
      _containerWidth = containerBox.size.width;

      final RenderBox sliderBox =
          _sliderKey.currentContext!.findRenderObject() as RenderBox;
      final sliderWidth = sliderBox.size.width;

      setState(() {
        _maxPosition = _containerWidth! -
            (sliderWidth / 2) -
            40 -
            widget.sliderButtonYOffset;

        _initialPosition = _maxPosition / 2;
        _position = _initialPosition;
      });
    });
  }

  @override
  void dispose() {
    _cancelAnimationController.dispose();
    super.dispose();
  }
}
