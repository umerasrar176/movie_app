import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class mediaLibrary extends StatefulWidget {
  const mediaLibrary({Key? key}) : super(key: key);

  @override
  State<mediaLibrary> createState() => _mediaLibraryState();
}

class _mediaLibraryState extends State<mediaLibrary> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Media Library'),
      ),
    );
  }
}
