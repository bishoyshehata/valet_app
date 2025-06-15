import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../components/custom_app_bar.dart';
import '../../resources/colors_manager.dart';
import '../../resources/values_manager.dart';

class FullScreenNetworkImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenNetworkImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return Directionality(
      textDirection: locale.languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.black,
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
        body: PhotoView(
          imageProvider: NetworkImage(Uri.encodeFull(imageUrl)),
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
