import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/Screens/movieDetailScreen.dart';

import '../API Folder/App_Apis.dart';

class watchScreen extends StatefulWidget {
  const watchScreen({Key? key}) : super(key: key);

  @override
  State<watchScreen> createState() => _watchScreenState();
}

class _watchScreenState extends State<watchScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Movie>>(
      future: App_Apis.fetchMovies(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Movie>? data = snapshot.data;
          return ListView.builder(
            itemCount: data!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MovieDetail(
                              id: data[index].id,
                            ))),
                child: Padding(
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
