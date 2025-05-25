import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:valet_app/core/network/api_constants.dart';
import 'package:valet_app/core/utils/enums.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import 'package:valet_app/valete/presentation/resources/values_manager.dart';
import '../../components/custom_app_bar.dart';
import '../../components/text/text_utils.dart';
import '../../controllers/home/home_bloc.dart';
import '../../controllers/home/home_states.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
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
        state = context.watch<HomeBloc>().state;
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
                body: Container(
                  margin: EdgeInsets.all(AppMargin.m20),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * .25,
                          width: double.infinity,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: ColorManager.primary,
                            borderRadius: BorderRadius.circular(
                              AppSizeHeight.s10,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child:
                                data.order!.carImage != null
                                    ? Image.network(
                                      Uri.encodeFull(
                                        "${ApiConstants.baseUrl}/${data.order!.carImage!}",
                                      ),
                                      height: AppSizeHeight.s45,
                                      fit: BoxFit.cover,
                                    )
                                    : buildCarTypeImage(data.order!.carType),
                          ),
                        ),
                        SizedBox(height:AppSizeHeight.s20 ),

                        TextUtils(
                          text:
                          'هاتف العميل : ${data.order!.clientNumber.replaceRange(0, 8, '########')}',
                          color: ColorManager.white,
                          fontSize: FontSize.s17,
                        ),
                        SizedBox(height:AppSizeHeight.s20 ),
                        TextUtils(
                          text: 'الجراج : ${data.order!.garageName}',
                          color: ColorManager.lightGrey,
                          fontSize: FontSize.s17,

                        ),
                        SizedBox(height:AppSizeHeight.s20 ),

                        TextUtils(
                          text: 'الباكية : ${data.order!.spotCode}',
                          color: ColorManager.lightGrey,
                          fontSize: FontSize.s17,

                        ),



                      ],
                    ),
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
    );
  }
}
