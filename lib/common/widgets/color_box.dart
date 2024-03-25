import 'package:flutter/material.dart';

class ColorBox extends StatelessWidget {
  const ColorBox({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
  CardTheme cardTheme = Theme.of(context).cardTheme;

    return Container(
      width: 36.0,
      height: 36.0,
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            (cardTheme.shape != null) ? (cardTheme.shape as RoundedRectangleBorder)
                .borderRadius : null,
        border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            width: 1.0),
      ),
    );
  }
}
