import '../../../../core/utils/enums.dart';
import '../../../domain/entities/my_orders.dart';

class MyOrdersState {
  final int selectedStatus;
  final RequestState myOrdersState;
  final String myOrdersErrorMessage;
  final int myOrdersStatusMessage;
  final int myOrdersStatusCode;
  final Map<int, List<MyOrders>> ordersByStatus;
  final UpdateOrderState updateOrderStatusState;
  final String updateOrderStatusErrorMessage;
  final bool? updateOrderStatus;
  final int? updatingOrderId;

  MyOrdersState({

    this.selectedStatus = 1,
    this.myOrdersState = RequestState.loading,
    this.myOrdersErrorMessage = '',
    this.myOrdersStatusMessage = 0,
    this.myOrdersStatusCode = 0,
    this.ordersByStatus = const {},
    this.updateOrderStatus,
    this.updatingOrderId,
    this.updateOrderStatusErrorMessage ='',
    this.updateOrderStatusState =UpdateOrderState.initial,

  });

  List<MyOrders> get orders => ordersByStatus[selectedStatus] ?? [];

  MyOrdersState copyWith({
    int? selectedStatus,
    RequestState? myOrdersState,
    String? myOrdersErrorMessage,
    int? myOrdersStatusMessage,
    int? myOrdersStatusCode,
    Map<int, List<MyOrders>>? ordersByStatus,
    UpdateOrderState? updateOrderStatusState,
    String? updateOrderStatusErrorMessage,
    bool? updateOrderStatus,
    int? updatingOrderId,

  }) {
    return MyOrdersState(
      selectedStatus: selectedStatus ?? this.selectedStatus,
      myOrdersState: myOrdersState ?? this.myOrdersState,
      myOrdersErrorMessage: myOrdersErrorMessage ?? this.myOrdersErrorMessage,
      myOrdersStatusMessage: myOrdersStatusMessage ?? this.myOrdersStatusMessage,
      myOrdersStatusCode: myOrdersStatusCode ?? this.myOrdersStatusCode,
      ordersByStatus: ordersByStatus ?? this.ordersByStatus,
      updateOrderStatusState: updateOrderStatusState ?? this.updateOrderStatusState,
      updateOrderStatusErrorMessage: updateOrderStatusErrorMessage ?? this.updateOrderStatusErrorMessage,
      updateOrderStatus: updateOrderStatus ?? this.updateOrderStatus,
      updatingOrderId: updatingOrderId ?? this.updatingOrderId,

    );
  }
}
