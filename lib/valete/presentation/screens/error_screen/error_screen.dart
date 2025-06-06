import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../components/custom_bottun.dart';
import '../../components/text/text_utils.dart';
import '../../resources/assets_manager.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';
import '../login/login.dart';

Widget buildErrorBody(BuildContext context, int? statusCode) {
  switch (statusCode) {
    case 400:
      return const Center(
        child: Text(
          "عذراً يوجد مشكلة بالبيانات",
          style: TextStyle(color: Colors.red, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      );
    case 401:
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(LottieManager.noCars),
              SizedBox(height: AppSizeHeight.s20),
              TextUtils(
                text: "عذراً لقد إنتهت الجلسة برجاء تسجيل الدخول مرة أخرى",
                color: ColorManager.white,
                fontSize: FontSize.s13,
                noOfLines: 2,
                overFlow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSizeHeight.s30),
              CustomButton(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                  );
                },
                btnColor: ColorManager.primary,
                widget: TextUtils(
                  text: 'إعادة التسجيل',
                  color: ColorManager.background,
                  fontWeight: FontWeightManager.bold,
                ),
              ),
            ],
          ),
        ),
      );
    case 500:
      return const Center(
        child: Text(
          "خطأ في الخادم، حاول لاحقاً",
          style: TextStyle(color: Colors.red, fontSize: 18),
          textAlign: TextAlign.center,
        ),
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
