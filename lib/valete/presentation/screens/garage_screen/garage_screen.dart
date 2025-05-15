import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:valet_app/core/utils/enums.dart';
import 'package:valet_app/valete/domain/entities/spot.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_bloc.dart';
import 'package:valet_app/valete/presentation/resources/assets_manager.dart';
import 'package:valet_app/valete/presentation/screens/order_details/order_details.dart';
import '../../components/text/text_utils.dart';
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.background,
        appBar: CustomAppBar(
         leading:  IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: ColorManager.primary,
            ),
          ),
          title: "موقف السيارات",
          centerTitle: true,
          titleColor: ColorManager.white,
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          // buildWhen:
          //     (previous, current) =>
          //         previous.myGaragesState != current.myGaragesState,
          builder: (context, state) {
            switch (state.myGaragesState) {
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
                          // print("aaaaaaaa${state.data![0].spots[index].order}");
                          return ParkingSlotWidget(
                            spotindex: index,
                            garageindex: garageIndex,
                            spot: state.data![garageIndex].spots[index],
                          );
                        }, childCount: state.data![garageIndex].capacity),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              mainAxisExtent: 100,
                            ),
                      ),
                    ),
                  ],
                );

              case RequestState.error:
                // TODO: Handle this case.
                throw UnimplementedError();
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
  const ParkingSlotWidget({super.key, required this.spot ,required this.spotindex, required this.garageindex});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => BlocProvider.value(
                  value: context.read<HomeBloc>(),
                  child: OrderDetails(spotIndex:spotindex,garageIndex: garageindex ,),
                ),
          ),
        );
      },
      child: Card(
        color:
            spot.order != null
                ? ColorManager.primary
                : ColorManager.darkGrey, // تغيير اللون حسب حالة الإشغال
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // عرض الاسم
              TextUtils(
                text: spot.code,
                color:
                    spot.order != null
                        ? ColorManager.darkPrimary
                        : ColorManager.white,
                fontSize: FontSize.s15,
                fontWeight: FontWeight.bold,
              ),

              spot.order != null
                  ? buildCarTypeImage(spot.order!.carType)
                  : Icon(
                    Icons.local_parking,
                    color: Colors.cyanAccent,
                    size: AppSizeHeight.s25,
                  ),
            ],
          ),
        ),
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
                      ? ColorManager.darkPrimary
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
      return Image.asset(
        AssetsManager.car,
        height: AppSizeHeight.s45,
      );
    case 1:
      return Image.asset(
        AssetsManager.bicycle,
        height: AppSizeHeight.s45,
      );
    case 2:
      return Image.asset(
        AssetsManager.motorcycle,
        height: AppSizeHeight.s45,
      );
      case 3:
      return Image.asset(
        AssetsManager.truck,
        height: AppSizeHeight.s45,
      );
      case 4:
      return Image.asset(
        AssetsManager.van,
        height: AppSizeHeight.s45,
      );
    default:
      return Icon(
        Icons.directions_car,
        color: Colors.grey,
        size: AppSizeHeight.s25,
      );
  }
}
