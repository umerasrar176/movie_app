import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class watchScreen extends StatefulWidget {
  const watchScreen({Key? key}) : super(key: key);

  @override
  State<watchScreen> createState() => _watchScreenState();
}

class Movie {
  final int id;
  final String title;
  final String posterPath;

  Movie({required this.id, required this.title, required this.posterPath});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
    );
  }
}

class _watchScreenState extends State<watchScreen> {
  Future<List<Movie>> fetchMovies() async {
    Uri url = Uri.parse(
        'https://api.themoviedb.org/3/movie/upcoming?api_key=ba772d49635405ae1bcb76668e176747');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List results = data['results'];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Movie>>(
      future: fetchMovies(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Movie>? data = snapshot.data;
          return ListView.builder(
            itemCount: data!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Column(
                    children: [
                      Stack(children: <Widget>[
                        Image.network(
                          height: 200,
                          width: double.infinity,
                          'https://image.tmdb.org/t/p/w500${data[index].posterPath}',
                          fit: BoxFit.fill,
                        ),
                        Container(
                          //color: Colors.black45,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data[index].title,
                              style: const TextStyle(
                                fontSize: 30.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ]),
                      //Text(data[index].title),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator());
      },
    ));
  }
}
