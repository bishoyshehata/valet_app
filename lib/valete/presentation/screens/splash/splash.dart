import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/valete/presentation/screens/login/login.dart';
import 'package:valet_app/valete/presentation/screens/valet_home/valet_main.dart';
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
      body: Center(child: Lottie.asset(LottieManager.carTransparent)),
    );
  }

  // logic
  Future<void> _navigateUser() async {

    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }
}
