import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:valet_app/core/utils/enums.dart';
import 'package:valet_app/valete/domain/entities/spot.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_bloc.dart';
import 'package:valet_app/valete/presentation/resources/assets_manager.dart';
import 'package:valet_app/valete/presentation/screens/order_details/order_details.dart';
import '../../components/text/text_utils.dart';
import '../../controllers/home/home_events.dart';
import '../../controllers/home/home_states.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';
import '../../components/custom_app_bar.dart';

// تعريف SpotStatus enum (تأكد من مطابقته للقيم في الـ JSON)

class GarageScreen extends StatelessWidget {
  final int garageIndex;

  GarageScreen({super.key, required this.garageIndex});

  List? extraSlots;

  @override
  Widget build(BuildContext context) {
    print(garageIndex);
    context.read<HomeBloc>().add(GetMyGaragesEvent());
    return Directionality(
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
                if (state.data == null || state.data!.isEmpty || garageIndex >= state.data!.length) {
                  return Center(
                    child: TextUtils(
                      text: 'بيانات الجراج غير متاحة أو الفهرس خاطئ.',
                      color: ColorManager.white,
                    ),
                  );
                }

                // --- الحصول على بيانات الجراج المحدد ---
                final currentGarage = state.data![garageIndex];
                final allSpotsInCurrentGarage = currentGarage.spots;

                // --- فصل المواقف الرئيسية والإضافية *لهذا الجراج فقط* ---
                final mainSpots = allSpotsInCurrentGarage
                    .where((spot) =>
                spot.status != SpotStatus.OverFlowEmpty.index &&
                    spot.status != SpotStatus.OverFlowBusy.index)
                    .toList();

                final extraSpots = allSpotsInCurrentGarage
                    .where((spot) =>
                spot.status == SpotStatus.OverFlowEmpty.index ||
                    spot.status == SpotStatus.OverFlowBusy.index)
                    .toList();

                return CustomScrollView(
                  slivers: [
                    // --- مفتاح عرض/إخفاء المواقف الإضافية ---
                    // نعرض المفتاح فقط إذا كان هناك مواقف إضافية في هذا الجراج
                    if (extraSpots.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextUtils(
                                text: state.showExtraSlots ? 'إخفاء الأماكن الإضافية' : 'عرض الأماكن الإضافية',
                                color: ColorManager.white,
                                fontSize: FontSize.s17,
                                fontWeight: FontWeight.bold,
                              ),
                              Switch(
                                value: state.showExtraSlots, // استخدام الحالة العامة للتبديل
                                activeColor: ColorManager.primary,
                                onChanged: (bool value) {
                                  context.read<HomeBloc>().add(ToggleExtraSlotsVisibilityEvent(value));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                    // --- عرض المواقف الإضافية (إذا كانت الحالة تسمح وهناك مواقف إضافية) ---
                    if (state.showExtraSlots && extraSpots.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          child: TextUtils(
                            text: "الأماكن الإضافية",
                            color: ColorManager.white,
                            fontSize: FontSize.s17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.all(AppPadding.p10),
                        sliver: SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) => MiniParkingSlotWidget(spot: extraSpots[index]),
                            childCount: extraSpots.length, // استخدام قائمة المواقف الإضافية *لهذا الجراج*
                          ),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            mainAxisExtent: 100,
                          ),
                        ),
                      ),
                    ],

                    // --- عرض المواقف الرئيسية ---
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final spot = mainSpots[index]; // استخدام قائمة المواقف الرئيسية *لهذا الجراج*
                            final isLeftSide = index % 2 == 0;
                            // --- تحديد فهرس الموقف الأصلي ضمن قائمة الجراج الكاملة (إذا احتجت إليه) ---
                            // final originalSpotIndex = allSpotsInCurrentGarage.indexWhere((s) => s.id == spot.id);
                            return ParkingSlotWidget(
                              isLeftSide: isLeftSide,
                              // نمرر فهرس الموقف ضمن قائمة mainSpots الحالية
                              // أو يمكنك تمرير spot.id إذا كان هذا أفضل للاستخدام لاحقاً
                              spotindex: index,
                              garageindex: garageIndex, // فهرس الجراج الحالي
                              status: spot.status,
                              spot: spot,
                            );
                          },
                          childCount: mainSpots.length, // استخدام قائمة المواقف الرئيسية *لهذا الجراج*
                        ),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 0,
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
    );
  }
}

class ParkingSlotWidget extends StatelessWidget {
  final Spot spot;
  final int spotindex;
  final int garageindex;
  final bool isLeftSide;
  final int status;

  const ParkingSlotWidget({
    super.key,
    required this.spot,
    required this.spotindex,
    required this.garageindex,
    required this.isLeftSide,
    required this.status,
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
        } else {
          print(status);
        }
      },
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  isLeftSide ? ColorManager.primary : Colors.transparent,
                  ColorManager.primary,
                  isLeftSide ? Colors.transparent : ColorManager.primary,
                ],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right:
                      isLeftSide
                          ? BorderSide(width: 0)
                          : BorderSide(width: 1, color: ColorManager.primary),
                  bottom: BorderSide(width: 1, color: ColorManager.primary),
                  top: BorderSide(
                    width: 1,
                    color: ColorManager.primary,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            color:
                status == SpotStatus.Busy.index
                    ? ColorManager.primary
                    : ColorManager.background,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextUtils(
                    text: spot.code,
                    color:
                        status == SpotStatus.Busy.index
                            ? ColorManager.background
                            : ColorManager.white,
                    fontSize: FontSize.s15,
                    fontWeight: FontWeight.bold,
                  ),
                  (spot.order != null)
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
    // تحديد ما إذا كان الموقف الإضافي مشغولاً أم فارغاً
    bool isBusy = spot.status == SpotStatus.OverFlowBusy.index;

    return Card(
      color: isBusy ? ColorManager.primary : ColorManager.darkGrey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextUtils(
              text: spot.code,
              color: isBusy ? ColorManager.background : ColorManager.white,
              fontSize: FontSize.s15,
              fontWeight: FontWeight.bold,
            ),
            spot.order != null // تأكد من وجود بيانات الطلب قبل عرض السيارة
                ? buildCarTypeImage(spot.order!.carType)
                : Icon(
              Icons.local_parking,
              color: isBusy ? ColorManager.background : ColorManager.primary, // تغيير لون الأيقونة
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
      return Image.asset(AssetsManager.car, height: AppSizeHeight.s40);
    case 1:
      return Image.asset(AssetsManager.bicycle, height: AppSizeHeight.s40);
    case 2:
      return Image.asset(AssetsManager.motorcycle, height: AppSizeHeight.s40);
    case 3:
      return Image.asset(AssetsManager.truck, height: AppSizeHeight.s40);
    case 4:
      return Image.asset(AssetsManager.van, height: AppSizeHeight.s40);
    default:
      return Icon(
        Icons.directions_car,
        color: Colors.grey,
        size: AppSizeHeight.s25,
      );
  }
}

String buildCarTypeImageForStatus(int carType) {
  switch (carType) {
    case 0:
      return AssetsManager.car;
    case 1:
      return AssetsManager.bicycle;
    case 2:
      return AssetsManager.motorcycle;
    case 3:
      return AssetsManager.truck;
    case 4:
      return AssetsManager.van;
    default:
      return AssetsManager.appIcon;
  }
}
