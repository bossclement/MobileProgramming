import 'package:app/pages/routes/book_content.dart';
import 'package:app/pages/home.dart';
import 'package:app/pages/routes/book_details.dart';
import 'package:app/pages/settings.dart';
import 'package:app/providers/book_provider.dart';
import 'package:app/providers/themeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => BookProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {

  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final List<ThemeData> themes = [
    ThemeData (
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        background: Colors.grey[200],
        primary: Colors.deepPurple,
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
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/bookContent': (context) => BookContent(pageTitle: 'Add a new book'),
        '/bookDetails': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
          return BookDetails(book: args['book']);
        },
      },
      theme: themes[Provider.of<ThemeProvider>(context).light == true ? 0 : 1],
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _tabIndex = 0;

  final List<Widget> _pages = [
      Home(),
      Settings()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Mybook Library',
            style: TextStyle(
              color: Colors.white
            ),
          )),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings
            ),
            label: 'Settings',
          )
        ],
        onTap: (value) => setState(() {
          _tabIndex = value;
        }),
        currentIndex: _tabIndex,
      ),
      floatingActionButton: _tabIndex == 0 ?
      FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/bookContent');
        },
      ) : null,
      body: _pages.elementAt(_tabIndex),
    );
  }
}