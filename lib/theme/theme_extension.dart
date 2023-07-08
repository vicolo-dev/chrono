import 'dart:ui';

import 'package:flutter/material.dart';

class ThemeStyle extends ThemeExtension<ThemeStyle> {
  final double shadowElevation;
  final Color shadowColor;
  final double shadowOpacity;
  final double shadowBlurRadius;
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final double shadowSpreadRadius;

  const ThemeStyle({
    this.shadowElevation = 1,
    this.shadowColor = Colors.black,
    this.shadowOpacity = 0.2,
    this.shadowBlurRadius = 1,
    this.borderRadius = 16,
    this.borderWidth = 0,
    this.borderColor,
    this.shadowSpreadRadius = 0,
  });

  @override
  ThemeExtension<ThemeStyle> copyWith({
    double? shadowElevation,
    Color? shadowColor,
    double? shadowOpacity,
    double? shadowBlurRadius,
    double? borderRadius,
    double? borderWidth,
    Color? borderColor,
    double? shadowSpreadRadius,
  }) {
    return ThemeStyle(
      shadowElevation: shadowElevation ?? this.shadowElevation,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
      shadowSpreadRadius: shadowSpreadRadius ?? this.shadowSpreadRadius,
    );
  }

  @override
  ThemeExtension<ThemeStyle> lerp(
      covariant ThemeExtension<ThemeStyle>? other, double t) {
    if (other is! ThemeStyle) return this;

    return ThemeStyle(
      shadowElevation: lerpDouble(shadowElevation, other.shadowElevation, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      shadowOpacity: lerpDouble(shadowOpacity, other.shadowOpacity, t)!,
      shadowBlurRadius:
          lerpDouble(shadowBlurRadius, other.shadowBlurRadius, t)!,
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t)!,
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t)!,
      borderColor:
          Color.lerp(borderColor ?? Colors.transparent, other.borderColor, t)!,
      shadowSpreadRadius:
          lerpDouble(shadowSpreadRadius, other.shadowSpreadRadius, t)!,
    );
  }
}
