import 'package:final_project/core/theme/theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  ToggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
