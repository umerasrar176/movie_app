import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VideoPlayer extends StatefulWidget {
  final int id;
  const VideoPlayer({Key? key, required this.id}) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {

  late VlcPlayerController _videoPlayerController;
  @override
  void initState() {
    _videoPlayerController = VlcPlayerController.network(
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      hwAcc: HwAcc.full,
      //autoPlay: true,
      options: VlcPlayerOptions(),
    );
    super.initState();
    fetchVideos(widget.id);
    print(widget.id);
  }
  late List<dynamic> videos;

  Future<void> fetchVideos(int movieId) async {
    Uri url = Uri.parse('https://api.themoviedb.org/3/movie/$movieId/videos?api_key=ba772d49635405ae1bcb76668e176747');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['results'];
      videos = data.map((video) => video as Map<String, dynamic>).toList();
      print(videos);
      setState(() {
        videos = videos;
      });
    } else {
      throw Exception('Failed to load videos');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Expanded(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: VlcPlayer(
                  controller: _videoPlayerController,
                  aspectRatio: 16 / 9,
                  placeholder: const Center(child: CircularProgressIndicator()),
                ),
                /*BetterPlayer(
              key: _playerKey,
              controller: _controller,
            ),*/
              ))
        ],
      ),
    );
  }
}
