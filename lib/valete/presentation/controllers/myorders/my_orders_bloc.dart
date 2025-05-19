import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valet_app/valete/domain/usecases/my_orders_use_case.dart';
import 'package:valet_app/valete/domain/usecases/update_order_status_use_case.dart';
import '../../../../core/utils/enums.dart';
import '../../../domain/entities/my_orders.dart';
import 'my_orders_events.dart';
import 'my_orders_states.dart';

class MyOrdersBloc extends Bloc<MyOrdersEvent, MyOrdersState> {
  final MyOrdersUseCase myOrdersUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;

  MyOrdersBloc(
    this.myOrdersUseCase,
    this.updateOrderStatusUseCase,
      {
    int initialSelectedStatus = 0,
  }) : super(
         MyOrdersState(selectedStatus: initialSelectedStatus),
       ) {
    on<GetMyOrdersEvent>((event, emit) async {
      final int status = event.newStatus;

      // لو البيانات موجودة بالفعل، غير بس الحالة المختارة
      if (state.ordersByStatus.containsKey(status)) {
        emit(
          state.copyWith(
            selectedStatus: status,
            myOrdersState: RequestState.loading, // تغيير مؤقت
          ),
        );
        emit(
          state.copyWith(
            selectedStatus: status,
            myOrdersState: RequestState.loaded,
          ),
        );
        return;
      }

      // تحميل جديد لو مش موجود
      emit(
        state.copyWith(
          selectedStatus: status,
          myOrdersState: RequestState.loading,
        ),
      );

      final result = await myOrdersUseCase.myOrders(status);
      result.fold(
        (error) => emit(
          state.copyWith(
            myOrdersState: RequestState.error,
            myOrdersErrorMessage: error.message,
          ),
        ),
        (ordersList) {
          final updatedMap = Map<int, List<MyOrders>>.from(
            state.ordersByStatus,
          );
          updatedMap[status] = ordersList;

          emit(
            state.copyWith(
              myOrdersState: RequestState.loaded,
              ordersByStatus: updatedMap,
            ),
          );
        },
      );
    });
    on<GetAllMyOrdersEvent>((event, emit) async {
      Map<int, List<MyOrders>> newOrdersByStatus = {};

      for (int status = 0; status <= 4; status++) {
        final result = await myOrdersUseCase.myOrders(status);

        result.fold(
          (error) {
            emit(
              state.copyWith(
                myOrdersState: RequestState.error,
                myOrdersErrorMessage: error.message,
              ),
            );
            return; // وقف اللوب لو في خطأ
          },
          (data) {
            newOrdersByStatus[status] = List.from(data);
          },
        );
      }

      emit(
        state.copyWith(
          myOrdersState: RequestState.loaded,
          ordersByStatus: newOrdersByStatus,
        ),
      );
    });
    on<UpdateOrderStatusEvent>((event, emit) async {
      emit(state.copyWith(
        updateOrderStatusState: UpdateOrderState.loading,
        updatingOrderId: event.orderId,
      ));
      final result = await updateOrderStatusUseCase.updateOrderStatus(
        event.orderId,
        event.newStatus,
      );

      result.fold(
        (error) => emit(
          state.copyWith(
            updateOrderStatusErrorMessage: error.message,
            updateOrderStatusState: UpdateOrderState.error,
          ),
        ),
        (data) {
          emit(
            state.copyWith(
              updateOrderStatus: data,
              updateOrderStatusState: UpdateOrderState.loaded,
              updatingOrderId: event.orderId,
            ),
          );
           add(GetMyOrdersEvent(event.newStatus) );

        }
      );
    });
  }
}
