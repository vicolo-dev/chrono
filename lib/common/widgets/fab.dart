import 'package:clock_app/icons/flux_icons.dart';
import 'package:flutter/material.dart';

class FAB extends StatelessWidget {
  const FAB(
      {Key? key, this.onPressed, this.icon = FluxIcons.add, this.index = 0})
      : super(key: key);

  final VoidCallback? onPressed;
  final IconData icon;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 16 + (index * 64),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        elevation: 4,
        color: Theme.of(context).colorScheme.primary,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
