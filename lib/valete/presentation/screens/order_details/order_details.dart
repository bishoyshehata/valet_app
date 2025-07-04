import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:valet_app/core/network/api_constants.dart';
import 'package:valet_app/core/utils/enums.dart';
import 'package:valet_app/valete/presentation/components/custom_bottun.dart';
import 'package:valet_app/valete/presentation/controllers/myorders/my_orders_states.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import 'package:valet_app/valete/presentation/resources/values_manager.dart';
import '../../../../core/l10n/app_locale.dart';
import '../../../domain/entities/spot.dart';
import '../../components/alert_dialog.dart';
import '../../components/custom_app_bar.dart';
import '../../components/text/text_utils.dart';
import '../../controllers/home/home_bloc.dart';
import '../../controllers/home/home_events.dart';
import '../../controllers/home/home_states.dart';
import '../../controllers/myorders/my_orders_bloc.dart';
import '../../controllers/myorders/my_orders_events.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/strings_manager.dart';
import '../garage_screen/garage_screen.dart';
import '../valet_home/order_status/orders_status.dart';
import '../valet_home/valet_main.dart';
import 'order_full_screen.dart';
import 'package:collection/collection.dart';

class OrderDetails extends StatelessWidget {
  final int spotId;
  final String garageName;
  Spot? newSpot;

  OrderDetails({super.key, required this.spotId, required this.garageName});

