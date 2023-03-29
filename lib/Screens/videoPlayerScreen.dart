import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../API Folder/App_Apis.dart';

class VideoPlayer extends StatefulWidget {
  final int id;
  const VideoPlayer({Key? key, required this.id}) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late Future<String> _keyFuture;


  @override
  void initState() {
    super.initState();
    _keyFuture = _handlefetchVideosRes(widget.id);
  }


  List<dynamic> videos = [];
  String url = "";
  String key = '';
  Future<String> _handlefetchVideosRes(int movieId) async {
    final url = await App_Apis.fetchVideos(widget.id);
    final key = YoutubePlayer.convertUrlToId(url)!;
    return key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: _keyFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final key = snapshot.data!;
              final controller = YoutubePlayerController(
                initialVideoId: key,
                flags: const YoutubePlayerFlags(
                  autoPlay: true,
                  mute: false,
                ),
              );
              return YoutubePlayer(controller: controller);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      )
    );
  }
}
