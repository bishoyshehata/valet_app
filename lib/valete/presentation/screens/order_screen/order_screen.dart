import 'dart:convert';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valet_app/valete/data/datasource/socket/socket_manager.dart';
import 'package:valet_app/valete/data/models/my_garages_models.dart';
import 'package:valet_app/valete/domain/entities/my_garages.dart';
import 'package:valet_app/valete/domain/usecases/create_order_use_case.dart';
import 'package:valet_app/valete/domain/usecases/store_order_use_case.dart';
import 'package:valet_app/valete/presentation/controllers/login/login_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/profile/profile_bloc.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import 'package:valet_app/valete/presentation/resources/values_manager.dart';
import 'package:valet_app/valete/presentation/screens/valet_home/valet_main.dart';
import '../../../../core/l10n/app_locale.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/enums.dart';
import '../../../data/models/store_order_model.dart';
import '../../../domain/entities/spot.dart';
import '../../components/login/custom_phone.dart';
import '../../components/text/text_utils.dart';
import '../../components/custom_app_bar.dart';
import '../../components/custom_bottun.dart';
import '../../controllers/home/home_bloc.dart';
import '../../controllers/home/home_events.dart' show ChangeTabEvent;
import '../../controllers/myorders/my_orders_bloc.dart';
import '../../controllers/myorders/my_orders_events.dart';
import '../../controllers/orders/order_bloc.dart';
import '../../controllers/orders/order_events.dart';
import '../../controllers/orders/order_states.dart';
import '../../resources/font_manager.dart';
import 'image_full_screen.dart';
import 'package:shimmer/shimmer.dart';
import '../error_screen/non_scaffold_error_screen.dart';

class OrderScreen extends StatelessWidget {
  final SocketService socketService = SocketService();

  OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileBloc = BlocProvider.of<ProfileBloc>(context);
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    final isWhatsAppWorking = profileBloc.state.isWhatsAppWorking ?? false;
    final phoneNumber = loginBloc.state.completePhoneNumber.replaceFirst(
      "+",
      '',
    );
    return BlocProvider<OrderBloc>(
      create: (context) {
        final bloc = OrderBloc(
          sl<CreateOrderUseCase>(),
          sl<StoreOrderUseCase>(),
        )..add(CreateOrderEvent());
        SharedPreferences.getInstance().then((prefs) {
          if (isWhatsAppWorking == true) {
            int? valetId = prefs.getInt('valetId');
            SocketService().closeSocket();
            socketService.initSocket(
              saiesId: valetId.toString(),
              onPhoneReceived: (phone) {
                bloc.add(UpdatePhoneNumberEvent(phone));
              },
              onError: (errorMessage) {
                // لازم يكون عندك BuildContext هنا عشان تعرض SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.connectionError +
                          '$errorMessage',
                    ),
                  ),
                );
              },
            );
          } else {
            print("WhatsApp is not working");
          }
        });

        return bloc;
      },
      child: BlocBuilder<OrderBloc, OrderState>(
        buildWhen: (previous, current) {
          return previous.defaultOrderState != current.defaultOrderState ||
              previous.phoneNumber != current.phoneNumber ||
              previous.spotName != current.spotName ||
              previous.garageName != current.garageName ;
        },
        builder: (context, state) {
          context.read<OrderBloc>().add(
            ToggleWhatsAppEvent(useWhatsApp: isWhatsAppWorking!),
          );
          print("/////////////////////${isWhatsAppWorking}");
          print("/////////////////////${state.useWhatsApp}");
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
              final garageName =
                  state.garageName == 'اسم الجراج'
                      ? state.data!.garageName
                      : state.garageName;
              final selectedGarageId =
                  state.garageName == 'اسم الجراج'
                      ? state.data!.garageId
                      : state.data!.garages
                          .firstWhere(
                            (garage) => garage.name == garageName,
                            orElse: () => MyGaragesModel.empty(), // 🔁 نوع صحيح
                          )
                          .id;

              final allSpots = state.data?.spots ?? [];
              final filteredSpots =
                  allSpots
                      .where((spot) => spot.garageId == selectedGarageId)
                      .toList();

              print(filteredSpots);
              String spotName;
              if (state.spotName == 'رقم الباكية') {
                if (filteredSpots.isNotEmpty) {
                  spotName = filteredSpots[0].code ?? 'رقم الباكية';
                } else {
                  spotName = 'رقم الباكية';
                }
              } else {
                spotName = state.spotName;
              }
              final spotId =
                  filteredSpots.isNotEmpty
                      ? filteredSpots
                          .firstWhere(
                            (spot) => spot.code == spotName,
                            orElse:
                                () =>
                                    filteredSpots
                                        .first, // تجنب الخطأ لو spotName غير موجود
                          )
                          .id
                      : null;
              final locale = Localizations.localeOf(context);
              return Directionality(
                textDirection:
                    locale.languageCode == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                child: WillPopScope(
                  onWillPop: () async {
                    SocketService().closeSocket();
                    Navigator.pop(context);
                    return false;
                  },
                  child: Scaffold(
                    backgroundColor: ColorManager.background,
                    appBar: CustomAppBar(
                      title:
                          isWhatsAppWorking == true
                              ? state.phoneNumber == 'رقم هاتف العميل'
                                  ? AppLocalizations.of(context)!.clientNumber
                                  : state.phoneNumber.length >= 8
                                  ? state.phoneNumber.replaceRange(
                                    0,
                                    8,
                                    AppLocalizations.of(context)!.hiddenData,
                                  )
                                  : state.phoneNumber
                              : AppLocalizations.of(context)!.createNewOrder,
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
                          _buildSwitchWhatsAppCard(context, state.useWhatsApp!),
                          _buildGarageInfoCard(
                            state.data!.garages,
                            filteredSpots,
                            context,
                            spotName,
                            garageName,
                          ),
                          isWhatsAppWorking == true
                              ? (state.phoneNumber == 'رقم هاتف العميل'
                                  ? _buildQrSection(context, state.data!.qr)
                                  : SizedBox.shrink())
                              : _buildPhoneFieldSection(context, phoneNumber),
                          _buildImageCaptureSection(context),
                          _buildVehicleTypeSelector(context),

                          SizedBox(height: AppSizeHeight.s75),
                        ],
                      ),
                    ),
                    bottomSheet: BlocListener<OrderBloc, OrderState>(
                      listenWhen:
                          (previous, current) =>
                              previous.storeOrderState !=
                              current.storeOrderState,
                      listener: (context, state) {
                        if (state.storeOrderState == StoreOrderState.loaded) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                state.useWhatsApp == true
                                    ? AppLocalizations.of(
                                      context,
                                    )!.orderCreatedSuccessfullyViaWhatsApp
                                    : AppLocalizations.of(
                                      context,
                                    )!.orderCreatedSuccessfully,
                              ),
                            ),
                          );
                          context.read<HomeBloc>().add(ChangeTabEvent(1));
                          context.read<MyOrdersBloc>().add(GetMyOrdersEvent(0));

                          Future.delayed(Duration(milliseconds: 500), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => MainScreen()),
                            );
                          });
                        } else if (state.storeOrderState ==
                            StoreOrderState.error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                state.useWhatsApp == true
                                    ? AppLocalizations.of(
                                          context,
                                        )!.failedToCreateOrderViaWhatsApp +
                                        "${state.errorMessage}"
                                    : AppLocalizations.of(
                                          context,
                                        )!.failedToCreateOrder +
                                        "${state.errorMessage}",
                              ),
                            ),
                          );
                        }
                      },
                      child: BlocBuilder<OrderBloc, OrderState>(
                        builder: (context, state) {
                          return Material(
                            color: ColorManager.background,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: AppSizeHeight.s25,
                              ),

                              child: CustomButton(
                                onTap: () async {
                                  bool isValid = false;
                                  if (state.useWhatsApp == true) {
                                    // الحالة لما WhatsApp شغال
                                    isValid =
                                        state.selectedVehicleType != null &&
                                        spotId != null &&
                                        state.phoneNumber !=
                                            'رقم هاتف العميل' &&
                                        state.phoneNumber.isNotEmpty;
                                  } else {
                                    // الحالة لما WhatsApp مش شغال
                                    isValid =
                                        state.selectedVehicleType != null &&
                                        spotId != null &&
                                        state.completePhoneNumber != null &&
                                        state.completePhoneNumber!
                                            .replaceFirst("+", '')
                                            .isNotEmpty;
                                  }

                                  if (isValid) {
                                    File? carImage;
                                    if (state.image != null) {
                                      carImage = state.image;
                                    }

                                    final model = StoreOrderModel(
                                      carImageFile: carImage,
                                      spotId: spotId!,
                                      carType: state.selectedVehicleType.index,
                                      ClientNumber:
                                      state.useWhatsApp == true
                                              ? state.phoneNumber
                                              : state.completePhoneNumber!
                                                  .replaceFirst("+", ''),
                                      garageId: selectedGarageId,
                                    );

                                    state.useWhatsApp == true
                                        ? context.read<OrderBloc>().add(
                                          StoreOrderWithWhatsAppEvent(model),
                                        )
                                        : context.read<OrderBloc>().add(
                                          StoreOrderNoWhatsAppEvent(model),
                                        );
                                  } else {
                                    if (state.useWhatsApp == true &&
                                        (state.phoneNumber ==
                                            'رقم هاتف العميل')) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: TextUtils(
                                            text:
                                                AppLocalizations.of(
                                                  context,
                                                )!.pleaseAskCustomerToScanQR,
                                            color: ColorManager.primary,
                                            fontSize: FontSize.s13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    } else if (isWhatsAppWorking &&
                                        (state.completePhoneNumber == null ||
                                            state
                                                .completePhoneNumber!
                                                .isEmpty)) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: TextUtils(
                                            text:
                                                AppLocalizations.of(
                                                  context,
                                                )!.pleaseEnterCustomerNumber,
                                            color: ColorManager.primary,
                                            fontSize: FontSize.s13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: TextUtils(
                                            text:
                                                AppLocalizations.of(
                                                  context,
                                                )!.sorryInvalidData,
                                            color: ColorManager.primary,
                                            fontSize: FontSize.s13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                btnColor:
                                   state.useWhatsApp == true
                                        ? (state.phoneNumber !=
                                                'رقم هاتف العميل'
                                            ? ColorManager.primary
                                            : ColorManager.lightGrey)
                                        : (state.completePhoneNumber != ''
                                            ? ColorManager.primary
                                            : ColorManager.lightGrey),

                                width: MediaQuery.of(context).size.width,
                                borderColor: ColorManager.white,
                                elevation: 5,
                                widget: switch (state.storeOrderState) {
                                  StoreOrderState.initial => TextUtils(
                                    text:
                                        AppLocalizations.of(
                                          context,
                                        )!.confirmOrder,
                                    color:
                                        state.phoneNumber != 'رقم هاتف العميل'
                                            ? ColorManager.background
                                            : ColorManager.white,
                                    fontSize: FontSize.s17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  StoreOrderState.loading =>
                                    CircularProgressIndicator(
                                      color: ColorManager.white,
                                    ),
                                  StoreOrderState.loaded => TextUtils(
                                    text:
                                        AppLocalizations.of(
                                          context,
                                        )!.confirmOrder,
                                    color: ColorManager.background,
                                    fontSize: FontSize.s17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  StoreOrderState.error => TextUtils(
                                    text: state.storeOrderError,
                                    color: ColorManager.background,
                                    fontSize: FontSize.s17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            case RequestState.error:
              return buildNonScaffoldErrorBody(
                context,
                state.createOrderStatusCode,
                state.createOrderError,
              );
          }
        },
      ),
    );
  }

  /// widgets
  Widget _buildSwitchWhatsAppCard(
      BuildContext context,
      bool isWhatsAppWorking,
      ) {
    return BlocBuilder<OrderBloc, OrderState>(
      buildWhen: (previous, current) =>
      previous.useWhatsApp != current.useWhatsApp,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextUtils(
                text: AppLocalizations.of(context)!.usingWhatsApp,
                color: ColorManager.white,
                fontSize: FontSize.s17,
                fontWeight: FontWeight.bold,
              ),
              Switch(
                value: state.useWhatsApp!,
                // استخدام الحالة العامة للتبديل
                activeColor: ColorManager.primary,
                onChanged: (bool value) {
                  context.read<OrderBloc>().add(
                    ToggleWhatsAppEvent(useWhatsApp: value),
                  );
                  print(state.useWhatsApp);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGarageInfoCard(
    List<MyGarages> garage,
    List<Spot> spots,
    BuildContext context,
    String selectedSpotName,
    String selectedGarageName,
  ) {
    final locale = Localizations.localeOf(context);

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppMargin.m16,
        vertical: AppMargin.m10,
      ),
      color: ColorManager.grey,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizeHeight.s10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // جراج - Dropdown
          Container(
            width: MediaQuery.of(context).size.width * .9,
            height: AppSizeHeight.s50,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    top: AppMargin.m16,
                    right: locale.languageCode == 'ar' ? AppMargin.m24 : 0,
                    left: locale.languageCode == 'ar' ? 0 : AppMargin.m24,
                  ),
                  padding: EdgeInsets.only(
                    right: locale.languageCode == 'ar' ? AppPadding.p5 : 0,
                    left: locale.languageCode == 'ar' ? 0 : AppPadding.p5,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      right:
                          locale.languageCode == 'ar'
                              ? BorderSide(
                                color: ColorManager.primary,
                                width: 3,
                              )
                              : BorderSide(color: ColorManager.grey, width: 0),
                      left:
                          locale.languageCode == 'ar'
                              ? BorderSide(color: ColorManager.grey, width: 0)
                              : BorderSide(
                                color: ColorManager.primary,
                                width: 3,
                              ),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.goToGarage,
                    style: GoogleFonts.cairo(
                      color: ColorManager.white,
                      fontSize: FontSize.s17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: AppMargin.m2,
                    top: AppMargin.m16,
                    right: locale.languageCode == 'ar' ? 0 : AppMargin.m16,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: AppSizeWidth.s8),
                  alignment: Alignment.center,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: ColorManager.primary,
                    borderRadius: BorderRadius.circular(AppSizeHeight.s10),
                  ),
                  width: AppSizeWidth.s100,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      items:
                          garage.map((garage) {
                            return DropdownMenuItem<String>(
                              value: garage.name,
                              child: TextUtils(
                                text: garage.name,
                                color: ColorManager.background,
                                fontSize: FontSize.s15,
                                fontWeight: FontWeightManager.bold,
                              ),
                            );
                          }).toList(),
                      value: selectedGarageName,
                      onChanged: (value) {
                        context.read<OrderBloc>().add(
                          UpdateGarageNameEvent(value!),
                        );
                        context.read<OrderBloc>().add(
                          UpdateSpotNameEvent('رقم الباكية'),
                        );
                        print(value);
                      },
                      hint: TextUtils(
                        text: AppLocalizations.of(context)!.garageFull,
                        color: ColorManager.background,
                        fontSize: FontSize.s11,
                        fontWeight: FontWeightManager.bold,
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
                        width: AppSizeWidth.s120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: ColorManager.primary,
                        ),
                        offset: const Offset(-20, 0),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: MaterialStateProperty.all<double>(6),
                          thumbVisibility: MaterialStateProperty.all<bool>(
                            true,
                          ),
                        ),
                      ),
                      menuItemStyleData: MenuItemStyleData(
                        height: AppSizeHeight.s35,
                        padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // الباكية - Dropdown
          Container(
            width: MediaQuery.of(context).size.width * .95,
            height: AppSizeHeight.s50,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    bottom: AppMargin.m16,
                    right: locale.languageCode == 'ar' ? AppMargin.m24 : 0,
                    left: locale.languageCode == 'ar' ? 0 : AppMargin.m24,
                  ),
                  padding: EdgeInsets.only(
                    right: locale.languageCode == 'ar' ? AppPadding.p5 : 0,
                    left: locale.languageCode == 'ar' ? 0 : AppPadding.p5,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      right:
                          locale.languageCode == 'ar'
                              ? BorderSide(
                                color: ColorManager.primary,
                                width: 3,
                              )
                              : BorderSide(color: ColorManager.grey, width: 0),
                      left:
                          locale.languageCode == 'ar'
                              ? BorderSide(color: ColorManager.grey, width: 0)
                              : BorderSide(
                                color: ColorManager.primary,
                                width: 3,
                              ),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.spotLabel,
                    style: GoogleFonts.cairo(
                      color: ColorManager.white,
                      fontSize: FontSize.s17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                spots.isEmpty
                    ? Container(
                      margin: EdgeInsets.only(
                        bottom: AppMargin.m10,
                        top: AppMargin.m10,
                        right: locale.languageCode == 'ar' ? 0 : AppMargin.m24,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizeWidth.s8,
                      ),
                      alignment: Alignment.center,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: ColorManager.primary,
                        borderRadius: BorderRadius.circular(AppSizeHeight.s10),
                      ),
                      width: AppSizeWidth.s100,
                      child: TextUtils(
                        text: AppLocalizations.of(context)!.garageFull,
                        color: ColorManager.background,
                        fontSize: FontSize.s12,
                        fontWeight: FontWeightManager.bold,
                      ),
                    )
                    : Container(
                      margin: EdgeInsets.only(
                        bottom: AppMargin.m10,
                        top: AppMargin.m8,
                        right: locale.languageCode == 'ar' ? 0 : AppMargin.m22,
                        left: locale.languageCode == 'ar' ? AppMargin.m8 : 0,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizeWidth.s8,
                      ),
                      alignment: Alignment.center,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: ColorManager.primary,
                        borderRadius: BorderRadius.circular(AppSizeHeight.s10),
                      ),
                      width: AppSizeWidth.s100,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          items:
                              spots.map((spot) {
                                return DropdownMenuItem<String>(
                                  value: spot.code.toString(),
                                  child: TextUtils(
                                    text: spot.code,
                                    color: ColorManager.background,
                                    fontSize: FontSize.s15,
                                    fontWeight: FontWeightManager.bold,
                                  ),
                                );
                              }).toList(),
                          value: selectedSpotName,
                          onChanged: (value) {
                            context.read<OrderBloc>().add(
                              UpdateSpotNameEvent(value!),
                            );
                            print(value);
                          },
                          hint: TextUtils(
                            text: AppLocalizations.of(context)!.garageFull,
                            color: ColorManager.background,
                            fontSize: FontSize.s11,
                            fontWeight: FontWeightManager.bold,
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
                            width: AppSizeWidth.s120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: ColorManager.primary,
                            ),
                            offset: const Offset(-20, 0),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all<double>(6),
                              thumbVisibility: MaterialStateProperty.all<bool>(
                                true,
                              ),
                            ),
                          ),
                          menuItemStyleData: MenuItemStyleData(
                            height: AppSizeHeight.s35,
                            padding: EdgeInsets.only(left: 14, right: 14),
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildVehicleTypeSelector(BuildContext context) {
  final locale = Localizations.localeOf(context);

  return Card(
    margin: EdgeInsets.symmetric(
      horizontal: AppMargin.m16,
      vertical: AppMargin.m10,
    ),
    color: ColorManager.grey,
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizeHeight.s10),
    ),
    child: Column(
      children: [
        Container(
          alignment:
              locale.languageCode == 'ar'
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
          margin: EdgeInsets.only(
            top: AppMargin.m16,
            right: locale.languageCode == 'ar' ? AppMargin.m24 : 0,
            left: locale.languageCode == 'ar' ? 0 : AppMargin.m24,
          ),
          padding: EdgeInsets.only(
            right: locale.languageCode == 'ar' ? AppPadding.p5 : 0,
            left: locale.languageCode == 'ar' ? 0 : AppPadding.p5,
          ),
          decoration: BoxDecoration(
            border: Border(
              right:
                  locale.languageCode == 'ar'
                      ? BorderSide(color: ColorManager.primary, width: 3)
                      : BorderSide(color: ColorManager.grey, width: 0),
              left:
                  locale.languageCode == 'ar'
                      ? BorderSide(width: 0)
                      : BorderSide(color: ColorManager.primary, width: 3),
            ),
          ),
          child: TextUtils(
            text: AppLocalizations.of(context)!.selectVehicleType,
            color: ColorManager.white,
            fontSize: FontSize.s17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: BlocBuilder<OrderBloc, OrderState>(
            buildWhen:
                (previous, current) =>
                    previous.selectedVehicleType != current.selectedVehicleType,
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

Widget _buildPhoneFieldSection(BuildContext context, String phoneNumber) {
  final locale = Localizations.localeOf(context);

  return Card(
    margin: EdgeInsets.symmetric(
      horizontal: AppMargin.m16,
      vertical: AppMargin.m10,
    ),
    color: ColorManager.grey,
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizeHeight.s10),
    ),
    child: Column(
      children: [
        Container(
          alignment:
              locale.languageCode == 'ar'
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
          margin: EdgeInsets.only(
            top: AppMargin.m16,
            right: locale.languageCode == 'ar' ? AppMargin.m24 : 0,
            left: locale.languageCode == 'ar' ? 0 : AppMargin.m24,
          ),
          padding: EdgeInsets.only(
            right: locale.languageCode == 'ar' ? AppPadding.p5 : 0,
            left: locale.languageCode == 'ar' ? 0 : AppPadding.p5,
          ),
          decoration: BoxDecoration(
            border: Border(
              right:
                  locale.languageCode == 'ar'
                      ? BorderSide(color: ColorManager.primary, width: 3)
                      : BorderSide(color: ColorManager.grey, width: 0),
              left:
                  locale.languageCode == 'ar'
                      ? BorderSide(width: 0)
                      : BorderSide(color: ColorManager.primary, width: 3),
            ),
          ),
          child: TextUtils(
            text: AppLocalizations.of(context)!.addCustomerPhone,
            color: ColorManager.white,
            fontSize: FontSize.s17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              return Directionality(
                textDirection: TextDirection.ltr,
                child: CustomPhoneField(
                  labelText: AppLocalizations.of(context)!.enterPhone,
                  backgroundColor: ColorManager.background,
                  labelSize: 15,
                  errorText:
                      state.hasInteractedWithPhone
                          ? state.phoneErrorMessage
                          : null,

                  onChanged: (phone) {
                    context.read<OrderBloc>().add(
                      CompletePhoneChanged(
                        phoneNumber: phone.number, // ex: 1550637983
                        countryCode: phone.countryCode.replaceFirst('+', ''),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget _buildQrSection(BuildContext context, String qr) {
  final locale = Localizations.localeOf(context);

  String base64String = qr.replaceFirst('data:image/png;base64,', '');
  Uint8List qrBytes = base64Decode(base64String);

  return BlocBuilder<OrderBloc, OrderState>(
    buildWhen: (previous, current) => previous.useWhatsApp != current.useWhatsApp,
  builder: (context, state) {
    return state.useWhatsApp == true ? Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppMargin.m16,
        vertical: AppMargin.m10,
      ),
      color: ColorManager.grey,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizeHeight.s10),
      ),
      child: Column(
        children: [
          Container(
            alignment:
            locale.languageCode == 'ar'
                ? Alignment.centerRight
                : Alignment.centerLeft,
            margin: EdgeInsets.only(
              top: AppMargin.m16,
              right: locale.languageCode == 'ar' ? AppMargin.m24 : 0,
              left: locale.languageCode == 'ar' ? 0 : AppMargin.m24,
            ),
            padding: EdgeInsets.only(
              right: locale.languageCode == 'ar' ? AppPadding.p5 : 0,
              left: locale.languageCode == 'ar' ? 0 : AppPadding.p5,
            ),
            decoration: BoxDecoration(
              border: Border(
                right:
                locale.languageCode == 'ar'
                    ? BorderSide(color: ColorManager.primary, width: 3)
                    : BorderSide(color: ColorManager.grey, width: 0),
                left:
                locale.languageCode == 'ar'
                    ? BorderSide(width: 0)
                    : BorderSide(color: ColorManager.primary, width: 3),
              ),
            ),
            child: TextUtils(
              text: AppLocalizations.of(context)!.scanQR,
              color: ColorManager.white,
              fontSize: FontSize.s17,
              fontWeight: FontWeight.bold,
            ),
          ),
          BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                  vertical: AppMargin.m16,
                  horizontal: AppMargin.m16,
                ),
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
              );
            },
          ),
        ],
      ),
    ) : Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppMargin.m16,
        vertical: AppMargin.m10,
      ),
      color: ColorManager.grey,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizeHeight.s10),
      ),
      child: Column(
        children: [
          Container(
            alignment:
            locale.languageCode == 'ar'
                ? Alignment.centerRight
                : Alignment.centerLeft,
            margin: EdgeInsets.only(
              top: AppMargin.m16,
              right: locale.languageCode == 'ar' ? AppMargin.m24 : 0,
              left: locale.languageCode == 'ar' ? 0 : AppMargin.m24,
            ),
            padding: EdgeInsets.only(
              right: locale.languageCode == 'ar' ? AppPadding.p5 : 0,
              left: locale.languageCode == 'ar' ? 0 : AppPadding.p5,
            ),
            decoration: BoxDecoration(
              border: Border(
                right:
                locale.languageCode == 'ar'
                    ? BorderSide(color: ColorManager.primary, width: 3)
                    : BorderSide(color: ColorManager.grey, width: 0),
                left:
                locale.languageCode == 'ar'
                    ? BorderSide(width: 0)
                    : BorderSide(color: ColorManager.primary, width: 3),
              ),
            ),
            child: TextUtils(
              text: AppLocalizations.of(context)!.addCustomerPhone,
              color: ColorManager.white,
              fontSize: FontSize.s17,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: CustomPhoneField(
                    labelText: AppLocalizations.of(context)!.enterPhone,
                    backgroundColor: ColorManager.background,
                    labelSize: 15,
                    errorText:
                    state.hasInteractedWithPhone
                        ? state.phoneErrorMessage
                        : null,

                    onChanged: (phone) {
                      context.read<OrderBloc>().add(
                        CompletePhoneChanged(
                          phoneNumber: phone.number, // ex: 1550637983
                          countryCode: phone.countryCode.replaceFirst('+', ''),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );;
  },
);
}

Widget _buildImageCaptureSection(BuildContext context) {
  final locale = Localizations.localeOf(context);

  return Card(
    margin: EdgeInsets.symmetric(
      horizontal: AppMargin.m16,
      vertical: AppMargin.m10,
    ),
    color: ColorManager.grey,
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizeHeight.s10),
    ),
    child: Column(
      children: [
        Container(
          alignment:
              locale.languageCode == 'ar'
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
          margin: EdgeInsets.only(
            top: AppMargin.m16,
            right: locale.languageCode == 'ar' ? AppMargin.m24 : 0,
            left: locale.languageCode == 'ar' ? 0 : AppMargin.m24,
          ),
          padding: EdgeInsets.only(
            right: locale.languageCode == 'ar' ? AppPadding.p5 : 0,
            left: locale.languageCode == 'ar' ? 0 : AppPadding.p5,
          ),
          decoration: BoxDecoration(
            border: Border(
              right:
                  locale.languageCode == 'ar'
                      ? BorderSide(color: ColorManager.primary, width: 3)
                      : BorderSide(color: ColorManager.grey, width: 0),
              left:
                  locale.languageCode == 'ar'
                      ? BorderSide(width: 0)
                      : BorderSide(color: ColorManager.primary, width: 3),
            ),
          ),
          child: TextUtils(
            text: AppLocalizations.of(context)!.captureVehicleImage,
            color: ColorManager.white,
            fontSize: FontSize.s17,
            fontWeight: FontWeight.bold,
          ),
        ),
        BlocBuilder<OrderBloc, OrderState>(
          buildWhen: (previous, current) => previous.image != current.image,
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => FullScreenImage(imageFile: image),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: PhotoView(
                                imageProvider: FileImage(image),
                                backgroundDecoration: BoxDecoration(
                                  color: ColorManager.background,
                                ),
                                minScale: PhotoViewComputedScale.contained,
                                maxScale: PhotoViewComputedScale.covered * 2.0,
                              ),
                            ),
                          )
                          : InkWell(
                            onTap: () {
                              context.read<OrderBloc>().add(PickImageEvent());
                            },
                            child: Icon(
                              Icons.image,
                              size: AppSizeHeight.s100,
                              color: ColorManager.grey,
                            ),
                          ),
                ),
                Positioned(
                  bottom: AppSizeHeight.s20,
                  right: AppSizeHeight.s20,
                  child: InkWell(
                    onTap: () {
                      context.read<OrderBloc>().add(PickImageEvent());
                    },
                    child: Container(
                      width: AppSizeWidth.s40,
                      height: AppSizeWidth.s40,
                      decoration: BoxDecoration(
                        color: ColorManager.lightGrey,
                        borderRadius: BorderRadius.circular(AppSizeWidth.s50),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: AppSizeHeight.s30,
                        color: ColorManager.grey,
                      ),
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
    case VehicleType.Truck:
      return Icons.local_shipping;
    case VehicleType.Bus:
      return Icons.directions_bus;
  }
}
