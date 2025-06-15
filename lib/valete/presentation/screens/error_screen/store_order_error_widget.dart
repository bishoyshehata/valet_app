import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:valet_app/valete/presentation/resources/strings_manager.dart';

import '../../../../core/l10n/app_locale.dart';
import '../../components/custom_bottun.dart';
import '../../components/text/text_utils.dart';
import '../../resources/assets_manager.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';
import '../login/login.dart';

Widget buildStoreOrderErrorWidget(BuildContext context, int? statusCode ,String? statusMessage) {
  switch (statusCode) {
    case 0 :return  Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(LottieManager.noCars),
            SizedBox(height: AppSizeHeight.s20),
            TextUtils(
              text: statusMessage!,
              color: ColorManager.white,
              fontSize: FontSize.s13,
              noOfLines: 2,
              overFlow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );

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
      return  Center(
        child: Text(
          AppLocalizations.of(context)!.unexpectedErrorOccurred,
          style: TextStyle(color: Colors.red, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );
  }
}
