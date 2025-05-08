import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:valet_app/valete/presentation/components/custom_app_bar.dart';
import 'package:valet_app/valete/presentation/components/custom_bottun.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import 'package:valet_app/valete/presentation/resources/values_manager.dart';
import '../../components/text/text_utils.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/strings_manager.dart';
import 'image_full_screen.dart';

enum VehicleType { car, motorcycle, bicycle, truck }

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  VehicleType selectedVehicleType = VehicleType.car;

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        appBar: CustomAppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_forward_ios_sharp,
                color: ColorManager.primary,
              ),
            ),
          ],
          title: AppStrings.makeOrder,
          centerTitle: true,
          titleColor: ColorManager.white,
          leading: Icon(Icons.edit_note, color: ColorManager.primary),
        ),
        body: Stack(
          children: [
            SizedBox(
              width: AppSizeWidth.sMaxWidth,
              height: AppSizeHeight.sMaxInfinite,
              child: Image.asset(AssetsManager.background, fit: BoxFit.cover),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: AppMargin.m16,
                      vertical: AppMargin.m10,
                    ),
                    color: ColorManager.darkPrimary,
                    elevation: 5,
                    shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizeHeight.s10),
                    ),
              
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(top: AppMargin.m16, right: AppMargin.m24),
                          padding: EdgeInsets.only(right: AppPadding.p5),
                          decoration: BoxDecoration(
                            border: Border(right: BorderSide(color: ColorManager.primary, width: 3)),
                          ),
                          child: RichText(
                            textDirection: TextDirection.rtl,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'التوجه إلى جراج : ',
                                  style: GoogleFonts.cairo(
                                    color: ColorManager.white,
                                    fontSize: FontSize.s17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: 'المحلة الكبرى',
                                  style: GoogleFonts.cairo(
                                    color: ColorManager.primary,
                                    fontSize: FontSize.s15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
              
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(bottom: AppMargin.m16, right: AppMargin.m24),
                          padding: EdgeInsets.only(right: AppPadding.p5),
                          decoration: BoxDecoration(
                            border: Border(right: BorderSide(color: ColorManager.primary, width: 3)),
                          ),
                          child: RichText(
                            textDirection: TextDirection.rtl,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'بالباكية : ',
                                  style: GoogleFonts.cairo(
                                    color: ColorManager.white,
                                    fontSize: FontSize.s17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: 'P-5',
                                  style: GoogleFonts.cairo(
                                    color: ColorManager.primary,
                                    fontSize: FontSize.s15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
              
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: AppMargin.m16,
                      vertical: AppMargin.m10,
                    ),
                    color: ColorManager.darkPrimary,
                    elevation: 5,
                    shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizeHeight.s10),
                    ),
              
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(bottom: AppMargin.m16,top: AppMargin.m16 , right: AppMargin.m24),
                          padding: EdgeInsets.only(right: AppPadding.p5,),
                          decoration: BoxDecoration(
                              border: Border(right: BorderSide(color: ColorManager.primary,width: 3))
                          ),
                          child: TextUtils(
                            text: "قم بإختيار نوع المركبة",
                            color: ColorManager.white,
                            fontSize: FontSize.s17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // اختيار نوع المركبة
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: VehicleType.values.map((type) {
                              IconData icon = _getVehicleIcon(type);
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedVehicleType = type;
                                    print(type);
                                  });
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      icon,
                                      color: selectedVehicleType == type
                                          ? ColorManager.primary
                                          : ColorManager.lightGrey,
                                      size: 30,
                                    ),
                                    Text(
                                      type.name,
                                      style: TextStyle(
                                        color: selectedVehicleType == type
                                            ? ColorManager.primary
                                            : ColorManager.lightGrey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
              
              
                      ],
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: AppMargin.m16,
                      vertical: AppMargin.m10,
                    ),
                    color: ColorManager.darkPrimary,
                    elevation: 5,
                    shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizeHeight.s10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(top: AppMargin.m16 , right: AppMargin.m24),
                          padding: EdgeInsets.only(right: AppPadding.p5,),
                          decoration: BoxDecoration(
                              border: Border(right: BorderSide(color: ColorManager.primary,width: 3))
                          ),
                          child: TextUtils(
                            text: "قم بمسح ال QR",
                            color: ColorManager.white,
                            fontSize: FontSize.s17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height*.25,
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: AppMargin.m16),

                          child: Image.asset(AssetsManager.scanMe,)
                        ),
                      ],
                    ),
                  ),

                  Card(
                    margin: EdgeInsets.symmetric(
                      horizontal: AppMargin.m16,
                      vertical: AppMargin.m10,
                    ),
                    color: ColorManager.darkPrimary,
                    elevation: 5,
                    shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizeHeight.s10),
                    ),
              
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(top: AppMargin.m16 , right: AppMargin.m24),
                          padding: EdgeInsets.only(right: AppPadding.p5,),
                          decoration: BoxDecoration(
                              border: Border(right: BorderSide(color: ColorManager.primary,width: 3))
                          ),
                          child: TextUtils(
                            text: "قم بإلتقاط صورة للمركبة",
                            color: ColorManager.white,
                            fontSize: FontSize.s17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: AppMargin.m20,
                                vertical: AppMargin.m20,
                              ),
                              height: MediaQuery.of(context).size.height*.25,
                              width: AppSizeWidth.sMaxWidth ,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: ColorManager.lightGrey,
                                borderRadius: BorderRadius.circular(
                                  AppSizeHeight.s10,
                                ),
                              ),
                              child:
                              _image != null
                                  ? ClipRect(
                                clipBehavior: Clip.antiAlias,
                                child :
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FullScreenImage(imageFile: _image!),
                                      ),
                                    );
                                  },
                                  child: PhotoView(
                                    imageProvider: FileImage(_image!), // ✅ هذا هو المطلوب
                                    backgroundDecoration: BoxDecoration(
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              )
                                  : Icon(
                                Icons.image,
                                size: AppSizeHeight.s100,
                                color: ColorManager.darkPrimary,
                              ),
                            ),
                            Positioned(
                              bottom: AppSizeHeight.s15,
                              right: AppSizeHeight.s15,
                              child: IconButton(
                                onPressed: () {
                                  _pickImage(ImageSource.camera);
                                },
              
                                icon: Icon(
                                  Icons.camera_alt,
                                  size: AppSizeHeight.s30,
                                  color: ColorManager.primary,
                                ),
                                color: ColorManager.white,
                              ),
                            ),
                          ],
                        ),
              
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizeHeight.s10,),

                  CustomButton(
                    onTap: () {},
                    btnColor: ColorManager.darkPrimary,
                    shadowColor: ColorManager.white,
                    width: MediaQuery.of(context).size.width*.9,
                    radius: AppSizeHeight.s10,
                    borderColor: ColorManager.white,
                    elevation: 5,


                    widget: TextUtils(
                      text: "تفعيل الطلب",
                      color: ColorManager.white,
                      fontSize: FontSize.s17,
                      fontWeight: FontWeight.bold,
                    ),),
                  SizedBox(height: AppSizeHeight.s20,)
              
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
IconData _getVehicleIcon(VehicleType type) {
  switch (type) {
    case VehicleType.car:
      return Icons.directions_car;
    case VehicleType.motorcycle:
      return Icons.motorcycle;
    case VehicleType.bicycle:
      return Icons.directions_bike;
    case VehicleType.truck:
      return Icons.local_shipping;
    }
}
