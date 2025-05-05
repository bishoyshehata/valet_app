import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:valet_app/valete/presentation/screens/login/login.dart';
import '../../components/custom_app_bar.dart';
import '../../components/custom_bottun.dart';
import '../../components/text/text_utils.dart';
import '../../resources/assets_manager.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';

class OnBoardignScreen extends StatelessWidget {
  const OnBoardignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                AssetsManager.onBoarding,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.only(top: AppPadding.p50),
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Column(
                          spacing: AppSizeHeight.s10,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Image.asset(AssetsManager.onBoarding),
                            TextUtils(
                              text: AppStrings.appName,
                              fontSize: FontSize.s70,
                              fontFamily: 'modak',
                              color: ColorManager.primary,


                            ),
                            TextUtils(
                              text: AppStrings.appProposal,
                              fontSize: FontSize.s17,
                              overFlow: TextOverflow.ellipsis,
                              noOfLines: 2,
                              fontFamily: 'cairo',
                              alignnment: TextAlign.center,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.white,
                            ),
                          ],
                        )),
                    Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: CustomButton(
                          widget: TextUtils(text: AppStrings.login, color: ColorManager.primary,fontWeight: FontWeightManager.bold,),
                          btnColor: ColorManager.background,
                          elevation: 3,

                          onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                          }, shadowColor: ColorManager.white,
                        ))
                  ]),
            ),
          ],
        ));
  }
}
