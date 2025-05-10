import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';

class FullScreenImage extends StatelessWidget {
  final File imageFile;

  const FullScreenImage({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: PhotoView(
            imageProvider: FileImage(imageFile),
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          ),
        ),
      ),
    );
  }
}
