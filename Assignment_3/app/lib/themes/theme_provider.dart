import 'package:app/themes/dark_theme.dart';
import 'package:app/themes/light_theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
  }

  void toggleTheme(bool isDark) {
    if (isDark) {
      themeData = darkTheme;
    } else {
      themeData = lightTheme;
    }
    notifyListeners();
  }
}