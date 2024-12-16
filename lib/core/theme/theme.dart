import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFFFFFFF),
    primary: Color(0xFFe5e5e5),
    secondary: Color(0xFFECEFF1),
    tertiary: Color(0xFFCFD8DC),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF13171a),
    primary: Color(0xFF595c5e),
    secondary: Color(0xFF898b8c),
    tertiary: Color(0xFFb8b9ba),
  ),
);
