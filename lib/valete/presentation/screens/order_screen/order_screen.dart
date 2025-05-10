import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import 'package:valet_app/valete/presentation/resources/values_manager.dart';
import '../../../../core/utils/enums.dart';
import '../../components/text/text_utils.dart';
import '../../components/custom_app_bar.dart';
import '../../components/custom_bottun.dart';
import '../../controllers/orders/order_bloc.dart';
import '../../controllers/orders/order_events.dart';
import '../../controllers/orders/order_states.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/strings_manager.dart';
import '../garage_screen/garage_screen.dart';
import 'image_full_screen.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderBloc()..add(LoadImageEvent("data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAzQAAAM0AQAAAABFCVraAAAD70lEQVR4nO3cUXLbMAwEUN+g979lb9CkmSgkF5SafLgN1McPjyyZXAYD7EIgw8evv9J+PuCwGz8QP/gAj9IFeio/kFfJE+XX3he8Z3lv9L6tfqDuoo6k/qae+MymDstu/ED84AM8ShfoqfxAXvVd8sRHth8fD16v4t7vrq99j4/5J3UAOOzGD8QPPsCjdKGvno77y+jvwy3zmXsMnDoAHHbjB+IHH+BRutBfT0cGER8xXAw831sGgMNu/ED84AM8Shdup6en6ca4B4fd+IH4wQd4lC78j3oayxXlKjIXOOzGD8QPPsCjdOFmelq+RqZxtJjAxQBw2I0fiB98gEfpQms9jVbXLP70UQeAw278QPzgAzxKF1rr6SfaewpyVCfmBGVJQUqDw278QPzgAzxKF7rq6eg/Vip25YgBEWWLmA8cduMH4gcf4FG60F9Pd0sYy56G8lFhY+8DHHbjB+IHH+BRutBcTyMPibb7Z4mTNs8WDrvxA/GDD/AoXWisp/PPloOXLn6yHNG4y1LgsBs/ED/4AI/ShdZ6OpKRi6pDPbFxfjq6vV1d1kPgsBs/ED/4AI/ShRZ6WtcsdhBlpN0Cx2UeAofd+IH4wQd4lC7009PdqUpRk4gUZN8DDrvxA/GDD/AoXeiup7t/koxZRB4S9wIWDrvxA/GDD/AoXbiNnr5d1a0L5Wksa9QcBg678QPxgw/wKF3or6clyYgHy7ELu6/z9EoPOOzGD8QPPsCjdKGnntZ0Y1zFEkZM6it1Cjjsxg/EDz7Ao3Shj57GdoZNLpE1iXkWAVFSFTjsxg/EDz7Ao3Sho56WoxNGh2OQ/bLGyVM47MYPxA8+wKN0ob+ezrWGY5DodfofE2W2JYeBw278QPzgAzxKFzrq6QA7zTT2mx3GVHa5CRx24wfiBx/gUbrQWk+XOkXA7p/ujlgYYHDYjR+IH3yAR+lCdz2NzYtzchFbF07mEzjrXwCH3fiB+MEHeJQudNTTXYv8ItKSMpUDcd40CYfd+IH4wQd4lC401tMY7rprwJYjmOCwGz8QP/gAj9KFm+hp1CmWU5UCMbY97CsWn1zHgMNu/ED84AM8She+t56OX0RCEYiBHaPDYTd+IH7wAR6lCzfW09jY8NHrsZ/AyX5JOOzGD8QPPsCjdOFeehppyTFcVDF2X+cGh934gfjBB3iULjTW0wK7jF5SkKhJXJwBDYfd+IH4wQd4lC701NO6ILEpOCwrFUcr2Jd5CBx24wfiBx/gUbrQRU+f2eCwGz8QP/gAj9IFeio/kFfJE+XX3he8Z3lv9L6tfqDuoo6k/qae+NymDstu/ED84AM8ShfoqfxAXvVP88QXaUbDGPol1zIAAAAASUVORK5CYII=")),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: ColorManager.background,
          appBar: CustomAppBar(
            actions: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_forward_ios_sharp, color: ColorManager.primary),
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
                    _buildGarageInfoCard(),
                    _buildVehicleTypeSelector(context),
                    _buildQrSection(context),
                    _buildImageCaptureSection(context),
                    SizedBox(height: AppSizeHeight.s10),
                    CustomButton(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => GarageScreen(),));
                      },
                      btnColor: ColorManager.darkPrimary,
                      shadowColor: ColorManager.white,
                      width: MediaQuery.of(context).size.width * .9,
                      radius: AppSizeHeight.s10,
                      borderColor: ColorManager.white,
                      elevation: 5,
                      widget: TextUtils(
                        text: "تفعيل الطلب",
                        color: ColorManager.primary,
                        fontSize: FontSize.s17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSizeHeight.s20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 /// widgets
  Widget _buildGarageInfoCard() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: AppMargin.m16, vertical: AppMargin.m10),
      color: ColorManager.darkPrimary,
      elevation: 5,
      shadowColor: ColorManager.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizeHeight.s10)),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(top: AppMargin.m10, right: AppMargin.m24),
            padding: EdgeInsets.only(right: AppPadding.p5),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: ColorManager.primary, width: 3)),
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "التوجه إلى جراج : ",
                    style: TextStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "المحلة الكبرى",
                    style: TextStyle(
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
            margin: EdgeInsets.only(bottom: AppMargin.m10, right: AppMargin.m24),
            padding: EdgeInsets.only(right: AppPadding.p5),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: ColorManager.primary, width: 3)),
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "بالباكية : ",
                    style: TextStyle(
                      color: ColorManager.white,
                      fontSize: FontSize.s17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "P-5",
                    style: TextStyle(
                      color: ColorManager.primary,
                      fontSize: FontSize.s15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildVehicleTypeSelector(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: AppMargin.m16, vertical: AppMargin.m10),
      color: ColorManager.darkPrimary,
      elevation: 5,
      shadowColor: ColorManager.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizeHeight.s10)),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(bottom: AppMargin.m16, top: AppMargin.m16, right: AppMargin.m24),
            padding: EdgeInsets.only(right: AppPadding.p5),
            decoration: BoxDecoration(border: Border(right: BorderSide(color: ColorManager.primary, width: 3))),
            child: TextUtils(
              text: "قم بإختيار نوع المركبة",
              color: ColorManager.white,
              fontSize: FontSize.s17,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: VehicleType.values.map((type) {
                    final icon = _getVehicleIcon(type);
                    final isSelected = state.selectedVehicleType == type;
                    return GestureDetector(
                      onTap: () {
                        context.read<OrderBloc>().add(SelectVehicleType(type));
                      },
                      child: Column(
                        children: [
                          Icon(icon, color: isSelected ? ColorManager.primary : ColorManager.white, size: 30),
                          Text(
                            type.name,
                            style: TextStyle(
                              color: isSelected ? ColorManager.primary : ColorManager.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildQrSection(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: AppMargin.m16, vertical: AppMargin.m10),
      color: ColorManager.darkPrimary,
      elevation: 5,
      shadowColor: ColorManager.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizeHeight.s10)),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(top: AppMargin.m16, right: AppMargin.m24),
            padding: EdgeInsets.only(right: AppPadding.p5),
            decoration: BoxDecoration(border: Border(right: BorderSide(color: ColorManager.primary, width: 3))),
            child: TextUtils(
              text: "قم بمسح ال QR",
              color: ColorManager.white,
              fontSize: FontSize.s17,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .25,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: AppMargin.m16),
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state.imageBytes != null) {
                  return Center(child: Image.memory(state.imageBytes!));
                }

                return Center(child: Text('لم يتم تحميل الصورة'));
              },
            ),
          ),

        ],
      ),
    );
  }
  Widget _buildImageCaptureSection(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: AppMargin.m16, vertical: AppMargin.m10),
      color: ColorManager.darkPrimary,
      elevation: 5,
      shadowColor: ColorManager.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizeHeight.s10)),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(top: AppMargin.m16, right: AppMargin.m24),
            padding: EdgeInsets.only(right: AppPadding.p5),
            decoration: BoxDecoration(border: Border(right: BorderSide(color: ColorManager.primary, width: 3))),
            child: TextUtils(
              text: "قم بإلتقاط صورة للمركبة",
              color: ColorManager.white,
              fontSize: FontSize.s17,
              fontWeight: FontWeight.bold,
            ),
          ),
          BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              final image = state.image;
              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(AppMargin.m20),
                    height: MediaQuery.of(context).size.height * .25,
                    width: AppSizeWidth.sMaxWidth,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: ColorManager.lightGrey,
                      borderRadius: BorderRadius.circular(AppSizeHeight.s10),
                    ),
                    child: image != null
                        ? GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FullScreenImage(imageFile: image),
                        ),
                      ),
                      child: PhotoView(
                        imageProvider: FileImage(image),
                        backgroundDecoration: BoxDecoration(color: ColorManager.background),
                      ),
                    )
                        : Icon(Icons.image, size: AppSizeHeight.s100, color: ColorManager.white),
                  ),
                  Positioned(
                    bottom: AppSizeHeight.s15,
                    right: AppSizeHeight.s15,
                    child: IconButton(
                      onPressed: () {
                        context.read<OrderBloc>().add(PickImageEvent());
                      },

                      icon: Icon(Icons.camera_alt, size: AppSizeHeight.s30, color: ColorManager.primary),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
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
