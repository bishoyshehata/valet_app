import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';

import '../../components/custom_app_bar.dart';
import '../../resources/colors_manager.dart';
import '../../resources/values_manager.dart';

class FullScreenImage extends StatelessWidget {
  final File imageFile;

  const FullScreenImage({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroundColor: Colors.black,
        leading: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(AppMargin.m4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizeHeight.s50),
            color: ColorManager.grey,
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: ColorManager.white),
          ),
        ), title: '',
      ),
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: PhotoView(
            imageProvider: FileImage(imageFile,),
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
