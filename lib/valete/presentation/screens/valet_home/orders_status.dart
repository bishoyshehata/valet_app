import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_bloc.dart';
import 'package:valet_app/valete/presentation/controllers/home/home_states.dart';
import 'package:valet_app/valete/presentation/resources/colors_manager.dart';
import '../../../../core/services/services_locator.dart';
import '../../../domain/usecases/my_garages_use_case.dart';
import '../../../domain/usecases/my_orders_use_case.dart';
import '../../components/custom_app_bar.dart';
import '../../controllers/home/home_events.dart';
import '../../resources/values_manager.dart';

class OrdersScreen extends StatelessWidget {
  final int initialSelectedStatus =0;
  final List<Map<String, dynamic>> statusOptions = const [
    {'id': 0, 'label': 'منتظر'},
    {'id': 1, 'label': 'تم الطلب'},
    {'id': 2, 'label': 'في الطريق'},
    {'id': 3, 'label': 'وصل'},
    {'id': 4, 'label': 'تم التسليم'},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              HomeBloc(sl<MyGaragesUseCase>(), sl<MyOrdersUseCase>(),initialSelectedStatus:initialSelectedStatus)
                ..add(GetMyOrdersEvent(initialSelectedStatus)),

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
              height: 50,
              child: BlocBuilder<HomeBloc, HomeState>(
                // buildWhen: (prev, curr) => prev.selectedStatus != curr.selectedStatus,
                builder: (context, state) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: statusOptions.length,
                    itemBuilder: (context, index) {
                      final option = statusOptions[index];
                      final isSelected = state.selectedStatus == option['id'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: ChoiceChip(
                          label: Text(option['label']),
                          selected: isSelected,
                          onSelected: (_) {
                            context.read<HomeBloc>().add(GetMyOrdersEvent(option['id']));
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

                  if (orders.isEmpty) {
                    return const Center(
                      child: Text('لا يوجد طلبات بالحالة الحالية'),
                    );
                  }

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text('الطلب رقم: ${order.whatsapp}'),
                          subtitle: Text('رقم العميل: ${order.spot.code}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
