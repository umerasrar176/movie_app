import 'package:flutter/material.dart';
import 'package:movie_app/Screens/movieDetailScreen.dart';

import '../API Folder/App_Apis.dart';

class WatchScreen extends StatefulWidget {
  const WatchScreen({Key? key}) : super(key: key);

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Movie>>(
      future: AppApis.fetchMovies(),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data[index].title,
                              style: const TextStyle(
                                fontSize: 30.0,
                                color: Colors.white,
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
