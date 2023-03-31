import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

  static Future<bool> checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  static Future<List<Movie>> fetchMovies() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isConnected = await checkConnectivity();
    String url = "https://api.themoviedb.org/3/movie/upcoming?api_key=ba772d49635405ae1bcb76668e176747";
    Uri url1 = Uri.parse(url);

    if (isConnected) {
      if(kDebugMode){
        print('Connected to internet');
      }
      final response = await http.get(url1);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List results = data['results'];
        await prefs.setString(url, json.encode(results));
        return results.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } else {
      if (prefs.containsKey(url)) {
        final String? savedData = prefs.getString(url);
        if(kDebugMode){
          print('No internet connection, loading saved data');
        }
        final List<dynamic> results = json.decode(savedData!);
        return results.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('No internet connection and no saved data found');
      }
    }

  }

  /*static dynamic fetchMovieDetails(int id) async {
    Uri url = Uri.parse(
        'https://api.themoviedb.org/3/movie/${id}?api_key=ba772d49635405ae1bcb76668e176747');
    final response = await http.get(url);
    if (response.statusCode == 200) {
        return json.decode(response.body);
    }
  }*/

  static Future<dynamic> fetchMovieDetails(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isConnected = await checkConnectivity();
    String Url ='https://api.themoviedb.org/3/movie/$id?api_key=ba772d49635405ae1bcb76668e176747';


    if (isConnected) {
      Uri url = Uri.parse(Url);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        prefs.setString('$id-detail', response.body);
        return data;
      }
    } else {
      final String? storedData = prefs.getString('$id-detail');
      if (storedData != null) {
        if(kDebugMode){
          print('No internet connection, loading saved single movie data data');
        }
        return json.decode(storedData);
      }
    }
  }


  /*static Future<List> getMovieImages1(int movieId) async {
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
  }*/

  static Future<List<dynamic>> getMovieImages1(int movieId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isConnected = await checkConnectivity();

    List<dynamic> images1 = [];

    if (isConnected) {
      String apiKey = 'ba772d49635405ae1bcb76668e176747';
      Uri apiUrl = Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/images?api_key=$apiKey');

      var response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['posters'];
        images1 = data.map((e) => e['file_path']).toList();
        await prefs.setStringList('movieImages$movieId', images1.cast<String>());
      } else {
        throw Exception('Failed to load images');
      }
    } else {
      final response = prefs.getStringList('movieImages$movieId');
      if (response != null) {
        images1 = response;
      }
    }
    return images1;
  }



  /*static Future<List> getMovieImages1(int movieId) async {
    List images1 = [];
    String apiKey = 'ba772d49635405ae1bcb76668e176747';
    Uri apiUrl = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/images?api_key=$apiKey');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isConnected = await checkConnectivity();

    if (isConnected) {
      var response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['posters'];
        images1 = data.map((e) => e['file_path']).toList();
        prefs.setStringList('$movieId-images', images1);
        return images1;
      } else {
        throw Exception('Failed to load images');
      }
    } else {
      var imagesFromPrefs = prefs.getStringList('$movieId-images');
      if (imagesFromPrefs != null && imagesFromPrefs.isNotEmpty) {
        return imagesFromPrefs;
      } else {
        throw Exception('No saved images');
      }
    }
  }*/


  /*static Future<String> fetchVideos(int movieId) async {
    List videos= [];
    Uri url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=ba772d49635405ae1bcb76668e176747&language=en-US');
        final response = await http.get(url);
    if (response.statusCode == 200) {
      print("Response pure is = $response.body");
      final data = json.decode(response.body)['results'];
      videos = data.map((video) => video as Map<String, dynamic>).toList();
      final url = "https://www.youtube.com/watch?v=${videos[0]['key']}";
       return url;
    } else {
      throw Exception('Failed to load videos');
    }
  }*/

  static Future<String> fetchVideos(int movieId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isConnected = await checkConnectivity();

    if (isConnected) {
      Uri url = Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=ba772d49635405ae1bcb76668e176747&language=en-US');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print("Response pure is = $response.body");
        final data = json.decode(response.body)['results'];
        List videos = data.map((video) => video as Map<String, dynamic>).toList();
        final url = "https://www.youtube.com/watch?v=${videos[0]['key']}";
        await prefs.setString('videos_$movieId', json.encode(videos));
        await prefs.setString('video_url_$movieId', url);
        return url;
      } else {
        throw Exception('Failed to load videos');
      }
    } else {
      final videosJson = prefs.getString('videos_$movieId');
      final url = prefs.getString('video_url_$movieId');
      if (videosJson != null && url != null) {
        List videos = json.decode(videosJson).map((video) => video as Map<String, dynamic>).toList();
        return url;
      } else {
        throw Exception('No videos found');
      }
    }
  }

  /*static Future<List> searchMovies(String query) async {
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
  }*/

  static Future<List> searchMovies(String query) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isConnected = await checkConnectivity();
    final String key = 'searchResults_$query';

    if (isConnected) {
      String apiKey = 'ba772d49635405ae1bcb76668e176747';
      String url =
          'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query';

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['results'];
        await prefs.setString(key, json.encode(data));
        return data;
      } else {
        throw Exception('Failed to load search results');
      }
    } else {
      final String? savedData = prefs.getString(key);
      if (savedData != null) {
        List<dynamic> data = json.decode(savedData);
        return data;
      } else {
        throw Exception('No saved search results');
      }
    }
  }
}