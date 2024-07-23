import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {

  bool light = true;

  ThemeProvider() {
    _getTheme();
  }

  _getTheme() async{
    final prefs = await SharedPreferences.getInstance();
    toggleTheme(prefs.getBool('theme') ?? true);
  }

  toggleTheme(bool theme) async{
    light = theme;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('theme', light);
    notifyListeners();
  }

}