import 'package:app/main.dart';
import 'package:app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Appprovider extends ChangeNotifier {

  int lightLevelLimit = 0;
  int currentLightLevel = 0; 
  final List<ThemeData> themes = [
    ThemeData (
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        background: Color(0xFFfef7ff),
        primary: Colors.blue,
        secondary: Colors.grey,
        tertiary: Colors.white,
      )
    ),
    ThemeData (
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        background: Colors.black,
        primary: const Color.fromARGB(255, 61, 61, 61),
        secondary: const Color.fromARGB(255, 182, 182, 182),
        tertiary: Colors.grey,
      ),
    )
  ];


  void setCurrentLightLevel(int lux) async {
    currentLightLevel = lux;
    if (currentLightLevel >= lightLevelLimit) {
      NotificationService.showBigTextNotification(
          title: 'Ambiet Light Sensor',
          body: 'Light Change Detected!',
          fln: flutterLocalNotificationsPlugin
      );
    }
    notifyListeners();
  }

  void setLightLevel(int lux) async {
    final prefs = await SharedPreferences.getInstance();
    lightLevelLimit = lux;
    prefs.setInt('lightLevelLimit', lightLevelLimit);
    notifyListeners();
  }

}