import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valet_app/valete/domain/usecases/my_garages_use_case.dart';
import 'package:valet_app/valete/domain/usecases/my_orders_use_case.dart';
import '../../../../core/utils/enums.dart';
import 'home_events.dart';
import 'home_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  MyGaragesUseCase myGaragesUseCase;
  MyOrdersUseCase myOrdersUseCase;

  HomeBloc(this.myGaragesUseCase,this.myOrdersUseCase)
      : super(HomeState(currentIndex: 0)) {

    on<GetMyGaragesEvent>((event, emit) async {
      final result = await myGaragesUseCase.myGarages();
      result.fold((error)=> emit(state.copyWith(myGaragesState:RequestState.error , myGaragesErrorMessage :error.message )),
              (data)=> emit(state.copyWith(myGaragesState:RequestState.loaded , data: data)));
    });
    on<GetMyOrdersEvent>((event, emit) async {
      final result = await myOrdersUseCase.myOrders(event.status);
      result.fold((error)=> emit(state.copyWith(myOrdersState:RequestState.error , myOrdersErrorMessage :error.message )),
              (data)=> emit(state.copyWith(myOrdersState:RequestState.loaded , orders: data)));
    });
    on<ChangeTabEvent>((event, emit) {
      emit(state.copyWith(currentIndex:  event.index));
    });
    on<ChangeSelectedStatus>((event, emit) {
      emit(state.copyWith(selectedStatus: event.newStatus));
    });
  }

}


