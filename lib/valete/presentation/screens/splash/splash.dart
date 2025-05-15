import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../resources/assets_manager.dart';
import '../../resources/colors_manager.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateUser();
  }
  @override
  Widget build(BuildContext context) {
    // the UI
    return Scaffold(
      backgroundColor: ColorManager.background,
      body: Center(
        child: Lottie.asset(LottieManager.carTransparent),
      ),
    );
  }

  // logic
  Future<void> _navigateUser() async {
    await Future.delayed(const Duration(seconds: 5));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OnBoardignScreen() ,));

    // final box = await Hive.openBox('myBox');
    // final token = box.get('auth_token');
    // final role = box.get('role');
    // if (token != null) {
    //   if (role == 'Instructor') {
    //     Get.offAllNamed(AppRoutes.instructorHome);
    //   } else if (role == 'Student') {
    //     Get.offAllNamed(AppRoutes.studentHome);
    //   } else {
    //     // Default or unknown role
    //     Get.offAllNamed(AppRoutes.onBoarding);
    //   }
    // } else {
    //   Get.offAllNamed(AppRoutes.onBoarding);
    // }
  }

}
