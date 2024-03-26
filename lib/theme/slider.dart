import 'package:clock_app/theme/types/color_scheme.dart';
import 'package:flutter/material.dart';

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

SliderThemeData getSliderTheme(ColorSchemeData colorScheme) {
  return SliderThemeData(
      // trackShape: CustomTrackShape(),
      overlayShape: SliderComponentShape.noOverlay,
      inactiveTrackColor: colorScheme.onBackground.withOpacity(0.2)
      // overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
      );
}
