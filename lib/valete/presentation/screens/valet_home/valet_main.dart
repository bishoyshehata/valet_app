import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_states.dart';
import 'package:valet_app/valete/presentation/controllers/login/login_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/login/login_states.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import 'package:valet_app/valete/presentation/screens/login/login.dart';
import 'package:valet_app/valete/presentation/screens/valet_home/valet_home_screen.dart';
import 'package:valet_app/valete/presentation/screens/valet_home/profile/valet_profile.dart';
import '../../../../core/utils/enums.dart';
import '../../components/custom_bottun.dart';
import '../../components/custom_textFormField.dart';
import '../../components/text/text_utils.dart';
import '../../controllers/home/home_events.dart';
import '../../controllers/login/login_events.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/strings_manager.dart';
import 'orders_status.dart';

class MainScreen extends StatelessWidget {
  final List<Widget> screens = [
    ValetHomeScreen(),
    OrdersScreen(),
    ValetProfileScreen(),
  ];

  final List<String> titles = [
    'الجراجات',
    'الطلبات',
    'شخصي',
  ];

   MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginStates>(
      listener: (context, state) {
        // String password ='';
        if (state.reAuthStatus == ReAuthStatus.waitingForPassword) {
          // showDialog(
          //   barrierDismissible: false,
          //   context: context,
          //   builder: (_) => AlertDialog(
          //     title: Text("إعادة تسجيل الدخول"),
          //     content: CustomTextFormField(
          //       labelText: AppStrings.enterPassword,
          //       obscureText: state.isPasswordObscured,
          //       onChanged:
          //           (value) {
          //         password =value;
          //         print(password);
          //       },
          //       errorText:
          //       state.hasInteractedWithPassword &&
          //           !state.isPasswordValid
          //           ? 'كلمة السر قصيرة'
          //           : null,
          //       icon: Icon(
          //         Icons.lock_outline,
          //         color: ColorManager.primary,
          //       ),
          //       suffixIcon: IconButton(
          //         icon: Icon(
          //           state.isPasswordObscured
          //               ? Icons.visibility_off
          //               : Icons.visibility,
          //           color: ColorManager.primary,
          //         ),
          //         onPressed:
          //             () => context.read<LoginBloc>().add(
          //           TogglePasswordVisibility(),
          //         ),
          //       ),
          //     ),
          //
          //     actions: [
          //       CustomButton(
          //         onTap: () async{
          //           SharedPreferences prefs = await SharedPreferences.getInstance();
          //           String? phone = prefs.getString('valetPhone');
          //           print(phone);
          //
          //           context.read<LoginBloc>().add(ReAuthSubmittedEvent(password, phone!));
          //           context.read<HomeBloc>().add(GetMyGaragesEvent());
          //         },
          //         btnColor: ColorManager.primary,
          //         shadowColor: ColorManager.white,
          //         widget:
          //         state.reAuthStatus == LoginStatus.loading
          //             ? Lottie.asset(LottieManager.carLoading)
          //             : TextUtils(
          //           text: AppStrings.login,
          //           fontWeight: FontWeightManager.bold,
          //           color: ColorManager.background,
          //         ),
          //       ),
          //
          //     ],
          //   ),
          // );
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginScreen(),));
        }
        //
        // if (state.reAuthStatus == ReAuthStatus.error) {
        //   Navigator.of(context, rootNavigator: true).pop(); // إغلاق الـ Dialog
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('حدث خطأ أثناء إعادة المصادقة. حاول مرة أخرى.'),
        //       backgroundColor: Colors.red,
        //       duration: Duration(seconds: 3),
        //     ),
        //   );
        // }
        //
        // if (state.reAuthStatus == ReAuthStatus.success) {
        //   Navigator.of(context, rootNavigator: true).pop();
        // }
      },

      child: BlocBuilder<HomeBloc, HomeState>(

      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: ColorManager.background,
            body: screens[state.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: ColorManager.background,
              currentIndex: state.currentIndex,
              selectedItemColor: ColorManager.primary,
              unselectedItemColor: ColorManager.white,
              onTap: (index) {
                context.read<HomeBloc>().add(ChangeTabEvent(index));
              },
              unselectedLabelStyle:GoogleFonts.cairo(color: ColorManager.white) ,
              selectedLabelStyle: GoogleFonts.cairo(color: ColorManager.primary),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_work_outlined, color: ColorManager.white,),
                  label: 'الجراج',
                  activeIcon: Icon(Icons.home_work_rounded, color: ColorManager.primary,),
                ),
                 BottomNavigationBarItem(
                  icon: Icon(Icons.note_alt_outlined, color: ColorManager.white,),
                  label: 'الطلبات',
                   activeIcon: Icon(Icons.note_alt_rounded, color: ColorManager.primary,),
                ),
                 BottomNavigationBarItem(
                  icon: Icon(Icons.person_2_outlined, color: ColorManager.white,),
                  label: 'شخصي',
                   activeIcon: Icon(Icons.person, color: ColorManager.primary,),backgroundColor: ColorManager.primary

                ),
              ],
            ),
          ),
        );
      },
    ),
);
  }
}
