import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valet_app/valete/domain/usecases/cancel_order_use_case.dart';
import 'package:valet_app/valete/domain/usecases/my_orders_use_case.dart';
import 'package:valet_app/valete/domain/usecases/update_order_status_use_case.dart';
import '../../../../core/utils/enums.dart';
import '../../../domain/entities/my_orders.dart';
import 'my_orders_events.dart';
import 'my_orders_states.dart';

class MyOrdersBloc extends Bloc<MyOrdersEvent, MyOrdersState> {
  final MyOrdersUseCase myOrdersUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;
  final CancelOrderUseCase cancelOrderUseCase;

  MyOrdersBloc(
    this.myOrdersUseCase,
    this.updateOrderStatusUseCase,
      this.cancelOrderUseCase,
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
        (error) {
          print(error.message);
          print(error.statusCode);

          emit(
            state.copyWith(
              myOrdersState: RequestState.error,
              myOrdersErrorMessage: error.message,
               myOrdersStatusCode: error.statusCode
            ),
          );
        },
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

      List<int> statusesToLoad = event.statuses ?? [0, 1, 2, 3, 4];

      for (int status in statusesToLoad) {
        final result = await myOrdersUseCase.myOrders(status);

        bool hasError = false;

        result.fold(
              (error) {
                print(error.message);
            emit(
              state.copyWith(
                myOrdersState: RequestState.error,
                myOrdersErrorMessage: error.message,
                myOrdersStatusCode: error.statusCode,
              ),
            );
            hasError = true;
          },
              (data) {
            newOrdersByStatus[status] = List.from(data);
          },
        );

        if (hasError) return; // 👈 نخرج من الحدث خالص لو فيه خطأ
      }

      // لو مفيش error، نعمل emit للحالة المحملة
      final updatedMap = Map<int, List<MyOrders>>.from(state.ordersByStatus)
        ..addAll(newOrdersByStatus);

      emit(
        state.copyWith(
          myOrdersState: RequestState.loaded,
          ordersByStatus: updatedMap,
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
              updateOrderStatus: data.succeeded,
              orderStatus: data,
              updateOrderStatusState: UpdateOrderState.loaded,
              updatingOrderId: event.orderId,
            ),
          );
          launchUrl(Uri.parse(data.data.toString()));

           add(GetMyOrdersEvent(event.newStatus) );

        }

      );
      // رجع الطلبات الجديدة

      add(GetMyOrdersEvent(event.newStatus));
      add(GetAllMyOrdersEvent());

      // ✳️ ثم نظف الحالة
      add(ResetOrderUpdateStatus());
    });
    on<ResetOrderUpdateStatus>((event, emit) {
      emit(
        state.copyWith(
          updateOrderStatus:false ,
          updateOrderStatusState: UpdateOrderState.initial,
          updatingOrderId: null,
        ),
      );
    });
    on<CancelMyOrderEvent>((event, emit) async{
      emit(state.copyWith(cancelOrderState: UpdateOrderState.loading));
      final result = await cancelOrderUseCase.cancelOrder(event.orderId);

      result.fold((error){
        print(error);

        emit(state.copyWith(cancelOrderErrorMessage: error.message,cancelOrderState: UpdateOrderState.error));
      }, (result){
        print(result);
        emit(state.copyWith(cancelOrderResult: result,cancelOrderState: UpdateOrderState.loaded));

      });
    });
  }
}
