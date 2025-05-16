import 'package:valet_app/valete/domain/entities/my_garages.dart';
import '../../../../core/utils/enums.dart';
import '../../../domain/entities/my_orders.dart';

class HomeState {
  final RequestState myGaragesState;
  final String myGaragesErrorMessage;
  final List<MyGarages>? data;
  final int currentIndex;
  final List<MyOrders>? orders;
  final int selectedStatus;
  final RequestState myOrdersState;
  final String myOrdersErrorMessage;
  final int status;
  HomeState({
    this.myGaragesState = RequestState.loading,
    this.myGaragesErrorMessage = '',
    this.myOrdersState = RequestState.loading,
    this.myOrdersErrorMessage = '',
    this.data,
    this.currentIndex = 0,
    this.orders = const [],
    this.selectedStatus = 0,
    this.status =0 ,
  });

  HomeState copyWith({
    String? myGaragesErrorMessage,
    RequestState? myGaragesState,
    String? myOrdersErrorMessage,
    RequestState? myOrdersState,
    List<MyGarages>? data,
    int? currentIndex,
    List<MyOrders>? orders,
    int? selectedStatus,
    int? status,
  }) {
    return HomeState(
      data: data ?? this.data,
      myGaragesErrorMessage: myGaragesErrorMessage ?? this.myGaragesErrorMessage,
      myGaragesState: myGaragesState ?? this.myGaragesState,
      currentIndex: currentIndex ?? this.currentIndex,
      orders: orders ?? this.orders,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      myOrdersErrorMessage: myOrdersErrorMessage ?? this.myOrdersErrorMessage,
      myOrdersState: myOrdersState ?? this.myOrdersState,
      status: status ?? this.status,
    );
  }
}
