import 'package:valet_app/valete/domain/entities/my_garages.dart';
import '../../../../core/utils/enums.dart';
import '../../../domain/entities/my_orders.dart';

class HomeState {
  final RequestState myGaragesState;
  final String myGaragesErrorMessage;
  final List<MyGarages>? data;
  final int currentIndex;
  final int selectedStatus;
  final RequestState myOrdersState;
  final String myOrdersErrorMessage;
  final Map<int, List<MyOrders>> ordersByStatus;

  HomeState({
    this.myGaragesState = RequestState.loading,
    this.myGaragesErrorMessage = '',
    this.data,
    this.currentIndex = 0,
    this.selectedStatus = 1,
    this.myOrdersState = RequestState.loading,
    this.myOrdersErrorMessage = '',
    this.ordersByStatus = const {},
  });

  List<MyOrders> get orders => ordersByStatus[selectedStatus] ?? [];

  HomeState copyWith({
    RequestState? myGaragesState,
    String? myGaragesErrorMessage,
    List<MyGarages>? data,
    int? currentIndex,
    int? selectedStatus,
    RequestState? myOrdersState,
    String? myOrdersErrorMessage,
    Map<int, List<MyOrders>>? ordersByStatus,
  }) {
    return HomeState(
      myGaragesState: myGaragesState ?? this.myGaragesState,
      myGaragesErrorMessage: myGaragesErrorMessage ?? this.myGaragesErrorMessage,
      data: data ?? this.data,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      myOrdersState: myOrdersState ?? this.myOrdersState,
      myOrdersErrorMessage: myOrdersErrorMessage ?? this.myOrdersErrorMessage,
      ordersByStatus: ordersByStatus ?? this.ordersByStatus,
    );
  }
}
