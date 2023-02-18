import 'package:flutter/material.dart';
import 'package:movie_app/media_library.dart';
import 'package:movie_app/watch.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
      home: MyHomePage(
        title: 'Movie App',
      ),
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

  bool _showSearchBar = false;
  List _movies = [];

  Future<List> _searchMovies(String query) async {
    String apiKey = 'ba772d49635405ae1bcb76668e176747';
    String url =
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      //print(data['results']);
      return data['results'];
    } else {
      throw Exception('Failed to load search results');
    }
  }

  Widget _buildMovieList() {
    return ListView.builder(
      itemCount: _movies.length,
      itemBuilder: (BuildContext context, int index) {
        var movie = _movies[index];
        return ListTile(
          leading: movie['poster_path'] == null
              ? Image.network('https://static.thenounproject.com/png/3674270-200.png' ,
            height: 150,
            width: 120,
            fit: BoxFit.fill,)
              : Image.network(
            height: 150,
            width: 120,
            'https://image.tmdb.org/t/p/w92${movie['poster_path']}',
            fit: BoxFit.fill,
          ),
          title: Text(movie['title']),
          subtitle: Text(movie['release_date'].toString()),
          trailing: const Icon(Icons.more_horiz),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.white,
        title: !_showSearchBar
            ? Text(
                _pageTitles[_selectedIndex],
                style: const TextStyle(
                  color: Colors.black,
                ),
              )
            : TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search , color: Colors.black,),
                  hintText: 'TV shows, movies and more',
                ),
                onChanged: (value) async {
                  var results = await _searchMovies(value);
                  setState(() {
                    _movies = results;
                  });
                },
              ),
        actions: [
          IconButton(
            icon: _showSearchBar
                ? const Icon(Icons.close, color: Colors.black)
                : const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              setState(() {
                _showSearchBar = !_showSearchBar;
                _movies = [];
              });
            },
          ),
        ],
      ),

      /*appBar: AppBar(
            elevation: 1.0,
            backgroundColor: Colors.white,
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                  },
                  icon: const Icon(Icons.search), color: Colors.black,),
            ],
            title: Text(_pageTitles[_selectedIndex], style: const TextStyle(
              color: Colors.black,
            ),
          )),*/
      body: !_showSearchBar
          ? pages[_selectedIndex]
          : _movies.isNotEmpty
              ? _buildMovieList()
              : Container(),
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
