import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenNetworkImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenNetworkImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: PhotoView(
        imageProvider: NetworkImage(Uri.encodeFull(imageUrl)),
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
      ),
    );
  }
}
