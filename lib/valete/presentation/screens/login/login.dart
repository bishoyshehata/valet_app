import 'package:flutter/material.dart';
import 'package:valet_app/valete/presentation/components/custom_bottun.dart';
import 'package:valet_app/valete/presentation/components/text/text_utils.dart';
import 'package:valet_app/valete/presentation/resources/assets_manager.dart';
import 'package:valet_app/valete/presentation/resources/values_manager.dart';

import '../../components/custom_app_bar.dart';
import '../../components/custom_textFormField.dart';
import '../../resources/colors_manager.dart';
import '../../resources/strings_manager.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: CustomAppBar(
        title: AppStrings.login,
        titleColor: ColorManager.white,
        leading: Icon(Icons.login_rounded, color: ColorManager.primary),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: AppPadding.p20),
        width: AppSizeWidth.sMaxWidth,
        height: AppSizeHeight.sMaxInfinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: AppSizeHeight.s50),

              Image.asset(AssetsManager.login),
              SizedBox(height:  AppSizeHeight.s100,),
              CustomTextFormField(
                labelText: AppStrings.enterPhone,
                keyboard: TextInputType.number,
                // validator: AuthController.to.validatePhone,
                // controller: AuthController.to.phoneController,
                icon:  Icon(Icons.phone_outlined,color: ColorManager.white,),
              ),
               SizedBox(height: AppSizeHeight.s20),
              CustomTextFormField(
                labelText: AppStrings.enterPassword,
          
                // validator: AuthController.to.validatePassword,
                // controller: AuthController.to.passwordController,
                icon:  Icon(Icons.lock_outline,color: ColorManager.white),
                // obscureText: !AuthController.to.isPasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    // AuthController.to.isPasswordVisible.value
                    //     ? Icons.visibility
                    //     :
                    Icons.visibility_off,
                    color: ColorManager.white
                  ),
                  onPressed: () {
                    // AuthController.to.togglePasswordVisibility();
                  },
                ),
              ),
              SizedBox(height: AppSizeHeight.s50),
              CustomButton(
                onTap: () {},
                btnColor: ColorManager.primary,
                shadowColor: ColorManager.white,
                widget: TextUtils(text: AppStrings.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
