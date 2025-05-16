import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      create: (context) => HomeBloc(sl<MyGaragesUseCase>(),sl<MyOrdersUseCase>())..add(GetMyOrdersEvent(0)),
      child: Scaffold(
        appBar: AppBar(title: const Text('إدارة الطلبات')),
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
                            context.read<HomeBloc>().add(
                                ChangeSelectedStatus(option['id']));
                          },
                          selectedColor: Colors.blueAccent,
                          backgroundColor: Colors.grey.shade300,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
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
                  print(state.orders);
                  final orders = state.orders!
                      .where((order) => order.status == state.selectedStatus)
                      .toList();

                  if (orders.isEmpty) {
                    return const Center(
                        child: Text('لا يوجد طلبات بالحالة الحالية'));
                  }

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text('الطلب رقم: ${order.id}'),
                          subtitle: Text('رقم العميل: ${order.clientId}'),
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
