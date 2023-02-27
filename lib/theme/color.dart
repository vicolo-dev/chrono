import 'package:flutter/material.dart';

// class ColorTheme {
//   static Color textColor = const Color.fromARGB(255, 46, 53, 68);
//   static Color textColorSecondary = const Color.fromARGB(255, 81, 91, 114);
//   static Color textColorTertiary = const Color.fromARGB(255, 144, 154, 179);
// }

ColorScheme lightColorScheme = const ColorScheme(
  background: Color.fromARGB(255, 250, 250, 250),
  error: Color.fromARGB(255, 194, 64, 64),
  secondary: Colors.cyan,
  brightness: Brightness.light,
  onError: Colors.white,
  onPrimary: Colors.white,
  surface: Colors.white,
  primary: Colors.cyan,
  onSurface: Color.fromARGB(255, 46, 53, 68),
  onSecondary: Colors.white,
  onBackground: Color.fromARGB(255, 46, 53, 68),
);

ColorScheme darkColorScheme = const ColorScheme(
  background: Color.fromARGB(255, 53, 53, 53),
  error: Color.fromARGB(255, 194, 64, 64),
  secondary: Colors.cyan,
  brightness: Brightness.light,
  onError: Colors.white,
  onPrimary: Colors.white,
  surface: Color.fromARGB(255, 41, 41, 41),
  primary: Colors.cyan,
  onSurface: Color.fromARGB(255, 233, 233, 233),
  onSecondary: Colors.white,
  onBackground: Color.fromARGB(255, 245, 245, 245),
);

ColorScheme amoledColorScheme = const ColorScheme(
  background: Color.fromARGB(255, 0, 0, 0),
  error: Color.fromARGB(255, 194, 64, 64),
  secondary: Colors.cyan,
  brightness: Brightness.light,
  onError: Colors.white,
  onPrimary: Colors.white,
  surface: Color.fromARGB(255, 34, 34, 34),
  primary: Colors.cyan,
  onSurface: Color.fromARGB(255, 233, 233, 233),
  onSecondary: Colors.white,
  onBackground: Color.fromARGB(255, 245, 245, 245),
  inverseSurface: Color.fromRGBO(0, 0, 0, 0.5),
);
