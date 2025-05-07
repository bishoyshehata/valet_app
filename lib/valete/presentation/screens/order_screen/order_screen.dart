import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:valet_app/valete/presentation/components/custom_app_bar.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import 'package:valet_app/valete/presentation/resources/values_manager.dart';

import '../../resources/assets_manager.dart';
import '../../resources/strings_manager.dart';

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
            Column(
              children: [

                Card(
                  margin: EdgeInsets.symmetric(
                    horizontal: AppMargin.m16,
                    vertical: AppMargin.m16,
                  ),
                  color: ColorManager.darkPrimary,
                  elevation: 5,
                  shadowColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizeHeight.s20),
                  ),

                  child: Column(
                    children: [
                      // اختيار نوع المركبة
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: VehicleType.values.map((type) {
                            IconData icon = _getVehicleIcon(type);
                            return GestureDetector(
                              onTap: () {
                                setState(() => selectedVehicleType = type);
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
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: AppMargin.m20,
                              vertical: AppMargin.m20,
                            ),
                            height: AppSizeHeight.s150,
                            width: AppSizeWidth.sMaxWidth ,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: ColorManager.lightGrey,
                              borderRadius: BorderRadius.circular(
                                AppSizeHeight.s20,
                              ),
                            ),
                            child:
                                _image != null
                                    ? ClipRect(
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.file(
                                        _image!,
                                        height: AppSizeHeight.s150,
                                        width: AppSizeWidth.sMaxWidth,
                                        fit: BoxFit.fill,
                                      ),
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
              ],
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
    default:
      return Icons.local_parking;
  }
}
