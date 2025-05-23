import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/valete/data/datasource/socket/socket_manager.dart';
import 'package:valet_app/valete/domain/usecases/create_order_use_case.dart';
import 'package:valet_app/valete/domain/usecases/store_order_use_case.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import 'package:valet_app/valete/presentation/resources/values_manager.dart';
import 'package:valet_app/valete/presentation/screens/valet_home/valet_main.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/enums.dart';
import '../../../data/models/store_order_model.dart';
import '../../../domain/entities/spot.dart';
import '../../components/text/text_utils.dart';
import '../../components/custom_app_bar.dart';
import '../../components/custom_bottun.dart';
import '../../controllers/orders/order_bloc.dart';
import '../../controllers/orders/order_events.dart';
import '../../controllers/orders/order_states.dart';
import '../../resources/font_manager.dart';
import 'image_full_screen.dart';
import 'package:shimmer/shimmer.dart';

class OrderScreen extends StatelessWidget {
  final SocketService socketService = SocketService();

  OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderBloc>(
      create: (context) {
        final bloc = OrderBloc(
          sl<CreateOrderUseCase>(),
          sl<StoreOrderUseCase>(),
        )..add(CreateOrderEvent());

        // init socket once and push event to bloc
        SharedPreferences.getInstance().then((prefs) {
          String? valetId = prefs.getString('valetId');
          socketService.initSocket(
            saiesId: valetId!,
            onPhoneReceived: (phone) {
              bloc.add(UpdatePhoneNumberEvent(phone));
            },
          );
        });

        return bloc;
      },
      child: BlocBuilder<OrderBloc, OrderState>(
        // buildWhen: (previous, current) =>
        // previous.defaultOrderState != current.defaultOrderState ||
        //     previous.phoneNumber != current.phoneNumber ||
        //     previous.spotName != current.spotName ||
        //       previous.data?.spots != current.data?.spots,
        builder: (context, state) {
          switch (state.defaultOrderState) {
            case RequestState.loading:
              return SizedBox(
                height: AppSizeHeight.sMaxInfinite,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder:
                      (context, index) => Shimmer.fromColors(
                        baseColor: Colors.grey[850]!,
                        highlightColor: Colors.grey[800]!,
                        child: Container(
                          margin: EdgeInsets.only(
                            right: AppMargin.m12,
                            top: AppMargin.m12,
                            left: AppMargin.m12,
                          ),
                          height: AppSizeHeight.s120,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemCount: 4,
                ),
              );

            case RequestState.loaded:
              final spotName =
                  state.spotName == 'رقم الباكية'
                      ? state.data!.spotName
                      : state.spotName;
              final spotId =
                  state.spotName == 'رقم الباكية'
                      ? state.data!.spotId
                      : state.data!.spots
                          .firstWhere((spot) => spot.code == spotName)
                          .id;
              return Directionality(
                textDirection: TextDirection.rtl,
                child: WillPopScope(
                  onWillPop: () async {
                    SocketService().closeSocket();
                    Navigator.pop(context);
                    return false;
                  },
                  child: Scaffold(
                    backgroundColor: ColorManager.background,
                    appBar: CustomAppBar(
                      title: state.phoneNumber == 'رقم هاتف العميل' ?'رقم هاتف العميل' :  state.phoneNumber.length >= 8
                          ? state.phoneNumber.replaceRange(0, 8, '########')
                          : state.phoneNumber,
                      centerTitle: true,
                      titleColor: ColorManager.white,
                      leading: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(AppMargin.m4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppSizeHeight.s50,
                          ),
                          color: ColorManager.grey,
                        ),
                        child: IconButton(
                          onPressed: () {
                            SocketService().closeSocket();
                            Navigator.pop(context);
                          },

                          icon: Icon(
                            Icons.arrow_back,
                            color: ColorManager.white,
                          ),
                        ),
                      ),
                    ),
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildGarageInfoCard(
                            state.data!.garageName,
                            state.data!.spots,
                            context,
                            spotName
                          ),
                          _buildVehicleTypeSelector(context),
                          _buildQrSection(context, state.data!.qr),
                          _buildImageCaptureSection(context),
                          SizedBox(height: AppSizeHeight.s10),
                          BlocBuilder<OrderBloc, OrderState>(
                            builder: (context, state) {
                              return CustomButton(
                                onTap: () async {
                                  if (state.selectedVehicleType != null &&
                                      spotId != null &&
                                      state.phoneNumber != 'رقم هاتف العميل') {
                                    File? carImage;
                                    if (state.image != null) {
                                      carImage = state.image;
                                    }

                                    final model = StoreOrderModel(
                                      carImageFile: carImage,
                                      spotId: spotId,
                                      carType: state.selectedVehicleType.index,
                                      ClientNumber: state.phoneNumber,
                                      garageId: state.data!.garageId,
                                    );

                                    context.read<OrderBloc>().add(
                                      StoreOrderEvent(model),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainScreen(),
                                      ),
                                    );
                                  } else {
                                    if(state.phoneNumber == 'رقم هاتف العميل'){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content:
                                          TextUtils(
                                            text: 'برجاء الطلب من العميل عمل مسح للـ QR.',
                                            color: ColorManager.primary,
                                            fontSize: FontSize.s13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: TextUtils(
                                            text: 'نأسف و لكن يوجد خطأ بالبيانات.',
                                            color: ColorManager.primary,
                                            fontSize: FontSize.s13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                btnColor: ColorManager.primary,
                                shadowColor: ColorManager.white,
                                width: MediaQuery.of(context).size.width * .9,
                                radius: AppSizeHeight.s10,
                                borderColor: ColorManager.white,
                                elevation: 5,
                                widget: switch (state.storeOrderState) {
                                  StoreOrderState.initial => TextUtils(
                                    text: "تفعيل الطلب",
                                    color: ColorManager.background,
                                    fontSize: FontSize.s17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  StoreOrderState.loading =>
                                    CircularProgressIndicator(
                                      color: ColorManager.white,
                                    ),
                                  StoreOrderState.loaded => TextUtils(
                                    text: "تفعيل الطلب",
                                    color: ColorManager.primary,
                                    fontSize: FontSize.s17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  StoreOrderState.error => TextUtils(
                                    text: "تفعيل الطلب",
                                    color: ColorManager.primary,
                                    fontSize: FontSize.s17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                },
                              );
                            },
                          ),
                          SizedBox(height: AppSizeHeight.s20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            case RequestState.error:
              return Container(
                height: 190.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextUtils(text: "Error happened in defaultOrderState"),
              );
          }
        },
      ),
    );
  }

  /// widgets
  Widget _buildGarageInfoCard(
      String garage,
      List<Spot> spots,
      BuildContext context,
      String selectedSpotName,
      ) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppMargin.m16,
        vertical: AppMargin.m10,
      ),
      color: ColorManager.grey,
      elevation: 5,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizeHeight.s10),
      ),
      child: Column(
        children: [
         // جراج
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(top: AppMargin.m16, right: AppMargin.m24),
            padding: EdgeInsets.only(right: AppPadding.p5),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: ColorManager.primary, width: 3),
              ),
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
                    text: garage,
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

          // الباكية - Dropdown
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(
              bottom: AppMargin.m16,
              right: AppMargin.m24,
              top: AppMargin.m10,
            ),
            padding: EdgeInsets.only(right: AppPadding.p5),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: ColorManager.primary, width: 3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'بالباكية : ',
                  style: GoogleFonts.cairo(
                    color: ColorManager.white,
                    fontSize: FontSize.s17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: AppSizeWidth.s70,
                  child: DropdownButton<String>(
                    value: selectedSpotName,
                    isExpanded: true,
                    underline: Container(
                      height: AppSizeHeight.s2,
                      color: ColorManager.primary,
                    ),
                    icon: Icon(Icons.arrow_drop_down, color: ColorManager.primary),
                    style: GoogleFonts.cairo(
                      color: ColorManager.primary,
                      fontSize: FontSize.s15,
                      fontWeight: FontWeight.bold,
                    ),
                    items: spots.map((spot) {
                      return DropdownMenuItem<String>(

                        value: spot.code,
                        child: TextUtils(text:  spot.code,color: ColorManager.primary,fontSize: FontSize.s15,fontWeight: FontWeightManager.bold,),
                      );
                    }).toList(),
                    dropdownColor: ColorManager.grey,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<OrderBloc>().add(UpdateSpotNameEvent(value));
                      }
                    },
                  ),
                )


              ],
            ),

          ),
        ],
      ),
    );
  }

}
Widget _buildVehicleTypeSelector(BuildContext context) {
  return Card(
    margin: EdgeInsets.symmetric(
      horizontal: AppMargin.m16,
      vertical: AppMargin.m10,
    ),
    color: ColorManager.grey,
    elevation: 5,
    shadowColor: ColorManager.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizeHeight.s10),
    ),
    child: Column(
      children: [
        Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(
            bottom: AppMargin.m16,
            top: AppMargin.m16,
            right: AppMargin.m24,
          ),
          padding: EdgeInsets.only(right: AppPadding.p5),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: ColorManager.primary, width: 3),
            ),
          ),
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
                children:
                    VehicleType.values.map((type) {
                      final icon = _getVehicleIcon(type);
                      final isSelected = state.selectedVehicleType == type;
                      return GestureDetector(
                        onTap: () {
                          context.read<OrderBloc>().add(
                            SelectVehicleType(type),
                          );
                        },
                        child: Column(
                          children: [
                            Icon(
                              icon,
                              color:
                                  isSelected
                                      ? ColorManager.primary
                                      : ColorManager.white,
                              size: 30,
                            ),
                            Text(
                              type.name,
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? ColorManager.primary
                                        : ColorManager.white,
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

Widget _buildQrSection(BuildContext context, String qr) {
  String base64String = qr.replaceFirst('data:image/png;base64,', '');
  Uint8List qrBytes = base64Decode(base64String);

  return Card(
    margin: EdgeInsets.symmetric(
      horizontal: AppMargin.m16,
      vertical: AppMargin.m10,
    ),
    color: ColorManager.grey,
    elevation: 5,
    shadowColor: ColorManager.white,
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
            border: Border(
              right: BorderSide(color: ColorManager.primary, width: 3),
            ),
          ),
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
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(AppSizeHeight.s10),
              ),
              border: Border.all(width: 5, color: ColorManager.primary),
            ),
            child: Image.memory(qrBytes),
          ),
        ),
      ],
    ),
  );
}

