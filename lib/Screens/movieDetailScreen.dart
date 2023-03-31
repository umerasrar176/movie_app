import 'package:flutter/material.dart';
import 'package:movie_app/Screens/seatMappingUI.dart';
import 'package:movie_app/Screens/videoPlayerScreen.dart';

import '../API Folder/App_Apis.dart';

class MovieDetail extends StatefulWidget {
  final int id;
  const MovieDetail({Key? key, required this.id}) : super(key: key);

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  late Map<String, dynamic> _movieDetails = {};
  bool _isLoading = true;
  List images1 = [];


  //handling movie details response
  void _handleMovieDetailsRes() async {
    _movieDetails = await App_Apis.fetchMovieDetails(widget.id);
    if(_movieDetails.isNotEmpty) {
      setState(() {
        _movieDetails = _movieDetails;
        _isLoading = false;
      });
    }
  }

  //handling movie images response
  void _handleMovieImagesRes(int movieId) async {
    images1 = await App_Apis.getMovieImages1(widget.id);
  }

  @override
  void initState() {
    super.initState();
    _handleMovieDetailsRes();
    _handleMovieImagesRes(widget.id);
  }

  String _buildGenresString() {
    String genres = '';
    for (var i = 0; i < _movieDetails['genres'].length; i++) {
      genres += _movieDetails['genres'][i]['name'];
      if (i < _movieDetails['genres'].length - 1) {
        genres += ', ';
      }
    }
    return genres;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 500.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://image.tmdb.org/t/p/w500${images1[0]}"),
                                  fit: BoxFit.fill)),
                        ),
                        Positioned(
                          top: 0.0,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  const SizedBox(width: 10.0),
                                  const Text(
                                    'Watch',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 280.0,
                          left: 10.0,
                          right: 10.0,
                          child: Container(
                            //color: Colors.transparent,
                            height: 200.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.transparent,
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.lightBlueAccent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          )),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    seatMapingScreen(
                                                      moviename: _movieDetails[
                                                          'title'],
                                                      realeasdate:
                                                          _movieDetails[
                                                              'release_date'],
                                                    )));
                                      },
                                      child: const Text(
                                        'Get Tickets',
                                        style: TextStyle(fontSize: 30.0),
                                      ),
                                      /*color: Colors.grey,
                                  textColor: Colors.white,*/
                                    ),
                                  ),
                                )),
                                const SizedBox(width: 10.0),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.transparent,
                                          side: const BorderSide(
                                              color: Colors.blue,
                                              width: 2,
                                              style: BorderStyle.solid),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          )),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VideoPlayer(
                                                      id: widget.id,
                                                    )));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.play_arrow,
                                            color: Colors.white,
                                            size: 30.0,
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            'Watch Trailer',
                                            style: TextStyle(
                                                fontSize: 30.0,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      /* color: Colors.blue,
                                    textColor: Colors.white,*/
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Genres',
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        _buildGenresString(),
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                      width: double.infinity,
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Movie Overview',
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        _movieDetails['overview'],
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
