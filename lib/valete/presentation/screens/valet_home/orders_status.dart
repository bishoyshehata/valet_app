import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:valet_app/core/utils/enums.dart';
import 'package:valet_app/valete/presentation/components/custom_bottun.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import '../../../../core/network/api_constants.dart';
import '../../../domain/entities/my_orders.dart';
import '../../components/custom_app_bar.dart';
import '../../components/text/text_utils.dart';
import '../../controllers/myorders/my_orders_bloc.dart';
import '../../controllers/myorders/my_orders_events.dart';
import '../../controllers/myorders/my_orders_states.dart';
import '../../resources/assets_manager.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';
import '../garage_screen/garage_screen.dart';
import '../login/login.dart';

class OrdersScreen extends StatelessWidget {
  final int initialSelectedStatus = 0;
  final List<Map<String, dynamic>> statusOptions = const [
    {'id': 0, 'label': 'في الإنتظار'},
    {'id': 1, 'label': 'مطلوب'},
    {'id': 2, 'label': 'في الطريق'},
    {'id': 3, 'label': 'وصل'},
    {'id': 4, 'label': 'تم التسليم'},
  ];

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<MyOrdersBloc>().add(GetAllMyOrdersEvent());

    return Scaffold(
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

      body: RefreshIndicator(
        onRefresh: () async {
          context.read<MyOrdersBloc>().add(GetAllMyOrdersEvent());
        },
        child: Column(
          children: [
            SizedBox(
              height: 70,
              child: BlocBuilder<MyOrdersBloc, MyOrdersState>(
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
                              elevation: 0,
                              label: Text(option['label']),
                              selected: isSelected,
                              onSelected: (_) {
                                context.read<MyOrdersBloc>().add(
                                  GetMyOrdersEvent(option['id']),
                                );
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
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 20,
                                  minHeight: 20,
                                ),
                                decoration: BoxDecoration(
                                  color:option['id'] == 1  && state.ordersByStatus[option['id']]!.length > 0 ?ColorManager.warning :ColorManager.background,
                                  border: Border.all(
                                    color: ColorManager.white,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppSizeHeight.s50,
                                  ),
                                ),
                                child: Center(
                                  child: TextUtils(
                                    text:
                                        '${state.ordersByStatus[option['id']]?.length ?? 0}',
                                    fontSize: FontSize.s10,
                                    color: ColorManager.white,
                                    fontWeight: FontWeightManager.bold,
                                  ),
                                ),
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
              child: BlocBuilder<MyOrdersBloc, MyOrdersState>(
                // buildWhen: (previous, current) => previous.orders != current.orders ,
                builder: (context, state) {
                  final orders = state.ordersByStatus[state.selectedStatus] ?? [];

                  switch (state.myOrdersState) {
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
                      if (orders.isEmpty) {
                        return FutureBuilder(
                          future: Future.delayed(Duration(seconds: 2)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              // بنعرض shimmer مؤقت لحد ما نفحص فعلاً إن مفيش طلبات
                              return SizedBox(
                                height: AppSizeHeight.sMaxInfinite,
                                child: ListView.separated(
                                  shrinkWrap: true,
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
                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                  separatorBuilder:
                                      (context, index) => SizedBox(height: 10),
                                  itemCount: 4,
                                ),
                              );
                            } else {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset(LottieManager.noCars),
                                    const SizedBox(height: 12),
                                    TextUtils(
                                      text: "لا توجد طلبات",
                                      color: ColorManager.white,
                                      fontSize: FontSize.s14,
                                      fontWeight: FontWeightManager.bold,
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        );
                      }
                      return ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return statusCard(order, context);
                        },
                      );
                    case RequestState.error:
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: Lottie.asset(LottieManager.noCars)),
                          TextUtils(
                            text:
                                "عذراً بقد إنتهت الجلسة برجء تسجيل الدخول مرة أخرى",
                            color: ColorManager.white,
                            fontSize: FontSize.s13,
                            noOfLines: 2,
                            overFlow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: AppSizeHeight.s30),
                          CustomButton(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            btnColor: ColorManager.primary,
                            widget: TextUtils(
                              text: 'إعادة التسجيل',
                              color: ColorManager.background,
                              fontWeight: FontWeightManager.bold,
                            ),
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

Widget statusCard(MyOrders order, BuildContext context) {
  return BlocListener<MyOrdersBloc, MyOrdersState>(
    listenWhen:
        (prev, curr) =>
            prev.updateOrderStatus != curr.updateOrderStatus &&
            curr.updateOrderStatus == true &&
            curr.updatingOrderId == order.id,
    listener: (context, state) {
      context.read<MyOrdersBloc>().add(GetAllMyOrdersEvent());
      // // Reset state to avoid repeated triggers
      context.read<MyOrdersBloc>().add(ResetOrderUpdateStatus());
    },
    child: Card(
      color: ColorManager.grey,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // صورة السيارة أو صورة بديلة
            SizedBox(
              width: AppSizeWidth.s75,
              height: AppSizeHeight.s80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    order.carImage != null
                        ? FadeInImage.assetNetwork(
                      placeholder: buildCarTypeImageForStatus(order.carType), // الصورة المؤقتة من الأصول
                      image: Uri.encodeFull("${ApiConstants.baseUrl}/${order.carImage!}"),
                      height: AppSizeHeight.s45,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return buildCarTypeImage(order.carType);
                      },
                    )
                        : buildCarTypeImage(order.carType),
              ),
            ),

            const SizedBox(width: 16),
            // البيانات
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'هاتف العميل : ',
                      style: GoogleFonts.cairo(
                        fontSize: FontSize.s13,
                        fontWeight: FontWeight.normal,
                        color: ColorManager.white,
                      ),
                      children: [
                        TextSpan(
                          text: order.whatsapp.replaceRange(0,8,''),
                          style: GoogleFonts.archivo(
                            fontSize: FontSize.s13,
                            fontWeight: FontWeight.normal,
                            color: ColorManager.white,
                          ),
                        ),
                        TextSpan(
                          text: '########',
                          style: GoogleFonts.archivo(
                            fontSize: FontSize.s13,
                            fontWeight: FontWeight.normal,
                            color: ColorManager.white,
                          ),
                        ),
                      ],
                    ),
                     // ✅ تأكد إنها كده بالظبط
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
                  SizedBox(height: AppSizeHeight.s5),
                  BlocBuilder<MyOrdersBloc, MyOrdersState>(
                    builder: (context, state) {
                      return getStatusButton(
                        order.status,
                        context,
                        order.id,
                        state,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

String getStatusText(int status) {
  switch (status) {
    case 0:
      return 'منتظر';
    case 1:
      return 'مطلوب الأن';
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

Widget getStatusButton(
  int status,
  BuildContext context,
  int orderId,
  MyOrdersState state,
) {
  switch (status) {
    case 0:
      return SizedBox();
    case 1:
      return CustomButton(
        onTap: () {
          context.read<MyOrdersBloc>().add(UpdateOrderStatusEvent(orderId, 2));
        },
        btnColor: ColorManager.warning,
        widget: buildButtonContent(
          state.updatingOrderId == orderId
              ? state.updateOrderStatusState
              : UpdateOrderState.initial,
          'أنا في طريقي',
        ),
        height: AppSizeHeight.s35,
      );
    case 2:
      return CustomButton(
        onTap: () {
          context.read<MyOrdersBloc>().add(UpdateOrderStatusEvent(orderId, 3));
        },
        btnColor: ColorManager.primary,
        widget: buildButtonContent(
          state.updatingOrderId == orderId
              ? state.updateOrderStatusState
              : UpdateOrderState.initial,
          'لقد وصلت',
        ),
        height: AppSizeHeight.s35,
      );
    case 3:
      return CustomButton(
        onTap: () {
          context.read<MyOrdersBloc>().add(UpdateOrderStatusEvent(orderId, 4));
        },
        btnColor: ColorManager.primary,
        widget: buildButtonContent(
          state.updatingOrderId == orderId
              ? state.updateOrderStatusState
              : UpdateOrderState.initial,
          'تم التسليم',
        ),
        height: AppSizeHeight.s35,
      );
    default:
      return SizedBox();
  }
}

Color getStatusColor(int status) {
  switch (status) {
    case 0:
      return Colors.orange;
    case 1:
      return Colors.redAccent;
    case 2:
      return Colors.white;
    case 3:
      return Colors.white;
    case 4:
      return Colors.greenAccent;
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

Widget getLoadingWidget(UpdateOrderState state) {
  if (state == UpdateOrderState.loading) {
    return Lottie.asset(LottieManager.carLoading);
  } else if (state == UpdateOrderState.error) {
    return TextUtils(
      text: 'حدثت مشكلة تواصل مع المدير',
      color: ColorManager.background,
      fontWeight: FontWeightManager.bold,
    );
  } else {
    // initial or loaded
    return TextUtils(
      text: 'أنا في طريقي إليك',
      color: ColorManager.background,
      fontWeight: FontWeightManager.bold,
    );
  }
}

Widget buildButtonContent(UpdateOrderState state, String text) {
  return switch (state) {
    UpdateOrderState.initial || UpdateOrderState.loaded => TextUtils(
      text: text,
      color: ColorManager.background,
      fontWeight: FontWeightManager.bold,
    ),
    UpdateOrderState.loading => Lottie.asset(LottieManager.carLoading),
    UpdateOrderState.error => TextUtils(
      text: 'حدثت مشكلة تواصل مع المدير',
      color: ColorManager.background,
      fontWeight: FontWeightManager.bold,
    ),
  };
}

