import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:valet_app/core/utils/enums.dart';
import 'package:valet_app/valete/domain/entities/spot.dart';
import 'package:valet_app/valete/presentation/components/custom_bottun.dart';
import 'package:valet_app/valete/presentation/components/text/text_utils.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_states.dart';
import 'package:valet_app/valete/presentation/resources/assets_manager.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import 'package:valet_app/valete/presentation/resources/font_manager.dart';
import 'package:valet_app/valete/presentation/resources/values_manager.dart';
import 'package:valet_app/valete/presentation/screens/garage_screen/garage_screen.dart';
import 'package:valet_app/valete/presentation/screens/login/login.dart';
import '../../../../core/l10n/app_locale.dart';
import '../../components/custom_app_bar.dart';
import '../../controllers/home/home_events.dart';
import '../../resources/strings_manager.dart';
import '../error_screen/main_error_screen.dart';
import '../order_screen/order_screen.dart';

class ValetHomeScreen extends StatelessWidget {
  const ValetHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<HomeBloc>().add(GetMyGaragesEvent());

    Future<String> getValetName() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('valetName') ?? '';
    }

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorManager.background,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: FutureBuilder<String>(
              future: getValetName(),
              builder: (context, snapshot) {
                final title =
                    snapshot.hasData
                        ?  snapshot.data!
                        : AppLocalizations.of(context)!.welcome;

                return CustomAppBar(
                  title: title,
                  titleColor: ColorManager.white,
                  leading: Icon(
                    Icons.maps_home_work,
                    color: ColorManager.white,
                  ),
                );
              },
            ),
          ),

          body: RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(GetMyGaragesEvent());
            },
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(), // مهم جدًا
              children: [
                SizedBox(height: AppSizeHeight.s10),
                Align(
                  alignment: Alignment.center,
                  child:state.myGaragesState!=RequestState.error? CustomButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderScreen()),
                      );
                    },
                    elevation: 5,
                    btnColor: ColorManager.primary,
                    widget: TextUtils(
                      text: AppLocalizations.of(context)!.addOrder,
                      fontSize: FontSize.s20,
                      color: ColorManager.background,
                      fontWeight: FontWeightManager.bold,
                    ),
                  ) : SizedBox(height: 0,),
                ),
                SizedBox(height: AppSizeHeight.s5),
                  switch(state.myGaragesState) {
                  RequestState.loading => ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder:
                        (context, index) => Shimmer.fromColors(
                          baseColor: Colors.grey[850]!,
                          highlightColor: Colors.grey[800]!,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: AppMargin.m12,
                              vertical: AppMargin.m12,
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
                  RequestState.loaded =>
                    state.data!.isEmpty
                        ? Lottie.asset(LottieManager.noCars)
                        : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.data!.length,
                          itemBuilder: (context, index) {
                            final garage = state.data![index];
                            return InkWell(
                              onTap: () {
                                     Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            GarageScreen(garageId: garage.id , garageName : garage.name),
                                  ),
                                );
                                     context.read<HomeBloc>().add(GetGarageSpotEvent(garage.id));
                              },
                              child: GarageCard(
                                name: garage.name,
                                address: garage.address?? AppLocalizations.of(context)!.unDefined,
                                capacity: garage.capacity!,
                                busySpots: garage.busySpotCount!,
                                emptySpots: garage.emptySpotCount!,
                              ),
                            );
                          },
                        ),
                  RequestState.error => buildErrorBody(context, state.garagesStatusCode,state.myGaragesErrorMessage)
                },
              ],
            ),
          ),
        );
      },
    );
  }
}

class GarageCard extends StatelessWidget {
  final String name;
  final String address;
  final int capacity;
  final int busySpots;
  final int emptySpots;

  const GarageCard({
    super.key,
    required this.name,
    required this.address,
    required this.capacity,
    required this.busySpots,
    required this.emptySpots,
  });

  @override
  Widget build(BuildContext context) {
    final int totalSpots = capacity;
    final int occupiedSpots = busySpots;
    final int availableSpots = emptySpots;

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Card(
          elevation: 5,
          color: ColorManager.grey,
          margin: EdgeInsets.only(
            right: AppMargin.m12,
            top: AppMargin.m12,
            left: AppMargin.m12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppPadding.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: AppPadding.p5),
                      child: Icon(
                        Icons.garage_outlined,
                        color: ColorManager.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextUtils(
                      text: name,
                      color: ColorManager.white,
                      fontSize: FontSize.s20,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: AppPadding.p5),
                      child: Icon(
                        Icons.location_on_outlined,
                        color: ColorManager.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextUtils(
                        text: address,
                        color: ColorManager.white,
                        fontSize: FontSize.s12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextUtils(
                      text: AppLocalizations.of(context)!.total+totalSpots.toString(),
                      color: ColorManager.white,
                      fontWeight: FontWeightManager.bold,
                    ),
                    TextUtils(
                      text: AppLocalizations.of(context)!.theBusy+ occupiedSpots.toString(),
                      color: ColorManager.white,
                      fontWeight: FontWeightManager.bold,
                    ),
                    TextUtils(
                      text: AppLocalizations.of(context)!.theAvailable + availableSpots.toString(),
                      color: ColorManager.white,
                      fontWeight: FontWeightManager.bold,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
