import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:valet_app/core/utils/enums.dart';
import 'package:valet_app/valete/domain/usecases/login_use_case.dart';
import 'package:valet_app/valete/presentation/components/custom_bottun.dart';
import 'package:valet_app/valete/presentation/components/text/text_utils.dart';
import 'package:valet_app/valete/presentation/controllers/login/login_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/login/login_states.dart';
import 'package:valet_app/valete/presentation/resources/assets_manager.dart';
import 'package:valet_app/valete/presentation/resources/font_manager.dart';
import 'package:valet_app/valete/presentation/resources/values_manager.dart';
import 'package:valet_app/valete/presentation/screens/valet_home/valet_main.dart';
import '../../../../core/services/services_locator.dart';
import '../../components/custom_app_bar.dart';
import '../../components/custom_textFormField.dart';
import '../../components/login/custom_phone.dart';
import '../../controllers/login/login_events.dart';
import '../../resources/colors_manager.dart';
import '../../resources/strings_manager.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: ColorManager.background,
        appBar: CustomAppBar(
          title: AppStrings.login,
          titleColor: ColorManager.white,
        ),
        body: BlocProvider<LoginBloc>(
          create: (context) {
            return LoginBloc(sl<LoginUseCase>());
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: AppPadding.p20),
            width: AppSizeWidth.sMaxWidth,
            height: AppSizeHeight.sMaxInfinite,
            child: SingleChildScrollView(
              child: BlocConsumer<LoginBloc, LoginStates>(
                listener: (context, state) {
                  switch (state.loginStatus) {
                    case LoginStatus.error:
                      if (state.errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errorMessage!),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      break;
                    case LoginStatus.success:
                      if (state.data != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()),
                        );
                      }
                      break;
                    default:
                      break;
                  }
                },
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: AppSizeHeight.s30),
                        TextUtils(
                          text: AppStrings.appName,
                          fontSize: FontSize.s70,
                          fontFamily: 'modak',
                          color: ColorManager.primary,
                        ),
                        SizedBox(height: AppSizeHeight.s100),

                        // Phone field
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, AppPadding.p12, AppPadding.p5),
                          child: TextUtils(text: "إدخل رقم الهاتف"),
                          alignment: AlignmentDirectional.centerEnd,

                        ),

                        CustomPhoneField(
                          labelText: AppStrings.enterPhone,
                          labelSize: 15,
                          errorText:
                              state.hasInteractedWithPhone
                                  ? state.phoneErrorMessage
                                  : null,

                          onChanged: (phone) {
                            context.read<LoginBloc>().add(
                              CompletePhoneChanged(
                                phoneNumber: phone.number, // ex: 1550637983
                                countryCode: phone.countryCode.replaceFirst(
                                  '+',
                                  '',
                                ), // ex: 20
                              ),
                            );
                          },
                        ),
                        SizedBox(height: AppSizeHeight.s20),
                        // Password field
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, AppPadding.p12, AppPadding.p5),
                          child: TextUtils(text: "كلمة المرور"),
                          alignment: AlignmentDirectional.centerEnd,
                        ),
                        CustomTextFormField(
                          labelText: AppStrings.enterPassword,
                          obscureText: state.isPasswordObscured,
                          onChanged:
                              (value) => context.read<LoginBloc>().add(
                                PasswordChanged(value),
                              ),
                          errorText:
                              state.hasInteractedWithPassword &&
                                      !state.isPasswordValid
                                  ? 'كلمة السر قصيرة'
                                  : null,
                          icon: Icon(
                            Icons.lock_outline,
                            color: ColorManager.primary,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              state.isPasswordObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: ColorManager.primary,
                            ),
                            onPressed:
                                () => context.read<LoginBloc>().add(
                                  TogglePasswordVisibility(),
                                ),
                          ),
                        ),

                        SizedBox(height: AppSizeHeight.s100),

                        // Login Button
                        CustomButton(
                          onTap: () {
                            context.read<LoginBloc>().add(
                              LoginSubmitted(
                                countryCode: state.completePhoneNumber
                                    .replaceFirst("+", ''),
                              ),
                            );
                          },
                          btnColor: ColorManager.primary,
                          widget:
                              state.loginStatus == LoginStatus.loading
                                  ? Lottie.asset(LottieManager.carLoading)
                                  : TextUtils(
                                    text: AppStrings.login,
                                    fontWeight: FontWeightManager.bold,
                                    color: ColorManager.background,
                                  ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
