import 'package:clock_app/theme/color_scheme.dart';

import 'package:flutter/material.dart';

List<ColorSchemeData> defaultColorSchemes = [
  ColorSchemeData(
    name: 'Light',
    background: const Color.fromARGB(255, 248, 250, 250),
    onBackground: const Color.fromARGB(255, 46, 53, 68),
    card: Colors.white,
    onCard: const Color.fromARGB(255, 46, 53, 68),
    accent: Colors.cyan,
    onAccent: Colors.white,
    shadow: const Color.fromARGB(255, 0, 0, 0),
    outline: const Color.fromARGB(255, 46, 53, 68),
    error: const Color(0xFFFE4A49),
    onError: Colors.white,
    isDefault: true,
  ),
  ColorSchemeData(
    name: 'Dark',
    background: const Color.fromARGB(255, 53, 53, 53),
    onBackground: const Color.fromARGB(255, 245, 245, 245),
    card: const Color.fromARGB(255, 41, 41, 41),
    onCard: const Color.fromARGB(255, 233, 233, 233),
    accent: Colors.cyan,
    onAccent: Colors.white,
    shadow: const Color.fromARGB(255, 0, 0, 0),
    outline: const Color.fromARGB(255, 245, 245, 245),
    error: const Color(0xFFFE4A49),
    onError: Colors.white,
    isDefault: true,
  ),
  ColorSchemeData(
    name: 'Amoled',
    background: const Color.fromARGB(255, 0, 0, 0),
    onBackground: const Color.fromARGB(255, 245, 245, 245),
    card: const Color.fromARGB(255, 34, 34, 34),
    onCard: const Color.fromARGB(255, 233, 233, 233),
    accent: Colors.cyan,
    onAccent: Colors.white,
    shadow: const Color.fromARGB(255, 0, 0, 0),
    outline: const Color.fromARGB(255, 245, 245, 245),
    error: const Color(0xFFFE4A49),
    onError: Colors.white,
    isDefault: true,
  ),
];
