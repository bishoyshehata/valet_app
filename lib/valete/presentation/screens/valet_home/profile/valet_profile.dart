import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/core/utils/enums.dart';
import 'package:valet_app/valete/presentation/components/custom_app_bar.dart';
import 'package:valet_app/valete/presentation/components/text/text_utils.dart';
import 'package:valet_app/valete/presentation/controllers/profile/profile_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/profile/profile_events.dart';
import 'package:valet_app/valete/presentation/controllers/profile/profile_states.dart';
import 'package:valet_app/valete/presentation/screens/splash/splash.dart';
import 'package:valet_app/valete/presentation/screens/valet_home/profile/term_and_conditions.dart';
import '../../../components/alert_dialog.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/colors_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/values_manager.dart';

class ValetProfileScreen extends StatelessWidget {
   ValetProfileScreen({super.key});

  Future<Map<String, String?>> loadPreferenceData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'valetId': prefs.getString('valetId'),
      'valetName': prefs.getString('valetName'),
      'companyName': prefs.getString('companyName'),
      'whatsapp': prefs.getString('whatsapp'),
    };
  }
  List<Status> statusList = Status.values;
   Status? selectedStatus;
   Status? initialStatus = Status.Active;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadPreferenceData(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // loading indicator
        }

        if (snapshot.hasError) {
          return const Text('حدث خطأ');
        }

        final data = snapshot.data!;
        final valetId = data['valetId'] ?? '---';
        final valetName = data['valetName'] ?? '---';
        final companyName = data['companyName'] ?? '---';
        final whatsapp = data['whatsapp'] ?? '---';

        return Scaffold(
          backgroundColor: ColorManager.background,
          appBar: CustomAppBar(
            title: 'الملف الشخصي',
            centerTitle: false,
            titleColor: ColorManager.white,
            leading: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(AppMargin.m4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizeHeight.s50),
                color: ColorManager.grey,
              ),
              child: Icon(Icons.person, color: ColorManager.white),
            ),
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.only(top: AppPadding.p60),
              child: BlocListener<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state.logOutState == LogOutState.loaded || state.deleteState == RequestState.loaded) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => SplashScreen()),
                          (route) => false,
                    );
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: AppSizeHeight.s100,
                      child: Image.asset(AssetsManager.valet),
                    ),
                    SizedBox(height: AppSizeHeight.s16),
                    TextUtils(
                      text: valetName,
                      fontSize: FontSize.s17,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.white,
                    ),
                    TextUtils(
                      text: whatsapp,
                      fontSize: FontSize.s13,
                      color: Colors.grey,
                    ),
                    TextUtils(
                      text: companyName,
                      fontSize: FontSize.s13,
                      color: Colors.grey,
                    ),

                    SizedBox(height: AppSizeHeight.s30),
                    BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        return Row(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        Padding(padding: EdgeInsets.only(right: AppSizeWidth.s15),child: Icon(Icons.edit ,color: ColorManager.white,),),
                        SizedBox(width: AppSizeWidth.s8,),
                        TextUtils(
                          text: 'الحالة : ',
                          color: ColorManager.white,
                          fontSize: FontSize.s17,
                          fontWeight: FontWeight.bold,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizeWidth.s8,
                          ),
                          alignment: Alignment.center,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: ColorManager.primary,
                            borderRadius: BorderRadius.circular(
                              AppSizeHeight.s10,
                            ),
                          ),
                          width: AppSizeWidth.s100,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<Status>(
                              isExpanded: true,
                              items: statusList.map((status) {
                                return DropdownMenuItem<Status>(
                                  value: status,
                                  child: TextUtils(
                                    text: status.displayName,
                                    color: ColorManager.background,
                                    fontSize: FontSize.s15,
                                    fontWeight: FontWeightManager.bold,
                                  ),
                                );
                              }).toList(),
                              value: selectedStatus ?? initialStatus,
                              onChanged: (value) {
                                if (value != null) {
                                  context.read<ProfileBloc>().add(ChangeStatusEvent(value));
                                }
                              },
                              hint: Text("اختر الحالة"),
                              iconStyleData: IconStyleData(
                                icon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: ColorManager.background,
                                ),
                                iconSize: 14,
                                iconEnabledColor: Colors.yellow,
                                iconDisabledColor: Colors.grey,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: AppSizeHeight.s250,
                                width: AppSizeWidth.s120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    14,
                                  ),
                                  color: ColorManager.primary,
                                ),
                                offset: const Offset(-20, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness:
                                  MaterialStateProperty.all<
                                      double
                                  >(6),
                                  thumbVisibility:
                                  MaterialStateProperty.all<bool>(
                                    true,
                                  ),
                                ),
                              ),
                              menuItemStyleData: MenuItemStyleData(
                                height: AppSizeHeight.s35,
                                padding: EdgeInsets.only(
                                  left: 14,
                                  right: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (state.isChanged)
                          ElevatedButton(
                            onPressed: () {
                              context.read<ProfileBloc>().add(SaveStatusEvent());
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("تم حفظ التغييرات")),
                              );
                            },
                            child: Text("حفظ التغييرات"),
                          ),
                      ],
                    );
  },
),

                    ListTile(
                      leading: Icon(
                        Icons.privacy_tip,
                        color: ColorManager.white,
                      ),
                      title: TextUtils(
                        text: "الشروط و الأحكام",
                        fontSize: FontSize.s17,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.white,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TermAndConditions(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.delete_forever,
                        color: ColorManager.error,
                      ),
                      title: TextUtils(
                        text: "حذف الحساب",
                        fontSize: FontSize.s17,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.white,
                      ),
                      onTap: () async {
                        await AlertDialogService().showAlertDialog(
                          context,
                          title: 'تنبيه',
                          message: 'هل أنت متأكد من حذف حسابك ؟',
                          positiveButtonText: 'نعم',
                          negativeButtonText: 'لا',
                          onPositiveButtonPressed: () {
                            context.read<ProfileBloc>().add(
                              DeleteValetEvent(int.parse(valetId)),
                            );

                          },
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout, color: ColorManager.white),
                      title: TextUtils(
                        text: "تسجيل الخروج",
                        fontSize: FontSize.s17,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.white,
                      ),
                      onTap: () async {
                        await AlertDialogService().showAlertDialog(
                          context,
                          title: 'تنبيه !',
                          message: 'هل أنت متأكد من تسجيل الخروج ؟',
                          positiveButtonText: 'نعم',
                          negativeButtonText: 'لا',
                          onPositiveButtonPressed: () {
                            context.read<ProfileBloc>().add(LogoutEvent());
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
extension StatusExtension on Status {
  String get displayName {
    switch (this) {
      case Status.Active:
        return "نشط";
      case Status.DisActive:
        return "غير نشط";
      case Status.Busy:
        return "مشغول";
    }
  }
}
