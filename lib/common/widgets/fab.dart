import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:flutter/material.dart';

enum FabPosition { bottomLeft, bottomRight }

class FAB extends StatelessWidget {
  const FAB({
    Key? key,
    this.onPressed,
    this.icon = FluxIcons.add,
    this.index = 0,
    this.bottomPadding = 80,
    this.size = 1,
    this.position = FabPosition.bottomRight,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final IconData icon;
  final int index;
  final double bottomPadding;
  final double size;
  final FabPosition position;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottomPadding,
      right: position == FabPosition.bottomRight
          ? 16 + (index * 24 * size) + index * 36
          : null,
      left: position == FabPosition.bottomLeft
          ? 16 + (index * 24 * size) + index * 36
          : null,
      child: CardContainer(
        elevationMultiplier: 2,
        color: Theme.of(context).colorScheme.primary,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 24 * size,
          ),
        ),
      ),
    );
  }
}
