import 'package:app/Pages/map.dart';
import 'package:app/Pages/sensors.dart';
import 'package:app/Pages/settings.dart';
import 'package:app/provider/appProvider.dart';
import 'package:app/routes/myMap.dart';
import 'package:app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:light_sensor/light_sensor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Appprovider()),
      ],
      child: App(),
    ),
  );
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  void _lightSensor(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    Provider.of<Appprovider>(context, listen: false).setLightLevel(prefs.getInt('lightLevelLimit') ?? 0);
    if(await LightSensor.hasSensor()) {
      LightSensor.luxStream().listen((int lux) {
        Provider.of<Appprovider>(context, listen: false).setCurrentLightLevel(lux);
      });
    } else {

    }
    
  }

  @override
  void initState(){
    super.initState();
    NotificationService.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
     _lightSensor(context);
    return MaterialApp(
      routes: {
        '/map': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
          return Mymap(position: args['position']);
        },
      },
      theme: Provider.of<Appprovider>(context).themes[Provider.of<Appprovider>(context).currentLightLevel >=
      Provider.of<Appprovider>(context).lightLevelLimit ? 1 : 0],
      debugShowCheckedModeBanner: false,
      home: MyApp()
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    int _currentPageIndex = 0;
    List<Widget> _pages = [
      Home(),
      Sensors(),
      Settings()
    ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Final Exam'),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _pages.elementAt(_currentPageIndex),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        currentIndex: _currentPageIndex,
        onTap: (value) => setState(() {
          _currentPageIndex = value;
        }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sensor_occupied_outlined),
            label: 'Sensors'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings'
          )
        ],
      ),
    );
  }
}