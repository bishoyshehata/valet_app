import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:valet_app/core/utils/enums.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_states.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import '../../../../core/services/services_locator.dart';
import '../../../domain/entities/my_orders.dart';
import '../../../domain/usecases/my_garages_use_case.dart';
import '../../../domain/usecases/my_orders_use_case.dart';
import '../../components/custom_app_bar.dart';
import '../../components/text/text_utils.dart';
import '../../controllers/home/home_events.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';
import '../garage_screen/garage_screen.dart';

class OrdersScreen extends StatelessWidget {
  final int initialSelectedStatus = 0;
  final List<Map<String, dynamic>> statusOptions = const [
    {'id': 0, 'label': 'في الإنتظار'},
    {'id': 1, 'label': 'مطلوب'},
    {'id': 2, 'label': 'في الطريق'},
    {'id': 3, 'label': 'وصل'},
    {'id': 4, 'label': 'تم التسليم'},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => HomeBloc(
            sl<MyGaragesUseCase>(),
            sl<MyOrdersUseCase>(),
            initialSelectedStatus: initialSelectedStatus,
          )..add(GetAllMyOrdersEvent()),

      child: Scaffold(
        backgroundColor: ColorManager.background,
        appBar: CustomAppBar(
          title: 'إدارة الطلبات',
          centerTitle: false,
          titleColor: ColorManager.white,
          leading: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(AppMargin.m4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizeHeight.s50),
              color: ColorManager.grey,
            ),
            child: Icon(Icons.note_alt_rounded, color: ColorManager.white),
          ),
        ),

        body: Column(
          children: [
            SizedBox(
              height: 70,
              child: BlocBuilder<HomeBloc, HomeState>(
                // buildWhen: (prev, curr) => prev.selectedStatus != curr.selectedStatus,

                builder: (context, state) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: statusOptions.length,
                    itemBuilder: (context, index) {
                      final option = statusOptions[index];
                      final isSelected = state.selectedStatus == option['id'];

                      return Container(
                        margin: EdgeInsets.only(top: AppMargin.m8),
                        padding: EdgeInsets.all(AppPadding.p6),
                        child: Stack(
                          children: [
                            ChoiceChip(
                              elevation: 3,
                              shadowColor: ColorManager.primary,
                              label: Text(option['label']),
                              selected: isSelected,
                              onSelected: (_) {
                                context.read<HomeBloc>().add(
                                  GetMyOrdersEvent(option['id']),
                                );
                                print(option);
                              },
                              selectedColor: ColorManager.primary,
                              backgroundColor: ColorManager.grey,
                              labelStyle: GoogleFonts.cairo(
                                color:
                                    isSelected
                                        ? ColorManager.background
                                        : ColorManager.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                color: ColorManager.background,
                                border: Border.all(
                                  color: ColorManager.white,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppSizeHeight.s50,
                                ),
                              ),
                              child: TextUtils(
                            text: '${state.ordersByStatus[option['id']]?.length ?? 0}',
                              fontSize: FontSize.s10,
                              color: ColorManager.white,
                              fontWeight: FontWeightManager.bold,
                            ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  final orders = state.orders ?? [];

                  switch (state.myOrdersState) {
                    case RequestState.loading:
                      return SizedBox(
                        height: AppSizeHeight.sMaxInfinite,
                        child: Center(
                          child: Lottie.asset(LottieManager.carLoading),
                        ),
                      );
                    case RequestState.loaded:
                      if (orders.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(LottieManager.noCars),
                              const SizedBox(height: 12),
                              TextUtils(
                                text: "لا توجد طلبات في هذه الحالة",
                                color: ColorManager.white,
                                fontSize: FontSize.s14,
                                fontWeight: FontWeightManager.bold,
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return statusCard(order);
                        },
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
          ],
        ),
      ),
    );
  }
}

Widget statusCard(MyOrders order) {
  return Card(
    shadowColor: ColorManager.primary,
    color: ColorManager.grey,
    margin: const EdgeInsets.all(10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // صورة السيارة أو صورة بديلة
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: buildCarTypeImage(order.carType),
          ),
          const SizedBox(width: 16),
          // البيانات
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextUtils(
                  text: 'هاتف العميل : ${order.whatsapp}',
                  color: ColorManager.white,
                ),
                const SizedBox(height: 4),
                TextUtils(
                  text: 'الجراج : ${order.garage.name}',
                  color: ColorManager.lightGrey,
                ),
                TextUtils(
                  text: 'الباكية : ${order.spot.code}',
                  color: ColorManager.lightGrey,
                ),
                TextUtils(
                  text: 'تمت الإضافة: ${formatDate(order.garage.addedOn)}',
                  color: ColorManager.lightGrey,
                ),
                const SizedBox(height: 6),
                // الحالة بلون خاص
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: getStatusColor(order.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    getStatusText(order.status),
                    style: TextStyle(
                      color: getStatusColor(order.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

String getStatusText(int status) {
  switch (status) {
    case 0:
      return 'منتظر';
    case 1:
      return 'تم الطلب';
    case 2:
      return 'في الطريق';
    case 3:
      return 'وصل';
    case 4:
      return 'تم التسليم';
    default:
      return 'غير معروف';
  }
}

Color getStatusColor(int status) {
  switch (status) {
    case 0:
      return Colors.orange;
    case 1:
      return Colors.blue;
    case 2:
      return Colors.teal;
    case 3:
      return Colors.green;
    case 4:
      return Colors.grey;
    default:
      return Colors.black;
  }
}

String formatDate(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    final formatter = DateFormat('dd/MM/yyyy - hh:mm a');
    return formatter.format(date);
  } catch (_) {
    return 'تاريخ غير صالح';
  }
}
