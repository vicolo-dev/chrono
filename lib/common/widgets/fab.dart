import 'package:clock_app/icons/flux_icons.dart';
import 'package:flutter/material.dart';

class FAB extends StatelessWidget {
  const FAB({Key? key, this.onPressed}) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 16,
      child: GestureDetector(
        onTap: onPressed,
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          elevation: 4,
          color: Theme.of(context).colorScheme.primary,
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(FluxIcons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
