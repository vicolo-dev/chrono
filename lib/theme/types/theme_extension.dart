import 'dart:ui';

import 'package:flutter/material.dart';

class ThemeStyleExtension extends ThemeExtension<ThemeStyleExtension> {
  final double shadowElevation;
  final double shadowOpacity;
  final double shadowBlurRadius;
  final double shadowSpreadRadius;
  final double borderRadius;
  final double borderWidth;

  const ThemeStyleExtension({
    this.shadowElevation = 1,
    this.shadowOpacity = 0.2,
    this.shadowBlurRadius = 1,
    this.shadowSpreadRadius = 0,
    this.borderRadius = 16,
    this.borderWidth = 0,
  });

  @override
  ThemeExtension<ThemeStyleExtension> copyWith({
    double? shadowElevation,
    double? shadowOpacity,
    double? shadowBlurRadius,
    double? shadowSpreadRadius,
    double? borderRadius,
    double? borderWidth,
  }) {
    return ThemeStyleExtension(
      shadowElevation: shadowElevation ?? this.shadowElevation,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      shadowSpreadRadius: shadowSpreadRadius ?? this.shadowSpreadRadius,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  @override
  ThemeExtension<ThemeStyleExtension> lerp(
      covariant ThemeExtension<ThemeStyleExtension>? other, double t) {
    if (other is! ThemeStyleExtension) return this;

    return ThemeStyleExtension(
      shadowElevation: lerpDouble(shadowElevation, other.shadowElevation, t)!,
      shadowOpacity: lerpDouble(shadowOpacity, other.shadowOpacity, t)!,
      shadowBlurRadius:
          lerpDouble(shadowBlurRadius, other.shadowBlurRadius, t)!,
      shadowSpreadRadius:
          lerpDouble(shadowSpreadRadius, other.shadowSpreadRadius, t)!,
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t)!,
    );
  }
}
