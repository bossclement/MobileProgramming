import 'dart:io';

import 'package:app/components/bottomSheet.dart';
import 'package:app/pages/auth_page.dart';
import 'package:app/pages/calculator.dart';
import 'package:app/pages/reg_page.dart';
import 'package:app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:app/l10n/l10n.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    )
  );
}

extension LocalizationExtension on BuildContext {
  AppLocalizations get loc {
    return AppLocalizations.of(this)!;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: L10n.all,
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _isSwitched = false;
  File? _selectedImage;

  static final List<Widget> _widgetOptions = <Widget>[
    AuthPage(),
    RegPage(),
    CalculatorScreen(),
  ];

  var _subscription;

  @override
  void initState() {
    super.initState();
    Connectivity _connectivity = Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(_showConnectivityToast);
    defaults();
  }

  Future<void> defaults() async{
    _isSwitched = await getIsSwitched();
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme(_isSwitched);
  }

  Future<void> setIsSwitched() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkTheme', _isSwitched);
  }

  Future<bool> getIsSwitched() async {
    final prefs = await SharedPreferences.getInstance();
    bool? darkTheme = await prefs.getBool('darkTheme');
    return darkTheme ?? false;
  }

  void _showConnectivityToast(List<ConnectivityResult> results) {
    String message;
    Color bgColor;

    switch (results[0]) {
      case ConnectivityResult.wifi:
        message = "Connected to WiFi";
        bgColor = Colors.green;
        break;
      case ConnectivityResult.mobile:
        message = "Connected to Mobile Network";
        bgColor = Colors.blue;
        break;
      case ConnectivityResult.none:
        message = "No Internet Connection";
        bgColor = Colors.red;
        break;
      default:
        message = "Network status unknown";
        bgColor = Colors.orange;
    }

    Fluttertoast.showToast(
      msg: message,
      backgroundColor: bgColor,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future selectImage() async{
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = image != null ? File(image.path) : _selectedImage;
    });
  }

  Future takePhoto() async{
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _selectedImage = image != null ? File(image.path) : _selectedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: context.loc.signIn,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration),
            label: context.loc.signUp,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: context.loc.calc,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 290,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            _selectedImage != null?
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: FileImage(_selectedImage!),
                            ) : 
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey[200],
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey[800],
                              ),
                            ),
                            Positioned(
                              bottom: -10,
                              right: 1,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context) => MyBottomSheet(gallery: selectImage, photo: takePhoto)),
                                  );
                                },
                                icon: Icon(
                                  Icons.add_a_photo,
                                  color: Theme.of(context).colorScheme.tertiary,
                                  size: 25,
                                ),
                              )
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'John Doe',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          'JohnDoe@gmail.com',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                
              ),
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: Text(context.loc.signIn),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.app_registration),
              title: Text(context.loc.signUp),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 1;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text(context.loc.calc),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  context.loc.dark,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Switch(
                  value: _isSwitched,
                  onChanged: (value) {
                    setState(() {
                      _isSwitched = value;
                    });
                    setIsSwitched();
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme(_isSwitched);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
