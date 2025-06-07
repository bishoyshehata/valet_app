import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/valete/presentation/screens/login/login.dart';
import 'package:valet_app/valete/presentation/screens/order_details/order_details.dart';
import 'package:valet_app/valete/presentation/screens/valet_home/valet_main.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/colors_manager.dart';
import '../../onboarding/onboarding_screen.dart';

class LoadingScreen extends StatefulWidget {

  int? spotId;
  String? garageName;
   LoadingScreen({super.key,required this.spotId , required this.garageName});

  @override
  State<LoadingScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<LoadingScreen> {
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
      body: Center(child: Lottie.asset(LottieManager.carLoading)),
    );
  }

  // logic
  Future<void> _navigateUser() async {

    await Future.delayed(const Duration(milliseconds: 1500));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrderDetails(spotId: widget.spotId!, garageName: widget.garageName!)),
      );

  }
}