Widget _buildImageCaptureSection(BuildContext context) {
  return Card(
    margin: EdgeInsets.symmetric(
      horizontal: AppMargin.m16,
      vertical: AppMargin.m10,
    ),
    color: ColorManager.grey,
    elevation: 5,
    shadowColor: ColorManager.white,
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
            border: Border(
              right: BorderSide(color: ColorManager.primary, width: 3),
            ),
          ),
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
                  child:
                      image != null
                          ? GestureDetector(
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            FullScreenImage(imageFile: image),
                                  ),
                                ),
                            child: PhotoView(
                              imageProvider: FileImage(image),
                              backgroundDecoration: BoxDecoration(
                                color: ColorManager.background,
                              ),
                            ),
                          )
                          : Icon(
                            Icons.image,
                            size: AppSizeHeight.s100,
                            color: ColorManager.primary,
                          ),
                ),
                Positioned(
                  bottom: AppSizeHeight.s15,
                  right: AppSizeHeight.s15,
                  child: IconButton(
                    onPressed: () {
                      context.read<OrderBloc>().add(PickImageEvent());
                    },

                    icon: Icon(
                      Icons.camera_alt,
                      size: AppSizeHeight.s30,
                      color: ColorManager.primary,
                    ),
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

IconData _getVehicleIcon(VehicleType type) {
  switch (type) {
    case VehicleType.Car:
      return Icons.directions_car;
    case VehicleType.Motorcycle:
      return Icons.motorcycle;
    case VehicleType.Bicycle:
      return Icons.directions_bike;
    case VehicleType.Truck:
      return Icons.local_shipping;
    case VehicleType.Bus:
      return Icons.directions_bus;
  }
}

