import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/valete/data/datasource/socket/socket_manager.dart';
import 'package:valet_app/valete/domain/usecases/create_order_use_case.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import 'package:valet_app/valete/presentation/resources/values_manager.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/enums.dart';
import '../../../domain/entities/spot.dart';
import '../../components/text/text_utils.dart';
import '../../components/custom_app_bar.dart';
import '../../components/custom_bottun.dart';
import '../../controllers/orders/order_bloc.dart';
import '../../controllers/orders/order_events.dart';
import '../../controllers/orders/order_states.dart';
import '../../resources/font_manager.dart';
import '../garage_screen/garage_screen.dart';
import 'image_full_screen.dart';
import 'package:shimmer/shimmer.dart';

class OrderScreen extends StatelessWidget {
  final SocketService socketService = SocketService();

   OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderBloc>(
      create: (context) {
        final bloc = OrderBloc(sl<CreateOrderUseCase>())..add(CreateOrderEvent());

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
        buildWhen: (previous, current) =>
        previous.createOrderState != current.createOrderState ||
            previous.phoneNumber != current.phoneNumber ||
            previous.spotName != current.spotName,
        builder: (context, state) {
          switch (state.createOrderState) {
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
                          height: 190.0,
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
              final spotName = state.spotName == 'رقم الباكية' ? state.data!.spotName : state.spotName;

              return Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  backgroundColor: ColorManager.background,
                  appBar: CustomAppBar(
                            actions: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: ColorManager.primary,
                                ),
                              ),
                            ],
                            title: state.phoneNumber,
                            centerTitle: true,
                            titleColor: ColorManager.white,
                            leading: Icon(
                              Icons.edit_note,
                              color: ColorManager.primary,
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
                            print(
                              "ssssssssssssssssssssssssssssssssssssssss${state.createOrderState}",
                            );
                            return CustomButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GarageScreen(),
                                  ),
                                );
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
                            );
                          },
                        ),
                        SizedBox(height: AppSizeHeight.s20),
                      ],
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
                child: TextUtils(text: "Error happened in createOrderState"),
              );
          }
        },
      ),
    );
  }

  /// widgets

  Widget _buildGarageInfoCard(String garage, List<Spot> spots, BuildContext context, String selectedSpotName) {
    return Card(
      child: Column(
        children: [
          // اسم الجراج
          Text("التوجه إلى جراج: $garage"),

          // اسم الباكية + زر تعديل
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("بالباكية: $selectedSpotName"),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _showSpotDialog(context, spots),
              )
            ],
          )
        ],
      ),
    );
  }
}

  // Widget _buildGarageInfoCard(String garage, String spot) {
  //   return Card(
  //     margin: EdgeInsets.symmetric(
  //       horizontal: AppMargin.m16,
  //       vertical: AppMargin.m10,
  //     ),
  //     color: ColorManager.darkPrimary,
  //     elevation: 5,
  //     shadowColor: ColorManager.white,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(AppSizeHeight.s10),
  //     ),
  //     child: Column(
  //       children: [
  //         Container(
  //           alignment: Alignment.centerRight,
  //           margin: EdgeInsets.only(top: AppMargin.m10, right: AppMargin.m24),
  //           padding: EdgeInsets.only(right: AppPadding.p5),
  //           decoration: BoxDecoration(
  //             border: Border(
  //               right: BorderSide(color: ColorManager.primary, width: 3),
  //             ),
  //           ),
  //           child: RichText(
  //             text: TextSpan(
  //               children: [
  //                 TextSpan(
  //                   text: "التوجه إلى جراج : ",
  //                   style: TextStyle(
  //                     color: ColorManager.white,
  //                     fontSize: FontSize.s17,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 TextSpan(
  //                   text: garage,
  //                   style: TextStyle(
  //                     color: ColorManager.primary,
  //                     fontSize: FontSize.s15,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Container(
  //           alignment: Alignment.centerRight,
  //           margin: EdgeInsets.only(
  //             bottom: AppMargin.m10,
  //             right: AppMargin.m24,
  //           ),
  //           padding: EdgeInsets.only(right: AppPadding.p5),
  //           decoration: BoxDecoration(
  //             border: Border(
  //               right: BorderSide(color: ColorManager.primary, width: 3),
  //             ),
  //           ),
  //           child: RichText(
  //             text: TextSpan(
  //               children: [
  //                 TextSpan(
  //                   text: "بالباكية : ",
  //                   style: TextStyle(
  //                     color: ColorManager.white,
  //                     fontSize: FontSize.s17,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 TextSpan(
  //                   text: spot,
  //                   style: TextStyle(
  //                     color: ColorManager.primary,
  //                     fontSize: FontSize.s15,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildVehicleTypeSelector(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppMargin.m16,
        vertical: AppMargin.m10,
      ),
      color: ColorManager.darkPrimary,
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
      color: ColorManager.darkPrimary,
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
            child: Center(child: Image.memory(qrBytes)),
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
      color: ColorManager.darkPrimary,
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
                              color: ColorManager.white,
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

void _showSpotDialog(BuildContext context, List<Spot> spots) {
  String selected = spots.first.code;

  final orderBloc = context.read<OrderBloc>();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("اختيار الباكية"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButton<String>(
                isExpanded: true,
                value: selected,
                items: spots
                    .map((e) => DropdownMenuItem(value: e.code, child: Text(e.code)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selected = value!;
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                // التأكد من أن الـ event يتم إرساله بشكل صحيح
                orderBloc.add(UpdateSpotNameEvent(selected));
                Navigator.pop(context);
              },
              child: Text("تم"),
            ),
          ],
        );
      },
    );
  });
}