  Spot? findSpotById(HomeState state, int id) {
    return [
      ...?state.allSpots?.mainSpots,
      ...?state.allSpots?.extraSpots,
      ...?state.allSpots?.emptySpots,
    ].firstWhereOrNull((s) => s.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        switch (state.getGaragesSpotState) {
          case RequestState.loading:
            return Lottie.asset(LottieManager.carLoading);
          case RequestState.loaded:
            final garages = state.data;
            final garageNamesList =
                garages?.map((garage) {
                  return {'id': garage.id.toString(), 'name': garage.name};
                }).toList();

            String? selectedGarageId;
            if (garageNamesList != null && state.garageId != 'رقم الباكية') {
              final exists = garageNamesList.any(
                (garage) => garage['id'] == state.garageId.toString(),
              );
              if (exists) {
                selectedGarageId = state.garageId.toString();
              }
            }
            final emptySpotCodes =
                state.emptySpots?.map((s) => s.code).toList() ?? [];

            String? dropdownValue =
                (state.spotName != 'رقم الباكية' &&
                        emptySpotCodes.contains(state.spotName))
                    ? state.spotName
                    : null;

            if (dropdownValue != null) {
              newSpot = [
                ...?state.allSpots?.mainSpots,
                ...?state.allSpots?.extraSpots,
                ...?state.allSpots?.emptySpots,
              ].firstWhereOrNull((spot) => spot.code == dropdownValue);
            }

            final locale = Localizations.localeOf(context);
            return Directionality(
              textDirection:
                  locale.languageCode == 'ar'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
              child: WillPopScope(
                onWillPop: () async {
                  context.read<HomeBloc>().add(ResetSpotNameEvent());
                  return true;
                },
                child: Scaffold(
                  backgroundColor: ColorManager.background,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight),
                    child: BlocBuilder<HomeBloc, HomeState>(
                      buildWhen: (previous, current) => false, // مش محتاج يتغير
                      builder: (context, state) {
                        final spot = findSpotById(state, spotId);

                        return CustomAppBar(
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
                                context.read<HomeBloc>().add(
                                  ResetSpotNameEvent(),
                                );
                                Navigator.pop(context);
                              },

                              icon: Icon(
                                Icons.arrow_back,
                                color: ColorManager.white,
                              ),
                            ),
                          ),
                          actions: [
                            Container(
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
                                  AlertDialogService().showAlertDialog(
                                    context,
                                    title:
                                        AppLocalizations.of(context)!.warning,
                                    message:
                                        AppLocalizations.of(
                                          context,
                                        )!.areYouSureYouWantToCancelOrder,
                                    onPositiveButtonPressed: () {
                                      context.read<HomeBloc>().add(
                                        CancelHomeOrderEvent(spot!.order!.id),
                                      );
                                      context.read<MyOrdersBloc>().add(
                                        GetAllMyOrdersEvent(),
                                      );

                                      Navigator.pop(context);
                                    },
                                  );
                                },
                                icon: Icon(
                                  Icons.delete_forever,
                                  color: ColorManager.white,
                                ),
                              ),
                            ),
                          ],
                          title: spot!.code,
                          centerTitle: true,
                          titleColor: ColorManager.white,
                        );
                      },
                    ),
                  ),

                  body: Container(
                    margin: EdgeInsets.all(AppMargin.m20),
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<HomeBloc, HomeState>(
                            buildWhen: (previous, current) => false,
                            builder: (context, state) {
                              final spot = [
                                ...?state.allSpots?.mainSpots,
                                ...?state.allSpots?.extraSpots,
                                ...?state.allSpots?.emptySpots,
                              ].firstWhereOrNull((s) => s.id == spotId);

                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * .25,
                                width: double.infinity,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: ColorManager.primary,
                                  borderRadius: BorderRadius.circular(
                                    AppSizeHeight.s10,
                                  ),
                                ),
                                child:
                                    spot!.order!.carImage != null
                                        ? GestureDetector(
                                          onTap:
                                              () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (
                                                        _,
                                                      ) => FullScreenNetworkImage(
                                                        imageUrl:
                                                            "${ApiConstants.baseUrl}/${spot.order!.carImage!}",
                                                      ),
                                                ),
                                              ),
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                buildCarTypeImageForStatus(
                                                  spot.order!.carType ?? 0,
                                                ),
                                            // الصورة المؤقتة من الأصول
                                            image: Uri.encodeFull(
                                              "${ApiConstants.baseUrl}/${spot.order!.carImage!}",
                                            ),
                                            height: AppSizeHeight.s100,
                                            width: AppSizeHeight.s100,
                                            fit: BoxFit.cover,
                                            imageErrorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return buildCarTypeImage(
                                                spot.order!.carType,
                                              );
                                            },
                                          ),
                                        )
                                        : buildCarTypeImage(
                                          spot.order!.carType,
                                        ),
                              );
                            },
                          ),
                          SizedBox(height: AppSizeHeight.s20),
                          BlocBuilder<HomeBloc, HomeState>(
                            buildWhen: (previous, current) => false,
                            builder: (context, state) {
                              final spot = findSpotById(state, spotId);

                              return Text.rich(
                                TextSpan(
                                  text:
                                      AppLocalizations.of(
                                        context,
                                      )!.customerPhone,
                                  style: GoogleFonts.cairo(
                                    fontSize: FontSize.s17,
                                    fontWeight: FontWeight.normal,
                                    color: ColorManager.white,
                                  ),
                                  children: [
                                    locale.languageCode == 'ar'
                                        ? TextSpan(
                                          text: spot?.order?.clientNumber
                                              .replaceRange(0, 8, ''),
                                          style: GoogleFonts.archivo(
                                            fontSize: FontSize.s15,
                                            fontWeight: FontWeight.normal,
                                            color: ColorManager.white,
                                          ),
                                        )
                                        : TextSpan(
                                          text:
                                              AppLocalizations.of(
                                                context,
                                              )!.hiddenData,
                                          style: GoogleFonts.archivo(
                                            fontSize: FontSize.s15,
                                            fontWeight: FontWeight.normal,
                                            color: ColorManager.white,
                                          ),
                                        ),

                                    locale.languageCode == 'ar'
                                        ? TextSpan(
                                          text:
                                              AppLocalizations.of(
                                                context,
                                              )!.hiddenData,
                                          style: GoogleFonts.archivo(
                                            fontSize: FontSize.s15,
                                            fontWeight: FontWeight.normal,
                                            color: ColorManager.white,
                                          ),
                                        )
                                        : TextSpan(
                                          text: spot?.order?.clientNumber
                                              .replaceRange(0, 8, ''),
                                          style: GoogleFonts.archivo(
                                            fontSize: FontSize.s15,
                                            fontWeight: FontWeight.normal,
                                            color: ColorManager.white,
                                          ),
                                        ),
                                  ],
                                ),
                                // ✅ تأكد إنها كده بالظبط
                              );
                            },
                          ),

                          SizedBox(height: AppSizeHeight.s20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                TextUtils(
                                  text:
                                      AppLocalizations.of(context)!.garageLabel,
                                  color: ColorManager.lightGrey,
                                  fontSize: FontSize.s17,
                                  fontWeight: FontWeight.bold,
                                ),
                                BlocBuilder<HomeBloc, HomeState>(
                                  buildWhen: (previous, current) {
                                    return previous.getGaragesSpotState !=
                                            current.getGaragesSpotState ||
                                        previous.garageId != current.garageId ||
                                        previous.spotName != current.spotName;
                                  },
                                  builder: (context, state) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: AppSizeWidth.s8,
                                      ),
                                      alignment: Alignment.center,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        color: ColorManager.primary,
                                        borderRadius: BorderRadius.circular(
                                          AppSizeHeight.s10,
                                        ),
                                      ),
                                      width: AppSizeWidth.s135,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          items:
                                              garageNamesList?.map<
                                                DropdownMenuItem<String>
                                              >((garage) {
                                                final id =
                                                    garage['id'].toString();
                                                final name =
                                                    garage['name'].toString();
                                                return DropdownMenuItem<String>(
                                                  value: id,
                                                  child: TextUtils(
                                                    text: name,
                                                    color:
                                                        ColorManager.background,
                                                    fontSize: FontSize.s15,
                                                    fontWeight:
                                                        FontWeightManager.bold,
                                                  ),
                                                );
                                              }).toList(),
                                          value: selectedGarageId,
                                          onChanged: (value) {
                                            if (value != null) {
                                              print("onchange value $value");

                                              context.read<HomeBloc>().add(
                                                UpdateGarageNameEvent(value),
                                              );
                                              context.read<HomeBloc>().add(
                                                GetGarageSpotEvent(
                                                  int.parse(value),
                                                ),
                                              );
                                            }
                                          },
                                          hint: Align(
                                            alignment: Alignment.centerRight,
                                            child: TextUtils(
                                              text: garageName,
                                              color: ColorManager.background,
                                              fontSize: FontSize.s15,
                                              fontWeight:
                                                  FontWeightManager.bold,
                                            ),
                                          ),
                                          iconStyleData: IconStyleData(
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: ColorManager.background,
                                            ),
                                            iconSize: 14,
                                            iconEnabledColor: Colors.yellow,
                                            iconDisabledColor: Colors.grey,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: AppSizeHeight.s250,
                                            width: AppSizeWidth.s120,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: ColorManager.primary,
                                            ),
                                            offset: const Offset(-20, 0),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness:
                                                  MaterialStateProperty.all<
                                                    double
                                                  >(6),
                                              thumbVisibility:
                                                  MaterialStateProperty.all<
                                                    bool
                                                  >(true),
                                            ),
                                          ),
                                          menuItemStyleData: MenuItemStyleData(
                                            height: AppSizeHeight.s35,
                                            padding: EdgeInsets.only(
                                              left: 14,
                                              right: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSizeHeight.s20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .6,

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.spotLabel,
                                  style: GoogleFonts.cairo(
                                    color: ColorManager.white,
                                    fontSize: FontSize.s17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                BlocBuilder<HomeBloc, HomeState>(
                                  buildWhen:
                                      (previous, current) =>
                                          previous.getGaragesSpotState !=
                                              current.getGaragesSpotState ||
                                          previous.spotName !=
                                              current.spotName ||
                                          previous.emptySpots !=
                                              current.emptySpots,
                                  builder: (context, state) {
                                    switch (state.getGaragesSpotState) {
                                      case RequestState.loading:
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: ColorManager.white,
                                          ),
                                        );

                                      case RequestState.loaded:
                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: AppSizeWidth.s8,
                                          ),
                                          alignment: Alignment.center,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            color: ColorManager.primary,
                                            borderRadius: BorderRadius.circular(
                                              AppSizeHeight.s10,
                                            ),
                                          ),
                                          width: AppSizeWidth.s135,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2<String>(
                                              isExpanded: true,
                                              items:
                                                  emptySpotCodes.map((code) {
                                                    return DropdownMenuItem<
                                                      String
                                                    >(
                                                      value: code,
                                                      child: TextUtils(
                                                        text: code,
                                                        color:
                                                            ColorManager
                                                                .background,
                                                        fontSize: FontSize.s15,
                                                        fontWeight:
                                                            FontWeightManager
                                                                .bold,
                                                      ),
                                                    );
                                                  }).toList(),
                                              value: dropdownValue,
                                              onChanged: (value) {
                                                if (value != null) {
                                                  context.read<HomeBloc>().add(
                                                    UpdateSpotNameEvent(value),
                                                  );
                                                }
                                              },
                                              hint: BlocBuilder<
                                                HomeBloc,
                                                HomeState
                                              >(
                                                buildWhen:
                                                    (prev, curr) => false,
                                                builder: (context, state) {
                                                  final spot = findSpotById(
                                                    state,
                                                    spotId,
                                                  );

                                                  return Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: TextUtils(
                                                      text:
                                                          spot?.code ??
                                                          AppLocalizations.of(
                                                            context,
                                                          )!.noCode,
                                                      color:
                                                          ColorManager
                                                              .background,
                                                      fontSize: FontSize.s15,
                                                      fontWeight:
                                                          FontWeightManager
                                                              .bold,
                                                    ),
                                                  );
                                                },
                                              ),
                                              iconStyleData: IconStyleData(
                                                icon: Icon(
                                                  Icons
                                                      .arrow_forward_ios_outlined,
                                                  color:
                                                      ColorManager.background,
                                                ),
                                                iconSize: 14,
                                              ),
                                              dropdownStyleData: DropdownStyleData(
                                                maxHeight: AppSizeHeight.s250,
                                                width: AppSizeWidth.s120,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  color: ColorManager.primary,
                                                ),
                                                offset: const Offset(-20, 0),
                                                scrollbarTheme: ScrollbarThemeData(
                                                  radius: const Radius.circular(
                                                    40,
                                                  ),
                                                  thickness:
                                                      MaterialStateProperty.all<
                                                        double
                                                      >(6),
                                                  thumbVisibility:
                                                      MaterialStateProperty.all<
                                                        bool
                                                      >(true),
                                                ),
                                              ),
                                              menuItemStyleData:
                                                  MenuItemStyleData(
                                                    height: AppSizeHeight.s35,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 14,
                                                        ),
                                                  ),
                                            ),
                                          ),
                                        );

                                      case RequestState.error:
                                        return Center(
                                          child: TextUtils(
                                            text:
                                                AppLocalizations.of(
                                                  context,
                                                )!.errorOccurred,
                                          ),
                                        );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  bottomSheet: BlocBuilder<HomeBloc, HomeState>(
                    buildWhen: (previous, current) => false,
                    builder: (context, state) {
                      final spot = findSpotById(state, spotId);

                      return Material(
                        color: ColorManager.background,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: AppSizeHeight.s25),
                          child: SizedBox(
                            height: AppSizeHeight.s120,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  spot!.order?.status == 0
                                      ? BlocListener<
                                        MyOrdersBloc,
                                        MyOrdersState
                                      >(
                                        listenWhen:
                                            (previous, current) =>
                                                current.updateOrderStatus ==
                                                    true &&
                                                current.updatingOrderId ==
                                                    spot.order?.id,
                                        listener: (context, state) {
                                          context.read<MyOrdersBloc>().add(
                                            ResetOrderUpdateStatus(),
                                          );
                                          context.read<MyOrdersBloc>().add(
                                            GetAllMyOrdersEvent(),
                                          );


                                        },
                                        child: BlocBuilder<
                                          MyOrdersBloc,
                                          MyOrdersState
                                        >(
                                          builder: (context, state) {
                                            return CustomButton(
                                              onTap: () {
                                                final orderId = spot.order?.id;

                                                if (orderId == null || !state.orders.any((order) => order.id == orderId)) {
                                                  AlertDialogService().showAlertDialog(
                                                    context,
                                                    title: AppLocalizations.of(context)!.warning,
                                                    message: AppLocalizations.of(context)!.sorryThisCarBelongsToAnotherValet,
                                                    onPositiveButtonPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                               }else{
                                                 context
                                                     .read<MyOrdersBloc>()
                                                     .add(
                                                   UpdateOrderStatusEvent(
                                                     spot.order!.id,
                                                     1,
                                                   ),
                                                 );
                                                 context.read<HomeBloc>().add(
                                                   ChangeTabEvent(1),
                                                 );
                                                 context.read<MyOrdersBloc>().add(
                                                   GetMyOrdersEvent(1),
                                                 );
                                                 Navigator.push(
                                                   context,
                                                   MaterialPageRoute(
                                                     builder: (_) => MainScreen(),
                                                   ),
                                                 );
                                               }


                                              },
                                              btnColor: ColorManager.primary,
                                              widget: buildButtonContent(
                                                state.updatingOrderId ==
                                                        spot.order!.id
                                                    ? state
                                                        .updateOrderStatusState
                                                    : UpdateOrderState.initial,
                                                AppLocalizations.of(
                                                  context,
                                                )!.deliverVehicle,
                                                context,
                                              ),
                                              height: AppSizeHeight.s35,
                                            );
                                          },
                                        ),
                                      )
                                      : SizedBox(height: 0),
                                  spot.order?.status == 0
                                      ? SizedBox(height: AppSizeHeight.s20)
                                      : SizedBox(height: 0),
                                  CustomButton(
                                    onTap: () {
                                      context.read<HomeBloc>().add(
                                        UpdateOrderSpotEvent(
                                          spot.order!.id,
                                          (newSpot?.id) ?? spot.id,
                                          int.parse(
                                            selectedGarageId ??
                                                garageNamesList!.firstWhere(
                                                  (garage) =>
                                                      garage['name'] ==
                                                      garageName,
                                                )['id']!,
                                          ),
                                        ),
                                      );
                                      context.read<HomeBloc>().add(
                                        ResetSpotNameEvent(),
                                      );
                                      context.read<HomeBloc>().add(
                                        GetMyGaragesEvent(),
                                      );
                                      Navigator.pop(context);
                                      // print(spot!.order!.id);
                                      // print(spot.order,);
                                      // print(  int.parse(selectedGarageId!) ?? garageNamesList!.firstWhere((garage) => garage['name'] == garageName)['id']);
                                    },

                                    btnColor:
                                        (newSpot?.id == null &&
                                                selectedGarageId == null)
                                            ? ColorManager.darkGrey
                                            : ColorManager.primary,
                                    widget: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          size: AppSizeHeight.s20,
                                          color: ColorManager.background,
                                        ),
                                        SizedBox(width: AppSizeWidth.s10),
                                        TextUtils(
                                          text:
                                              AppLocalizations.of(
                                                context,
                                              )!.confirmEdit,
                                          color: ColorManager.background,
                                          fontSize: FontSize.s17,
                                          fontWeight: FontWeightManager.bold,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
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
    );
  }
}
