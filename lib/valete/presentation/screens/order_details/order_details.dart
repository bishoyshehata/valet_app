import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valet_app/core/network/api_constants.dart';
import 'package:valet_app/core/utils/enums.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import 'package:valet_app/valete/presentation/resources/values_manager.dart';
import '../../components/custom_app_bar.dart';
import '../../controllers/home/home_bloc.dart';
import '../../controllers/home/home_states.dart';
import '../garage_screen/garage_screen.dart';

class OrderDetails extends StatelessWidget {
  final int spotIndex;

  final int garageIndex;

  const OrderDetails({
    super.key,
    required this.spotIndex,
    required this.garageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final data = state.data![garageIndex].spots[spotIndex];
        print(ApiConstants.baseUrl + "/" + data.order!.carImage!);

        switch (state.myGaragesState) {
          case RequestState.loading:
            return Center(
              child: CircularProgressIndicator(color: ColorManager.white),
            );
          case RequestState.loaded:
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: ColorManager.background,
                appBar: CustomAppBar(
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: ColorManager.primary,
                    ),
                  ),
                  title: state.data![garageIndex].spots[spotIndex].code,
                  centerTitle: true,
                  titleColor: ColorManager.white,
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(AppMargin.m20),
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
                        data.order != null
                            ? Image.network(
                          Uri.encodeFull(ApiConstants.baseUrl + "/" + data.order!.carImage!),
                          height: AppSizeHeight.s45,
                          fit: BoxFit.cover,
                        )
                            : buildCarTypeImage(data.order!.carType))


                      // Container(
                      //   margin: EdgeInsets.symmetric(horizontal: AppMargin.m20),
                      //   width: double.infinity,
                      //   clipBehavior: Clip.antiAlias,
                      //   decoration: BoxDecoration(
                      //     color: ColorManager.primary,
                      //     borderRadius: BorderRadius.circular(
                      //       AppSizeHeight.s10,
                      //     ),
                      //   ),
                      //   child: buildCarTypeImage(data.order!.carType),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          case RequestState.error:
            return Center(child: Text("errrrrrrrrrrrorr"));
        }
      },
    );
  }
}
