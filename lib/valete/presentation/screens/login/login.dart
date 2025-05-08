import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valet_app/core/utils/enums.dart';
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
import '../../components/login/custom_phone.dart';
import '../../controllers/login/login_events.dart';
import '../../resources/colors_manager.dart';
import '../../resources/strings_manager.dart';
import '../valet_home/valet_home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: ColorManager.background,
          appBar: CustomAppBar(
            title: AppStrings.login,
            titleColor: ColorManager.white,
            leading: Icon(Icons.login_rounded, color: ColorManager.primary),
          ),
          body: BlocProvider<LoginBloc>(
            create: (context) {
             return LoginBloc(sl<LoginUseCase>());
            },
            child: Stack(
              children: [
                Image.asset(
                  AssetsManager.background,
                  width: AppSizeWidth.sMaxWidth,
                  height: AppSizeHeight.sMaxInfinite,
                  fit: BoxFit.cover,
                ),
                Container(
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
                              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) =>  ValetHomeScreen(),));
                            }
                            break;
                          default:

                            break;
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: AppSizeHeight.s30),

                            // Logo
                            SizedBox(
                              height: AppSizeHeight.s65,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  TextUtils(
                                    text: AppStrings.appName,
                                    fontSize: FontSize.s70,
                                    fontFamily: 'modak',
                                    color: ColorManager.primary,
                                  ),   Icon(Icons.garage_rounded,
                                      color: ColorManager.primary,
                                      size: AppSizeHeight.s60),
                                ],
                              ),
                            ),

                            SizedBox(height: AppSizeHeight.s100),

                            // // Phone field

                            CustomPhoneField(
                              labelText: AppStrings.enterPhone,
                              labelSize: 15,
                                errorText: state.hasInteractedWithPhone ? state.phoneErrorMessage : null,

                                onChanged: (phone) {

                                  context.read<LoginBloc>().add(
                                    CompletePhoneChanged(
                                      phoneNumber: phone.number, // ex: 1550637983
                                      countryCode: phone.countryCode.replaceFirst('+', ''), // ex: 20
                                    ),
                                  );
                                  print(state.completePhoneNumber.replaceFirst('+', ''));
                                }
                            ),

                            // CustomTextFormField(
                            //   labelText: AppStrings.enterPhone,
                            //   keyboard: TextInputType.number,
                            //   onChanged: (value) => context.read<LoginBloc>().add(PhoneChanged(value)),
                            //   errorText: state.hasInteractedWithPhone && !state.isPhoneValid
                            //       ? 'Invalid phone number'
                            //       : null,
                            //   icon: Icon(Icons.phone_outlined, color: ColorManager.white),
                            // ),


                            SizedBox(height: AppSizeHeight.s20),

                            // Password field
                            CustomTextFormField(
                              labelText: AppStrings.enterPassword,
                              obscureText: state.isPasswordObscured,
                              onChanged: (value) => context.read<LoginBloc>().add(PasswordChanged(value)),
                              errorText: state.hasInteractedWithPassword && !state.isPasswordValid
                                  ? 'كلمة السر قصيرة'
                                  : null,
                              icon: Icon(Icons.lock_outline, color: ColorManager.white),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  state.isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                                  color: ColorManager.white,
                                ),
                                onPressed: () => context.read<LoginBloc>().add(TogglePasswordVisibility()),
                              ),
                            ),

                            SizedBox(height: AppSizeHeight.s100),

                            // Login Button
                            CustomButton(
                              onTap:(){
                                context.read<LoginBloc>().add(LoginSubmitted(countryCode: state.completePhoneNumber.replaceFirst("+", '')));
                                 } ,
                              btnColor: ColorManager.primary,
                              shadowColor: ColorManager.white,
                              widget: state.loginStatus == LoginStatus.loading
                                  ? CircularProgressIndicator(color: ColorManager.background,  )
                                  : TextUtils(
                                text: AppStrings.login,
                                fontWeight: FontWeightManager.bold,
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
          ),
        ),
      ),
    );
  }
}
