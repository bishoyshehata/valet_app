import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:valet_app/core/utils/enums.dart';
import 'package:valet_app/valete/domain/entities/spot.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_bloc.dart';
import 'package:valet_app/valete/presentation/resources/assets_manager.dart';
import 'package:valet_app/valete/presentation/resources/strings_manager.dart';
import 'package:valet_app/valete/presentation/screens/order_details/order_details.dart';
import '../../../../core/l10n/app_locale.dart';
import '../../components/text/text_utils.dart';
import '../../controllers/home/home_events.dart';
import '../../controllers/home/home_states.dart';
import '../../resources/colors_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';
import '../../components/custom_app_bar.dart';
import '../error_screen/non_scaffold_error_screen.dart';


class GarageScreen extends StatelessWidget {
  final int garageId;
  final String garageName;

  GarageScreen({super.key, required this.garageId, required this.garageName});
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return Directionality(
      textDirection: locale.languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: BlocListener<HomeBloc, HomeState>(
        listenWhen: (prev, curr) =>
        prev.updateOrderSpotState != curr.updateOrderSpotState || prev.cancelOrderState !=curr.cancelOrderState,
        listener: (context, state) {
          if (state.updateOrderSpotState == UpdateOrderSpotState.loaded ||state.cancelOrderState == UpdateOrderState.loaded) {
            context.read<HomeBloc>().add(GetGarageSpotEvent(garageId));
            print("✅ Spot updated, fetching new spots...");
          }
        },
        child: BlocBuilder<HomeBloc,HomeState>(
          builder:(context, state) {
              switch(state.getGaragesSpotState){
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
                      separatorBuilder:
                          (context, index) => SizedBox(height: 10),
                      itemCount: 4,
                    ),
                  );

                case RequestState.loaded:
                  return Scaffold(
                    backgroundColor: ColorManager.background,
                    appBar: CustomAppBar(
                      title:garageName,
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

                      builder: (context, state) {

                        switch (state.getGaragesSpotState) {
                          case RequestState.loading:
                            return SizedBox(
                              height: AppSizeHeight.sMaxInfinite,
                              child: Center(child: Lottie.asset(LottieManager.carLoading)),
                            );
                          case RequestState.loaded:
                            if (state.mainSpots!.isEmpty) {
                              return Center(
                                child: TextUtils(
                                  text: AppLocalizations.of(context)!.garageDataUnavailable,
                                  color: ColorManager.white,
                                ),
                              );
                            }
                            final extraSpots = state.extraSpots;
                            final mainSpots = state.mainSpots;
                            return CustomScrollView(
                              slivers: [
                                // --- مفتاح عرض/إخفاء المواقف الإضافية ---
                                // نعرض المفتاح فقط إذا كان هناك مواقف إضافية في هذا الجراج
                                if (extraSpots!.isNotEmpty)
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextUtils(
                                            text:
                                            state.showExtraSlots
                                                ? AppLocalizations.of(context)!.hideAdditionalSpots
                                                : AppLocalizations.of(context)!.showAdditionalSpots,
                                            color: ColorManager.white,
                                            fontSize: FontSize.s17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          Switch(
                                            value: state.showExtraSlots,
                                            // استخدام الحالة العامة للتبديل
                                            activeColor: ColorManager.primary,
                                            onChanged: (bool value) {
                                              context.read<HomeBloc>().add(
                                                ToggleExtraSlotsVisibilityEvent(value),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                // --- عرض المواقف الإضافية (إذا كانت الحالة تسمح وهناك مواقف إضافية) ---
                                if (state.showExtraSlots ) ...[
                                  SliverPadding(
                                    padding: EdgeInsets.all(AppPadding.p10),
                                    sliver: SliverGrid(
                                      delegate: SliverChildBuilderDelegate(
                                            (context, index) {

                                          return MiniParkingSlotWidget(
                                            spot: extraSpots[index],
                                            garageId: garageId,
                                            spotindex: index,
                                            garageName: garageName,// ← index الأصلي من كل المواقف
                                          );
                                        },
                                        childCount: extraSpots.length,
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    child: TextUtils(
                                      text: AppLocalizations.of(context)!.mainGarage,
                                      color: ColorManager.white,
                                      fontSize: FontSize.s17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                mainSpots!.isNotEmpty
                                    ? SliverPadding(
                                  padding: EdgeInsets.all(12),
                                  sliver: SliverGrid(
                                    delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                        final locale = Localizations.localeOf(context);
                                        final spot =
                                        mainSpots[index];
                                        final isLeftSide = index % 2 == 0;
                                        return ParkingSlotWidget(
                                          isLeftSide: locale.languageCode == 'en' ?  isLeftSide : !isLeftSide,
                                          garageId: garageId,
                                          spotindex: index,
                                          status: spot.status,
                                          spot: spot,
                                          garageName: garageName,
                                        );
                                      },
                                      childCount:
                                      mainSpots
                                          .length, // استخدام قائمة المواقف الرئيسية *لهذا الجراج*
                                    ),
                                    gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 0,
                                      mainAxisExtent: 105,
                                    ),
                                  ),
                                )
                                    : SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Center(child: Lottie.asset(LottieManager.noCars)),
                                      TextUtils(
                                        text: AppLocalizations.of(context)!.noCarsInGarage,
                                        color: ColorManager.white,
                                        fontSize: FontSize.s13,
                                        noOfLines: 2,
                                        overFlow: TextOverflow.ellipsis,
                                      ),
                                    ],
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
                                  text: state.getGaragesSpotErrorMessage,
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
                  );
                case RequestState.error:
                  return buildNonScaffoldErrorBody(context, state.getGaragesSpotStatusCode , state.getGaragesSpotErrorMessage);
              }
          } ,
        ),
      ),
    );
  }
}

class ParkingSlotWidget extends StatelessWidget {
  final Spot spot;
  final int spotindex;
  final int garageId;
  final bool isLeftSide;
  final int status;
  final String garageName;

  const ParkingSlotWidget({
    super.key,
    required this.spot,
    required this.spotindex,
    required this.isLeftSide,
    required this.status,
    required this.garageId, required this.garageName,
  });

  @override
  Widget build(BuildContext context) {

    final isBusy = spot.hasOrder;
    return InkWell(
      onTap: () {
        if (spot.hasOrder == true ) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider.value(
                    value: context.read<HomeBloc>(),
                    child: OrderDetails(
                      spotId: spot.id,

                      garageName: garageName,
                    ),
                  ),
            ),
          );
        } else {
          print(spot.id);
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
                  isLeftSide ? Colors.transparent : ColorManager.primary,
                  ColorManager.primary,
                  isLeftSide ? ColorManager.primary : Colors.transparent,
                ],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstIn,

            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  // هنا من غير أي علاقة بـ locale
                  right: isLeftSide ? BorderSide(width: 1, color: ColorManager.primary) : BorderSide.none,
                  left: !isLeftSide ? BorderSide(width: 1, color: ColorManager.primary) : BorderSide.none,
                  top: BorderSide(width: 1, color: ColorManager.primary),
                  bottom: BorderSide(width: 1, color: ColorManager.primary),
                ),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.all(5),
            color:
            isBusy== true
                    ? ColorManager.primary
                    : ColorManager.background,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextUtils(
                    text: spot.code,
                    color:
                    isBusy== true
                            ? ColorManager.background
                            : ColorManager.white,
                    fontSize: FontSize.s15,
                    fontWeight: FontWeight.bold,
                  ),
                  (spot.hasOrder== true )
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
  final int spotindex;
  final int garageId;
  final String garageName;
  const MiniParkingSlotWidget({super.key, required this.spot, required this.spotindex, required this.garageId,required this.garageName});

  @override
  Widget build(BuildContext context) {
    bool isBusy = spot.hasOrder== true;

    return InkWell(
      onTap: () {
        if (spot.hasOrder== true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider.value(
                value: context.read<HomeBloc>(),
                child: OrderDetails(
                  spotId: spot.id,
                    garageName : garageName
                ),
              ),
            ),
          );
        } else {
          print(spot.status);
        }
        print(spot.id);
      },
      child: Card(
        color: isBusy ? ColorManager.primary : ColorManager.darkGrey,
        child: Container(

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
                spot.hasOrder== true
                    ? buildCarTypeImage(spot.order!.carType)
                    : Icon(
                      Icons.local_parking,
                      color:
                          isBusy ? ColorManager.background : ColorManager.primary,
                      // تغيير لون الأيقونة
                      size: AppSizeHeight.s25,
                    ),
              ],
            ),
          ),
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
      return Image.asset(AssetsManager.motorcycle, height: AppSizeHeight.s40);
    case 2:
      return Image.asset(AssetsManager.truck, height: AppSizeHeight.s40);
    case 3:
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
      return AssetsManager.motorcycle;
    case 2:
      return AssetsManager.truck;
    case 3:
      return AssetsManager.van;
    default:
      return AssetsManager.appIcon;
  }
}
