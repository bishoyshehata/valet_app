import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:valet_app/core/utils/enums.dart';
import 'package:valet_app/valete/presentation/components/custom_bottun.dart';
import 'package:valet_app/valete/presentation/components/text/text_utils.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_events.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_states.dart';
import 'package:valet_app/valete/presentation/controllers/orders/order_bloc.dart';
import 'package:valet_app/valete/presentation/resources/assets_manager.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import 'package:valet_app/valete/presentation/resources/font_manager.dart';
import 'package:valet_app/valete/presentation/resources/values_manager.dart';
import 'package:valet_app/valete/presentation/screens/garage_screen/garage_screen.dart';

import '../../../../core/services/services_locator.dart';
import '../../../data/datasource/socket/socket_manager.dart';
import '../../components/custom_app_bar.dart';
import '../../resources/strings_manager.dart';
import '../order_screen/order_screen.dart';

// نموذج بيانات للجراج
class Garage {
  final String name;
  final int totalSpots;
  final int occupied;

  Garage({
    required this.name,
    required this.totalSpots,
    required this.occupied,
  });
}

class ValetHomeScreen extends StatelessWidget {
  // بيانات الجراجات (تقدر تجيبها من API بعدين)
  final List<Garage> garages = [
    Garage(name: "جراج التحرير", totalSpots: 50, occupied: 35),
    Garage(name: "جراج المعادي", totalSpots: 40, occupied: 28),
    Garage(name: "جراج أكتوبر", totalSpots: 60, occupied: 45),
  ];

  ValetHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(sl())..add(GetMyGaragesEvent()),
      child: BlocBuilder<HomeBloc,HomeState>(
        buildWhen: (previous, current) => previous.myGaragesState!= current.myGaragesState,
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: ColorManager.background,
              appBar: CustomAppBar(
                title: '${AppStrings.welcome} Valet Name',
                titleColor: ColorManager.white,
                leading: Icon(
                  Icons.garage_rounded,
                  color: ColorManager.primary,
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: AppSizeHeight.s10),
                    Align(
                      alignment: Alignment.center,

                      child: CustomButton(
                        onTap: ()  {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderScreen(), // pass the updated phone
                            ),
                          );
                        },
                        elevation: 5,
                        btnColor: ColorManager.primary,
                        shadowColor: ColorManager.white,
                        widget: TextUtils(
                          text: 'إضافة طلب',
                          fontSize: FontSize.s20,
                          fontWeight: FontWeightManager.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizeHeight.s15),

                    switch(state.myGaragesState) {
                      RequestState.loading => SizedBox(
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
                      ),
                      RequestState.loaded =>  ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: state.data!.length,
                        itemBuilder: (context, index) {
                          final garage = state.data![index];
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return BlocProvider.value(value: context.read<HomeBloc>(),child: GarageScreen(garageIndex: index,),);
                              },));
                            },
                            child: GarageCard(
                              name: garage.name,
                              address: garage.address,
                              totalSpots: garage.spots.length,
                              capacity: garage.capacity,
                              onRequestParking: () {
                                // هنا تقدر تفتح صفحة جديدة أو تنفذ منطق معين
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("تم طلب ركنة في ${garage.name}"),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      RequestState.error => Center(child: TextUtils(text: "errorrrr"),),
                    }

                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GarageCard extends StatelessWidget {
  final String name;
  final String address;
  final int totalSpots;
  final int capacity;
  final VoidCallback onRequestParking;

  const GarageCard({
    super.key,
    required this.name,
    required this.address,
    required this.totalSpots,
    required this.capacity,
    required this.onRequestParking,
  });

  @override
  Widget build(BuildContext context) {
    final int available = capacity - totalSpots;

    return Card(
      shadowColor: ColorManager.white,
      elevation: 5,
      color: ColorManager.grey,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    color: ColorManager.primary,
                  ),
                ),
                const SizedBox(width: 8),
                TextUtils(
                  text: name,
                  color: ColorManager.primary,
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
                    color: ColorManager.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextUtils(
                    text:address,
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
                  text: "الإجمالي: $totalSpots",
                  color: ColorManager.white,
                  fontWeight: FontWeightManager.bold,
                ),
                TextUtils(
                  text: "المشغول: $totalSpots",
                  color: ColorManager.white,
                  fontWeight: FontWeightManager.bold,
                ),
                TextUtils(
                  text: "المتاح: $available",
                  color: ColorManager.white,
                  fontWeight: FontWeightManager.bold,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
