import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valet_app/valete/domain/usecases/my_garages_use_case.dart';
import 'package:valet_app/valete/domain/usecases/my_orders_use_case.dart';
import '../../../../core/utils/enums.dart';
import '../../../domain/entities/my_orders.dart';
import 'home_events.dart';
import 'home_states.dart';
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MyGaragesUseCase myGaragesUseCase;
  final MyOrdersUseCase myOrdersUseCase;

  HomeBloc(this.myGaragesUseCase, this.myOrdersUseCase, {int initialSelectedStatus = 1})
      : super(HomeState(selectedStatus: initialSelectedStatus, currentIndex: 0)) {

    // 🚗 تحميل الجراجات
    on<GetMyGaragesEvent>((event, emit) async {
      final result = await myGaragesUseCase.myGarages();
      result.fold(
            (error) => emit(state.copyWith(
          myGaragesState: RequestState.error,
          myGaragesErrorMessage: error.message,
        )),
            (data) => emit(state.copyWith(
          myGaragesState: RequestState.loaded,
          data: data,
        )),
      );
    });

    // 🟠 تحميل الطلبات حسب الحالة + حفظها
    on<GetMyOrdersEvent>((event, emit) async {
      final int status = event.newStatus;

      // لو البيانات موجودة بالفعل، غير بس الحالة المختارة
      if (state.ordersByStatus.containsKey(status)) {
        emit(state.copyWith(
          selectedStatus: status,
          myOrdersState: RequestState.loaded,
        ));
        return;
      }

      // تحميل جديد لو مش موجود
      emit(state.copyWith(
        selectedStatus: status,
        myOrdersState: RequestState.loading,
      ));

      final result = await myOrdersUseCase.myOrders(status);
      result.fold(
            (error) => emit(state.copyWith(
          myOrdersState: RequestState.error,
          myOrdersErrorMessage: error.message,
        )),
            (ordersList) {
          final updatedMap = Map<int, List<MyOrders>>.from(state.ordersByStatus);
          updatedMap[status] = ordersList;

          emit(state.copyWith(
            myOrdersState: RequestState.loaded,
            ordersByStatus: updatedMap,
          ));
        },
      );
    });
    on<GetAllMyOrdersEvent>((event, emit) async {
      emit(state.copyWith(myOrdersState: RequestState.loading));

      Map<int, List<MyOrders>> newOrdersByStatus = {};

      for (int status = 0; status <= 4; status++) {
        final result = await myOrdersUseCase.myOrders(status);

        result.fold(
              (error) {
            emit(state.copyWith(
              myOrdersState: RequestState.error,
              myOrdersErrorMessage: error.message,
            ));
            return; // وقف اللوب لو في خطأ
          },
              (data) {
            newOrdersByStatus[status] = data;
          },
        );
      }

      emit(state.copyWith(
        myOrdersState: RequestState.loaded,
        ordersByStatus: newOrdersByStatus,
      ));
    });


    on<ChangeTabEvent>((event, emit) {
      emit(state.copyWith(currentIndex: event.index));
    });
  }
}

