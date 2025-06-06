import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../components/custom_bottun.dart';
import '../../components/text/text_utils.dart';
import '../../resources/assets_manager.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';
import '../login/login.dart';

Widget buildStoreOrderErrorWidget(BuildContext context, int? statusCode ,String? statusMessage) {
  switch (statusCode) {
    case 400:
      return TextUtils(
  text: statusMessage!,
  color: ColorManager.white,
  fontSize: FontSize.s13,
  noOfLines: 2,
  overFlow: TextOverflow.ellipsis,
  );
    case 404:
      return  TextUtils(
        text: statusMessage!,
        color: ColorManager.white,
        fontSize: FontSize.s13,
        noOfLines: 2,
        overFlow: TextOverflow.ellipsis,
      );
    case 401:
      return TextUtils(
        text: statusMessage!,
        color: ColorManager.white,
        fontSize: FontSize.s13,
        noOfLines: 2,
        overFlow: TextOverflow.ellipsis,
      );
    case 500:
      return TextUtils(
        text: statusMessage!,
        color: ColorManager.white,
        fontSize: FontSize.s13,
        noOfLines: 2,
        overFlow: TextOverflow.ellipsis,
      );
    default:
      return const Center(
        child: Text(
          "حدث خطأ غير متوقع",
          style: TextStyle(color: Colors.red, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );
  }
}
