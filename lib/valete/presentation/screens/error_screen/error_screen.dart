import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../components/custom_bottun.dart';
import '../../components/text/text_utils.dart';
import '../../resources/assets_manager.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';
import '../login/login.dart';

class ErrorScreen extends StatelessWidget {
  final int? statusCode; // لازم final في StatelessWidget

  const ErrorScreen({super.key, required this.statusCode});

  @override
  Widget build(BuildContext context) {
    return switch (statusCode) {
      400 => _buildErrorMessage("عذراً يوجد مشكلة بالبيانات"),
      401 => _buildSessionExpired(context),
      500 => _buildErrorMessage("خطأ في الخادم، حاول لاحقاً"),
      _ => _buildErrorMessage("حدث خطأ غير متوقع"),
    };
  }

  Widget _buildErrorMessage(String message) {
    return Scaffold(
      body: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.red, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSessionExpired(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Lottie.asset(LottieManager.noCars)),
            TextUtils(
              text:
              "عذراً بقد إنتهت الجلسة برجء تسجيل الدخول مرة أخرى",
              color: ColorManager.white,
              fontSize: FontSize.s13,
              noOfLines: 2,
              overFlow: TextOverflow.ellipsis,
            ),
            SizedBox(height: AppSizeHeight.s30),
            CustomButton(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
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
  }
}
