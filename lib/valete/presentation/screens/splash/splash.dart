import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/valete/presentation/controllers/re_auth/re_auth_bloc.dart';
import 'package:valet_app/valete/presentation/screens/valet_home/valet_main.dart';
import '../../../../core/services/services_locator.dart';
import '../../controllers/re_auth/re_auth_events.dart';
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

    await Future.delayed(const Duration(seconds: 3));
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    final requiresReAuth = prefs.getBool('requiresReAuth') ?? false;
    if (requiresReAuth) {
      sl<ReAuthBloc>().add(ShowPasswordPromptEvent());
    }
    if (accessToken != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OnBoardignScreen()),
      );
    }
  }
}
