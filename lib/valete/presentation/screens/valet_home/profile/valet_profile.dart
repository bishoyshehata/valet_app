import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/core/utils/enums.dart';
import 'package:valet_app/valete/data/models/update_valet_model.dart';
import 'package:valet_app/valete/presentation/components/custom_app_bar.dart';
import 'package:valet_app/valete/presentation/components/custom_bottun.dart';
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

  Future<Map<String, dynamic>> loadPreferenceData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'valetId': prefs.getInt('valetId'),
      'valetName': prefs.getString('valetName'),
      'companyName': prefs.getString('companyName'),
      'whatsapp': prefs.getString('whatsapp'),
      'valetPhone': prefs.getString('valetPhone'),
      // 'password': prefs.getString('password'),
      'status': prefs.getInt('status'),
      'companyId': prefs.getInt('companyId'),
    };
  }

  List<Status> statusList = Status.values;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadPreferenceData(),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // loading indicator
        }

        if (snapshot.hasError) {
          return const Text(
            'حدث خطأ',
            style: TextStyle(color: Colors.red),
          ); // error message
        }

        final data = snapshot.data!;
        final valetId = data['valetId'] ?? '---';
        final valetName = data['valetName'] ?? '---';
        final companyName = data['companyName'] ?? '---';
        final whatsapp = data['whatsapp'] ?? '---';
        final valetPhone = data['valetPhone'] ?? '---';
        final status = data['status'] ?? 0;
        final companyId = data['companyId'] ?? '---';
        // final password = data['password'] ?? '---';
        final initialStatus = Status.values[status];
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
                  if (state.logOutState == LogOutState.loaded ||
                      state.deleteState == RequestState.loaded) {
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
                            Padding(
                              padding: EdgeInsets.only(right: AppSizeWidth.s15),
                              child: Icon(
                                Icons.edit,
                                color: ColorManager.white,
                              ),
                            ),
                            SizedBox(width: AppSizeWidth.s8),
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
                                child: switch (state.updateValetState) {
                                  RequestStatess.loading => Container(
                                    padding: EdgeInsets.all(AppPadding.p8) ,
                                    width: AppSizeHeight.s35,
                                    height: AppSizeHeight.s35,
                                    child: CircularProgressIndicator(
                                      color: ColorManager.white,
                                    ),
                                  ),
                                  RequestStatess.loaded =>
                                    DropdownButton2<Status>(
                                      isExpanded: true,
                                      items:
                                          statusList.map((status) {
                                            return DropdownMenuItem<Status>(
                                              value: status,
                                              child: TextUtils(
                                                text: status.displayName,
                                                color: ColorManager.background,
                                                fontSize: FontSize.s15,
                                                fontWeight:
                                                    FontWeightManager.bold,
                                              ),
                                            );
                                          }).toList(),
                                      value:
                                          state.selectedStatus ?? initialStatus,
                                      onChanged: (value) {
                                        if (value != null) {
                                          context.read<ProfileBloc>().add(
                                            ChangeStatusEvent(value),
                                          );
                                        }
                                      },
                                      hint:  TextUtils(text: '...',),
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
                                              MaterialStateProperty.all<double>(
                                                6,
                                              ),
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
                                  RequestStatess.error => TextUtils(
                                    text:
                                        state.updateValetStatusCode.toString(),
                                  ),
                                  null => throw UnimplementedError(),
                                  RequestStatess.initial => DropdownButton2<Status>(
                                    isExpanded: true,
                                    items:
                                    statusList.map((status) {
                                      return DropdownMenuItem<Status>(
                                        value: status,
                                        child: TextUtils(
                                          text: status.displayName,
                                          color: ColorManager.background,
                                          fontSize: FontSize.s15,
                                          fontWeight:
                                          FontWeightManager.bold,
                                        ),
                                      );
                                    }).toList(),
                                    value:
                                    state.selectedStatus ?? initialStatus,
                                    onChanged: (value) {
                                      if (value != null) {
                                        context.read<ProfileBloc>().add(
                                          ChangeStatusEvent(value),
                                        );
                                      }
                                    },
                                    hint: TextUtils(text: '...',),
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
                                        MaterialStateProperty.all<double>(
                                          6,
                                        ),
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
                                },
                              ),
                            ),

                            // **زر حفظ التغييرات يظهر فقط لو حصل تغيير**
                            if (state.isStatusChanged)
                              Padding(
                                padding:  EdgeInsets.only(left: AppPadding.p20 , right: AppPadding.p20 ),
                                child: CustomButton(
                                  onTap: () async {
                                    final newUser = UpdateValetModel(
                                      id: valetId,
                                      name: valetName,
                                      phone: valetPhone,
                                      password: '123123123',
                                      whatsapp: whatsapp,
                                      companyId: companyId,
                                      status: state.selectedStatus?.index ?? 0,
                                    );
                                    context.read<ProfileBloc>().add(
                                      UpdateValetEvent(newUser),
                                    );
                                  },
                                  widget: TextUtils(
                                    text: 'حفظ',
                                    color: ColorManager.white,
                                    fontWeight: FontWeightManager.bold,
                                  ),
                                  btnColor: ColorManager.success,
                                  width: AppSizeWidth.s100,
                                  height: AppSizeHeight.s35,
                                  radius: AppSizeHeight.s10,
                                ),
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
