import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valet_app/core/network/api_constants.dart';
import 'package:valet_app/core/utils/enums.dart';
import 'package:valet_app/valete/presentation/components/custom_bottun.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import 'package:valet_app/valete/presentation/resources/values_manager.dart';
import '../../../domain/entities/spot.dart';
import '../../components/custom_app_bar.dart';
import '../../components/text/text_utils.dart';
import '../../controllers/home/home_bloc.dart';
import '../../controllers/home/home_events.dart';
import '../../controllers/home/home_states.dart';
import '../../resources/font_manager.dart';
import '../garage_screen/garage_screen.dart';
import 'order_full_screen.dart';
import 'package:collection/collection.dart';

class OrderDetails extends StatelessWidget {
  final int spotId;
  final int garageId;
  final String garageName;
  Spot? newSpot;
  OrderDetails({
    super.key,
    required this.spotId,
    required this.garageId,
    required this.garageName,
  });
  Spot? findSpotById(HomeState state, int id) {
    return [
      ...?state.allSpots?.mainSpots,
      ...?state.allSpots?.extraSpots,
      ...?state.allSpots?.emptySpots,
    ].firstWhereOrNull((s) => s.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc,HomeState>(

      builder: (context, state) {
        switch (state.getGaragesSpotState){
          case RequestState.loading:
          // TODO: Handle this case.
            throw UnimplementedError();
          case RequestState.loaded:
            final garages = state.data;

            final garageNamesList = garages?.map((garage) {
              return {
                'id': garage.id.toString(),
                'name': garage.name,
              };
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

            String? dropdownValue = (state.spotName != 'رقم الباكية' &&
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


            return Directionality(
              textDirection: TextDirection.rtl,
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
                        final spot = findSpotById(state,spotId );

                        return CustomAppBar(
                          leading: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(AppMargin.m4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSizeHeight.s50),
                              color: ColorManager.grey,
                            ),
                            child: IconButton(
                              onPressed: () {
                                context.read<HomeBloc>().add(ResetSpotNameEvent());
                                Navigator.pop(context);
                              },

                              icon: Icon(Icons.arrow_back, color: ColorManager.white),
                            ),
                          ),
                          title: spot!.code ,
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
                          BlocBuilder<HomeBloc,HomeState>(
                              buildWhen: (previous, current) => false,
                              builder: (context, state) {
                                final spot = [
                                  ...?state.allSpots?.mainSpots,
                                  ...?state.allSpots?.extraSpots,
                                  ...?state.allSpots?.emptySpots,
                                ].firstWhereOrNull((s) => s.id == spotId);

                                return Container(
                                  height: MediaQuery.of(context).size.height * .25,
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
                                            (_) => FullScreenNetworkImage(
                                          imageUrl:
                                          "${ApiConstants.baseUrl}/${spot.order!.carImage!}",
                                        ),
                                      ),
                                    ),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: buildCarTypeImageForStatus(
                                        spot.order!.carType??0,
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
                                      : buildCarTypeImage(spot.order!.carType),
                                );
                              }
                          ),
                          SizedBox(height: AppSizeHeight.s20),
                          BlocBuilder<HomeBloc,HomeState>(
                            buildWhen: (previous, current) => false,
                            builder: (context, state) {
                              final spot = findSpotById(state,spotId );

                              return Text.rich(
                                TextSpan(
                                  text: 'هاتف العميل : ',
                                  style: GoogleFonts.cairo(
                                    fontSize: FontSize.s17,
                                    fontWeight: FontWeight.normal,
                                    color: ColorManager.white,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: spot?.order!.clientNumber.replaceRange(
                                        0,
                                        8,
                                        '',
                                      ),
                                      style: GoogleFonts.archivo(
                                        fontSize: FontSize.s17,
                                        fontWeight: FontWeight.normal,
                                        color: ColorManager.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '########',
                                      style: GoogleFonts.archivo(
                                        fontSize: FontSize.s17,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              TextUtils(
                                text: 'الجراج : ',
                                color: ColorManager.lightGrey,
                                fontSize: FontSize.s17,
                                fontWeight: FontWeight.bold,
                              ),
                              BlocBuilder<HomeBloc, HomeState>(
                                buildWhen: (previous, current) {
                                  return  previous.getGaragesSpotState != current.getGaragesSpotState ||
                                      previous.garageId != current.garageId || previous.spotName != current.spotName;
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
                                          final id = garage['id'].toString();
                                          final name =
                                          garage['name'].toString();
                                          return DropdownMenuItem<String>(
                                            value: id,
                                            child: TextUtils(
                                              text: name,
                                              color: ColorManager.background,
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
                                              GetGarageSpotEvent(int.parse(value)),
                                            );
                                          }
                                        },
                                        hint: Align(
                                          alignment: Alignment.centerRight,
                                          child: TextUtils(
                                            text:  garageName,
                                            color: ColorManager.background,
                                            fontSize: FontSize.s15,
                                            fontWeight: FontWeightManager.bold,
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
                                            borderRadius: BorderRadius.circular(14),
                                            color: ColorManager.primary,
                                          ),
                                          offset: const Offset(-20, 0),
                                          scrollbarTheme: ScrollbarThemeData(
                                            radius: const Radius.circular(40),
                                            thickness:
                                            MaterialStateProperty.all<double>(
                                              6,
                                            ),
                                            thumbVisibility:
                                            MaterialStateProperty.all<bool>(
                                              true,
                                            ),
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
                          SizedBox(height: AppSizeHeight.s20),
                          Row(
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
                              BlocBuilder<HomeBloc, HomeState>(
                                buildWhen: (previous, current) =>
                                previous.getGaragesSpotState != current.getGaragesSpotState ||
                                    previous.spotName != current.spotName||
                                    previous.emptySpots != current.emptySpots,
                                builder: (context, state) {
                                  switch (state.getGaragesSpotState) {
                                    case RequestState.loading:
                                      return Center(
                                        child: CircularProgressIndicator(color: ColorManager.white),
                                      );

                                    case RequestState.loaded:

                                      return Container(
                                        padding: EdgeInsets.symmetric(horizontal: AppSizeWidth.s8),
                                        alignment: Alignment.center,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          color: ColorManager.primary,
                                          borderRadius: BorderRadius.circular(AppSizeHeight.s10),
                                        ),
                                        width: AppSizeWidth.s135,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                            isExpanded: true,
                                            items: emptySpotCodes.map((code) {
                                              return DropdownMenuItem<String>(
                                                value: code,
                                                child: TextUtils(
                                                  text: code,
                                                  color: ColorManager.background,
                                                  fontSize: FontSize.s15,
                                                  fontWeight: FontWeightManager.bold,
                                                ),
                                              );
                                            }).toList(),
                                            value: dropdownValue,
                                            onChanged: (value) {
                                              if (value != null) {
                                                context.read<HomeBloc>().add(UpdateSpotNameEvent(value));
                                              }
                                            },
                                            hint: BlocBuilder<HomeBloc, HomeState>(
                                              buildWhen: (prev, curr) => false,
                                              builder: (context, state) {
                                                final spot = findSpotById(state,spotId );


                                                return Align(
                                                  alignment: Alignment.centerRight,
                                                  child: TextUtils(
                                                    text: spot?.code ?? 'لا يوجد كود',
                                                    color: ColorManager.background,
                                                    fontSize: FontSize.s15,
                                                    fontWeight: FontWeightManager.bold,
                                                  ),
                                                );
                                              },
                                            ),
                                            iconStyleData: IconStyleData(
                                              icon: Icon(Icons.arrow_forward_ios_outlined,
                                                  color: ColorManager.background),
                                              iconSize: 14,
                                            ),
                                            dropdownStyleData: DropdownStyleData(
                                              maxHeight: AppSizeHeight.s250,
                                              width: AppSizeWidth.s120,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(14),
                                                color: ColorManager.primary,
                                              ),
                                              offset: const Offset(-20, 0),
                                              scrollbarTheme: ScrollbarThemeData(
                                                radius: const Radius.circular(40),
                                                thickness: MaterialStateProperty.all<double>(6),
                                                thumbVisibility: MaterialStateProperty.all<bool>(true),
                                              ),
                                            ),
                                            menuItemStyleData: MenuItemStyleData(
                                              height: AppSizeHeight.s35,
                                              padding: EdgeInsets.symmetric(horizontal: 14),
                                            ),
                                          ),
                                        ),
                                      );

                                    case RequestState.error:
                                      return Center(child: TextUtils(text: "حدث خطأ"));
                                  }
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  bottomSheet: BlocBuilder<HomeBloc,HomeState>(

                      buildWhen: (previous, current) => false,
                      builder: (context, state) {
                        final spot = findSpotById(state,spotId );

                        return  Material(
                            color: ColorManager.background,
                            child:  Padding(
                              padding: EdgeInsets.only(bottom: AppSizeHeight.s25),
                              child: CustomButton(
                                onTap: () {
                                  context.read<HomeBloc>().add(
                                    UpdateOrderSpotEvent(
                                      spot!.order!.id,
                                        (newSpot?.id) ?? spot.id,
                                        int.parse(selectedGarageId ?? garageNamesList!
                                            .firstWhere((garage) => garage['name'] == garageName)['id']!)
                                    ),

                                  );
                                  context.read<HomeBloc>().add(ResetSpotNameEvent());
                                  context.read<HomeBloc>().add(GetMyGaragesEvent());

                                  Navigator.pop(context);
                                  // print(spot!.order!.id);
                                  // print(spot.id);
                                  // print(  int.parse(selectedGarageId!) ?? garageNamesList!.firstWhere((garage) => garage['name'] == garageName)['id']);
                                },

                                btnColor:
                                (newSpot?.id ==null && selectedGarageId == null)

                                    ? ColorManager.darkGrey
                                    : ColorManager.primary,
                                widget: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: AppSizeHeight.s20,
                                      color: ColorManager.background,
                                    ),
                                    SizedBox(width: AppSizeWidth.s10),
                                    TextUtils(
                                      text: 'تأكيد التعديل',
                                      color: ColorManager.background,
                                      fontSize: FontSize.s17,
                                      fontWeight: FontWeightManager.bold,
                                    ),
                                  ],
                                ),
                              ),
                            )
                        );
                      }

                  ),
                ),
              ),
            );
          case RequestState.error:
          // TODO: Handle this case.
            throw UnimplementedError();
        }
      },
    );
  }
}

