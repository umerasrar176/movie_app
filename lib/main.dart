import 'package:flutter/material.dart';
import 'package:movie_app/media_library.dart';
import 'package:movie_app/watch.dart';

import 'HomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(title: 'Movie App',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isDarkMode = false;
  int _selectedIndex = 0;

  static final List<String> _pageTitles = [
    'Dashboard',
    'watch',
    'Media Library',
    'More',
  ];

  final List<Widget> pages = [
    const HomeScreen(),
    const watchScreen(),
    const mediaLibrary()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                  },
                  icon: const Icon(Icons.search),)
            ],
            title: Text(_pageTitles[_selectedIndex]),
          ),
          body: pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 50.0,
            backgroundColor: Colors.black87,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.play_circle),
                label: 'watch',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music),
                label: 'Media Library',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                label: 'More',
              ),
            ],
            currentIndex: _selectedIndex,
            //selectedItemColor: Colors.blue,
            onTap: (int index) {
              if (mounted) {
                setState(() {
                  _selectedIndex = index;
                });
              }
            },
          ),
        );
  }
}
