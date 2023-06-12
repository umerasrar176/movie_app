import 'package:flutter/material.dart';

class MediaLibrary extends StatefulWidget {
  const MediaLibrary({Key? key}) : super(key: key);

  @override
  State<MediaLibrary> createState() => _MediaLibraryState();
}

class _MediaLibraryState extends State<MediaLibrary> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Media Library'),
      ),
    );
  }
}
