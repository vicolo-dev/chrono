import 'dart:ui';

import 'package:flutter/material.dart';

class ShadowStyle extends ThemeExtension<ShadowStyle> {
  final double elevation;
  final Color color;
  final double opacity;
  final double blurRadius;

  const ShadowStyle({
    this.elevation = 1,
    this.color = Colors.black,
    this.opacity = 0.2,
    this.blurRadius = 1,
  });

  @override
  ThemeExtension<ShadowStyle> copyWith({
    double? elevation,
    Color? color,
    double? opacity,
    double? blurRadius,
  }) {
    return ShadowStyle(
      elevation: elevation ?? this.elevation,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      blurRadius: blurRadius ?? this.blurRadius,
    );
  }

  @override
  ThemeExtension<ShadowStyle> lerp(
      covariant ThemeExtension<ShadowStyle>? other, double t) {
    if (other is! ShadowStyle) return this;

    return ShadowStyle(
      elevation: lerpDouble(elevation, other.elevation, t)!,
      color: Color.lerp(color, other.color, t)!,
      opacity: lerpDouble(opacity, other.opacity, t)!,
      blurRadius: lerpDouble(blurRadius, other.blurRadius, t)!,
    );
  }
}
