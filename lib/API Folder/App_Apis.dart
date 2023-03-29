

import 'dart:convert';

import '../Screens/watch.dart';
import 'package:http/http.dart' as http;

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

class  App_Apis{

  static Future<List<Movie>> fetchMovies() async {
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

  static dynamic fetchMovieDetails(int id) async {
    Uri url = Uri.parse(
        'https://api.themoviedb.org/3/movie/${id}?api_key=ba772d49635405ae1bcb76668e176747');
    final response = await http.get(url);
    if (response.statusCode == 200) {
        return json.decode(response.body);

      //print(_movieDetails);
    }
  }


  static Future<List> getMovieImages1(int movieId) async {
    List images1 = [];
    String apiKey = 'ba772d49635405ae1bcb76668e176747';
    Uri apiUrl = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/images?api_key=$apiKey');

    var response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['posters'];
      images1 = data.map((e) => e['file_path']).toList();
      return images1;
    } else {
      throw Exception('Failed to load images');
    }
  }



  static Future<String> fetchVideos(int movieId) async {
    List videos= [];
    Uri url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=ba772d49635405ae1bcb76668e176747&language=en-US');
        final response = await http.get(url);
    if (response.statusCode == 200) {
      print("Response pure is = $response.body");
      final data = json.decode(response.body)['results'];
      videos = data.map((video) => video as Map<String, dynamic>).toList();
      final urlid = "https://www.youtube.com/watch?v=${videos[0]['key']}";
       return urlid;
    } else {
      throw Exception('Failed to load videos');
    }
  }

  static Future<List> searchMovies(String query) async {
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


}