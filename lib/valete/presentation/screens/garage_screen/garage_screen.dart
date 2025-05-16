import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:valet_app/core/utils/enums.dart';
import 'package:valet_app/valete/domain/entities/spot.dart';
import 'package:valet_app/valete/domain/usecases/my_garages_use_case.dart';
import 'package:valet_app/valete/domain/usecases/my_orders_use_case.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_bloc.dart';
import 'package:valet_app/valete/presentation/resources/assets_manager.dart';
import 'package:valet_app/valete/presentation/screens/order_details/order_details.dart';
import '../../../../core/services/services_locator.dart';
import '../../components/text/text_utils.dart';
import '../../controllers/home/home_events.dart';
import '../../controllers/home/home_states.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';
import '../../components/custom_app_bar.dart';

class GarageScreen extends StatelessWidget {
  final int garageIndex;

  const GarageScreen({super.key, required this.garageIndex});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => HomeBloc(sl<MyGaragesUseCase>(),sl<MyOrdersUseCase>())..add(GetMyGaragesEvent()),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: ColorManager.background,
          appBar: CustomAppBar(
            title: 'موقف السيارات',
            centerTitle: true,
            titleColor: ColorManager.white,
            leading: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(AppMargin.m4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizeHeight.s50),
                color: ColorManager.grey,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                icon: Icon(Icons.arrow_back, color: ColorManager.white),
              ),
            ),
          ),
          body: BlocBuilder<HomeBloc, HomeState>(
            // buildWhen:
            //     (previous, current) =>
            //         previous.data != current.data,
            builder: (context, state) {
              switch (state.myGaragesState) {
                case RequestState.loading:
                  return SizedBox(
                    height: AppSizeHeight.sMaxInfinite,
                    child: Center(child: Lottie.asset(LottieManager.carLoading)),
                  );
                case RequestState.loaded:
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextUtils(
                                text:
                                    // state.showExtraSlots ? 'إخفاء الأماكن الإضافية' :
                                    'عرض الأماكن الإضافية',
                                color: ColorManager.white,
                                fontSize: FontSize.s17,
                                fontWeight: FontWeight.bold,
                              ),

                              Switch(
                                value: false,
                                activeColor: ColorManager.primary,
                                onChanged: (bool value) {},
                              ),
                            ],
                          ),
                        ),
                      ),

                      // if (state.showExtraSlots) ...[
                      //
                      //   SliverPadding(
                      //     padding: EdgeInsets.all(AppPadding.p10),
                      //     sliver: SliverGrid(
                      //       delegate: SliverChildBuilderDelegate(
                      //             (context, index) => MiniParkingSlotWidget(spot: state.extraSlots[index]),
                      //         childCount: state.extraSlots.length,
                      //       ),
                      //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      //         crossAxisCount: 4,
                      //         crossAxisSpacing: 12,
                      //         mainAxisSpacing: 12,
                      //         mainAxisExtent: 100,
                      //       ),
                      //     ),
                      //   ),
                      // ],
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: TextUtils(
                            text: "الجراج الرئيسي",
                            color: ColorManager.white,
                            fontSize: FontSize.s17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SliverPadding(
                        padding: EdgeInsets.all(12),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            final isLeftSide = index % 2 == 0;

                            return ParkingSlotWidget(
                              isLeftSide: isLeftSide,
                              spotindex: index,
                              garageindex: garageIndex,
                              spot: state.data![garageIndex].spots[index],
                            );
                          }, childCount: state.data![garageIndex].spots.length),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing:0,
                                mainAxisSpacing: 0,
                                mainAxisExtent: 105,
                              ),
                        ),
                      ),
                    ],
                  );
                case RequestState.error:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: Lottie.asset(LottieManager.noCars)),
                      TextUtils(
                        text: "يوجد خطب ما بالجراج وجارى إصلاحه",
                        color: ColorManager.white,
                        fontSize: FontSize.s13,
                        noOfLines: 2,
                        overFlow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ParkingSlotWidget extends StatelessWidget {
  final Spot spot;
  final int spotindex;
  final int garageindex;
  final bool isLeftSide;

  const ParkingSlotWidget({
    super.key,
    required this.spot,
    required this.spotindex,
    required this.garageindex,
    required this.isLeftSide,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (spot.order != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider.value(
                    value: context.read<HomeBloc>(),
                    child: OrderDetails(
                      spotIndex: spotindex,
                      garageIndex: garageindex,
                    ),
                  ),
            ),
          );
        } else {}
      },
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [isLeftSide ? ColorManager.primary: Colors.transparent, ColorManager.primary ,isLeftSide ? Colors.transparent:  ColorManager.primary],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right:isLeftSide
                      ? BorderSide(width: 0)
                      :  BorderSide(width: 1, color: ColorManager.primary),
                          bottom: BorderSide(width: 1, color: ColorManager.primary),
                          top: BorderSide(width: 1, color: ColorManager.primary,style: BorderStyle.solid),
                ),
              ),

            ),

          ),
          Container(
            margin: EdgeInsets.all(5),
            color: spot.order != null
                ? ColorManager.primary
                : ColorManager.background, // تغيير اللون حسب حالة الإشغال
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // عرض الاسم
                  TextUtils(
                    text: spot.code,
                    color: spot.order != null
                        ? ColorManager.background
                        : ColorManager.white,
                    fontSize: FontSize.s15,
                    fontWeight: FontWeight.bold,
                  ),

                  spot.order != null
                      ? buildCarTypeImage(spot.order!.carType)
                      : Icon(
                    Icons.local_parking,
                    color: ColorManager.primary,
                    size: AppSizeHeight.s25,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            color: spot.order != null
                ? ColorManager.primary
                : ColorManager.background, // تغيير اللون حسب حالة الإشغال
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // عرض الاسم
                  TextUtils(
                    text: spot.code,
                    color: spot.order != null
                        ? ColorManager.background
                        : ColorManager.white,
                    fontSize: FontSize.s15,
                    fontWeight: FontWeight.bold,
                  ),

                  spot.order != null
                      ? buildCarTypeImage(spot.order!.carType)
                      : Icon(
                    Icons.local_parking,
                    color: ColorManager.primary,
                    size: AppSizeHeight.s25,
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class MiniParkingSlotWidget extends StatelessWidget {
  final Spot spot;

  const MiniParkingSlotWidget({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: spot.order != null ? ColorManager.primary : ColorManager.darkGrey,
      // تغيير اللون حسب حالة الإشغال
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // عرض الاسم
            TextUtils(
              text: spot.code,
              color:
                  spot.order != null
                      ? ColorManager.primary
                      : ColorManager.white,
              fontSize: FontSize.s15,
              fontWeight: FontWeight.bold,
            ),

            // عرض صورة السيارة إذا كان spot مشغول
            spot.order != null
                ? Image.asset(
                  AssetsManager.car, // استبدل بالمسار الصحيح لصورة السيارة
                  height: AppSizeHeight.s35,
                )
                : Icon(
                  Icons.local_parking,
                  color: Colors.cyanAccent,
                  size: AppSizeHeight.s25,
                ),
          ],
        ),
      ),
    );
  }
}

Widget buildCarTypeImage(int carType) {
  switch (carType) {
    case 0:
      return Image.asset(AssetsManager.car, height: AppSizeHeight.s45);
    case 1:
      return Image.asset(AssetsManager.bicycle, height: AppSizeHeight.s45);
    case 2:
      return Image.asset(AssetsManager.motorcycle, height: AppSizeHeight.s45);
    case 3:
      return Image.asset(AssetsManager.truck, height: AppSizeHeight.s45);
    case 4:
      return Image.asset(AssetsManager.van, height: AppSizeHeight.s45);
    default:
      return Icon(
        Icons.directions_car,
        color: Colors.grey,
        size: AppSizeHeight.s25,
      );
  }
}
