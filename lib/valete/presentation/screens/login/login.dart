import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valet_app/valete/domain/usecases/login_use_case.dart';
import 'package:valet_app/valete/presentation/components/custom_bottun.dart';
import 'package:valet_app/valete/presentation/components/text/text_utils.dart';
import 'package:valet_app/valete/presentation/controllers/login/login_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/login/login_states.dart';
import 'package:valet_app/valete/presentation/resources/assets_manager.dart';
import 'package:valet_app/valete/presentation/resources/font_manager.dart';
import 'package:valet_app/valete/presentation/resources/values_manager.dart';

import '../../../../core/services/services_locator.dart';
import '../../components/custom_app_bar.dart';
import '../../components/custom_textFormField.dart';
import '../../controllers/login/login_events.dart';
import '../../resources/colors_manager.dart';
import '../../resources/strings_manager.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(

        backgroundColor: ColorManager.background,
        appBar: CustomAppBar(
          title: AppStrings.login,
          titleColor: ColorManager.white,
          leading: Icon(Icons.login_rounded, color: ColorManager.primary),
        ),
        body: BlocProvider(
          create: (context) => LoginBloc(sl<LoginUseCase>()),
          child: Stack(
            children: [
              Image.asset(AssetsManager.background,width: AppSizeWidth.sMaxWidth,height: AppSizeHeight.sMaxInfinite,fit: BoxFit.cover,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: AppPadding.p20),
                width: AppSizeWidth.sMaxWidth,
                height: AppSizeHeight.sMaxInfinite,
                child: SingleChildScrollView(
                  child: BlocBuilder<LoginBloc,LoginStates>(
                    builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: AppSizeHeight.s30),

                          Container(
                            height: AppSizeHeight.s65,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height: AppSizeHeight.s65,
                                    alignment: Alignment.center,
                                    child: Icon(Icons.garage_rounded,color: ColorManager.primary,size: AppSizeHeight.s60,)),
                                Container(
                                  height: AppSizeHeight.s65,
                                  alignment: Alignment.center,

                                  child: TextUtils(
                                    text: AppStrings.appName,
                                    fontSize: FontSize.s70,
                                    fontFamily: 'modak',
                                    color: ColorManager.primary,
                                  ),
                                ),
                              ],),
                          ),
                          SizedBox(height:  AppSizeHeight.s100,),
                          CustomTextFormField(
                            labelText: AppStrings.enterPhone,
                            keyboard: TextInputType.number,
                            onChanged: (value) =>
                                context.read<LoginBloc>().add(PhoneChanged(value)),
                            errorText: state.isPasswordValid ? null : 'Password too short',
                            icon:  Icon(Icons.phone_outlined,color: ColorManager.white,),
                          ),
                          SizedBox(height: AppSizeHeight.s20),
                          CustomTextFormField(
                            labelText: AppStrings.enterPassword,
                            obscureText: state.isPasswordObscured,
                            onChanged: (value) =>
                                context.read<LoginBloc>().add(PasswordChanged(value)),
                            errorText: state.isPhoneValid ? null : 'Invalid phone number',
                            icon:  Icon(Icons.lock_outline,color: ColorManager.white),
                            suffixIcon: IconButton(
                              icon: Icon(
                                state.isPasswordObscured
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: ColorManager.white,
                              ), onPressed: () {
                              context.read<LoginBloc>().add(TogglePasswordVisibility());

                            },
                          )),
                          SizedBox(height: AppSizeHeight.s100),
                          CustomButton(
                            onTap: state.isFormValid && !state.isSubmitting
                                ? () {
                              context.read<LoginBloc>().add(LoginSubmitted());
                            }
                                : null,
                            btnColor: ColorManager.primary,
                            shadowColor: ColorManager.white,
                            widget: state.isSubmitting
                                ? CircularProgressIndicator()
                                : TextUtils(
                              text: AppStrings.login,
                              fontWeight: FontWeightManager.bold,
                            ),
                          ),

                          // رسالة الخطأ إذا كانت موجودة
                          if (state.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                state.errorMessage!,
                                style: TextStyle(color: Colors.red),
                              ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
