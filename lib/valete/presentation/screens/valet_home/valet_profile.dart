import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/valete/presentation/components/custom_app_bar.dart';
import 'package:valet_app/valete/presentation/components/text/text_utils.dart';
import '../../components/alert_dialog.dart';
import '../../resources/assets_manager.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';

class ValetProfileScreen extends StatefulWidget {
  const ValetProfileScreen({super.key});

  @override
  State<ValetProfileScreen> createState() => _ValetProfileScreenState();
}

class _ValetProfileScreenState extends State<ValetProfileScreen> {

  String? valetId;
  String? valetName;
  String? companyName;
  String? whatsapp;

  @override
  void initState()  {

    super.initState();
    loadHiveData(); // استدعاء الدالة اللي فيها async

  }
  Future<void> loadHiveData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      valetId =prefs.getString('valetId');
      valetName =prefs.getString('valetName');
      companyName =prefs.getString('companyName');
      whatsapp =prefs.getString('whatsapp');
    });
  }

  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.only(top: AppPadding.p100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 SizedBox(
                     height:AppSizeHeight.s100,
                     child: Image.asset(AssetsManager.valet)),
                  SizedBox(height: AppSizeHeight.s16),
                  TextUtils(
                    text: "${valetName ?? "غير معروف"}",
                        fontSize: FontSize.s17, fontWeight: FontWeight.bold , color: ColorManager.white,),
                  TextUtils(
                   text: "${companyName ?? "غير معروف"}",
               fontSize: FontSize.s13, color: Colors.grey),

                  SizedBox(height: AppSizeHeight.s30),
                  ListTile(
                    leading:  Icon(Icons.privacy_tip,color: ColorManager.white,),
                    title: TextUtils(
                    text: "الشروط و الأحكام",
                    fontSize: FontSize.s17, fontWeight: FontWeight.bold , color: ColorManager.white,),
                    onTap: () {
                      // Handle privacy policy
                    },
                  ),
                  ListTile(
                    leading:  Icon(Icons.delete_forever,color: ColorManager.error,),
                    title: TextUtils(
                    text: "حذف الحساب",
                    fontSize: FontSize.s17, fontWeight: FontWeight.bold , color: ColorManager.white,),
                    onTap: () async {
                      await AlertDialogService().showAlertDialog(
                        context,
                        title: 'تنبيه',
                        message: 'هل أنت متأكد من حذف حسابك ؟',
                        positiveButtonText: 'نعم',
                        negativeButtonText: 'لا',
                        onPositiveButtonPressed: () {

                        },
                      ); },
                  ),
                  ListTile(
                    leading:  Icon(Icons.logout,color: ColorManager.white),
                    title: TextUtils(
                      text: "تسجيل الخروج",
                      fontSize: FontSize.s17, fontWeight: FontWeight.bold , color: ColorManager.white,),
                    onTap: () async {
                      await AlertDialogService().showAlertDialog(
                        context,
                        title: 'تنبيه !',
                        message: 'هل أنت متأكد من تسجيل الخروج ؟',
                        positiveButtonText: 'نعم',
                        negativeButtonText: 'لا',
                        onPositiveButtonPressed: () {
                          // احذف الطلب
                        },
                      ); },
                  ),
                ],
              ),
            )
        )
    );

  }
}