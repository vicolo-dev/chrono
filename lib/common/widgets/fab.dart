import 'package:clock_app/common/widgets/card_container.dart';
import 'package:clock_app/icons/flux_icons.dart';
import 'package:flutter/material.dart';

class FAB extends StatelessWidget {
  const FAB({
    Key? key,
    this.onPressed,
    this.icon = FluxIcons.add,
    this.index = 0,
    this.bottomPadding = 0,
    this.size = 1,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final IconData icon;
  final int index;
  final double bottomPadding;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottomPadding,
      right: 16 + (index * 45 * size),
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
