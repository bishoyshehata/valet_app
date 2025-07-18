import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valet_app/valete/domain/usecases/get_garage_spot_use_case.dart';
import 'package:valet_app/valete/domain/usecases/my_garages_use_case.dart';
import 'package:valet_app/valete/domain/usecases/update_order_spot_use_case.dart';
import '../../../../core/utils/enums.dart';
import '../../../domain/entities/spot.dart';
import '../../../domain/usecases/cancel_order_use_case.dart';
import 'home_events.dart';
import 'home_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MyGaragesUseCase myGaragesUseCase;
  final GetGarageSpotUseCase getGarageSpotUseCase;
  final UpdateOrderSpotUseCase updateOrderSpotUseCase;
  final CancelOrderUseCase cancelOrderUseCase;

  HomeBloc(
    this.myGaragesUseCase,
    this.getGarageSpotUseCase,
    this.updateOrderSpotUseCase,
    this.cancelOrderUseCase,
      {
    int initialSelectedStatus = 0,
  }) : super(HomeState(currentIndex: 0)) {
    on<GetMyGaragesEvent>(_getMyGarages);
    on<GetGarageSpotEvent>((event, emit) async {
      final garageSpots = await getGarageSpotUseCase.getGarageSpot(
        event.garageId,
      );
      garageSpots.fold(
        (error) {
          print(error.statusCode);
          emit(
            state.copyWith(
              getGaragesSpotErrorMessage: error.message,
              getGaragesSpotState: RequestState.error,
                getGaragesSpotStatusCode: error.statusCode
            ),
          );
        },
        (garageSpots) {
          emit(
            state.copyWith(
                getGaragesSpotState: RequestState.loaded,
                mainSpots: garageSpots.mainSpots,
                extraSpots: garageSpots.extraSpots,
                emptySpots: garageSpots.emptySpots,
                allSpots: garageSpots
            ),
          );
        }
      );
    });
    on<UpdateOrderSpotEvent>((event,emit)async {
      emit(state.copyWith(updateOrderSpotState: UpdateOrderSpotState.loading));

      final updateResult  = await updateOrderSpotUseCase.updateOrderSpot(event.orderId, event.spotId,event.garageId);
      updateResult.fold((error){

        emit(state.copyWith(updateOrderSpotErrorMessage: error.message,updateOrderSpotState: UpdateOrderSpotState.error));
      }, (result){
          emit(state.copyWith(updateOrderSpotState: UpdateOrderSpotState.loaded,updateResult: result));

      });
      await Future.delayed(Duration(milliseconds: 500));

    });
    on<ToggleExtraSlotsVisibilityEvent>(_toggleExtraSlotsVisibility);

    on<ChangeTabEvent>((event, emit) {
      emit(state.copyWith(currentIndex: event.index));
    });

    on<UpdateSpotNameEvent>((event, emit) {
      emit(state.copyWith(spotName: event.spotName));
    });
    on<UpdateGarageNameEvent>((event, emit) {
      emit(state.copyWith(garageId: event.garageName));
    });
    on<ResetSpotNameEvent>((event, emit) {
      emit(state.copyWith(spotName: 'رقم الباكية',garageId: 'رقم الباكية')); // أو '' حسب نوع spotName
    });
    on<CancelHomeOrderEvent>((event, emit) async{
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

  Future<void> _getMyGarages(
    GetMyGaragesEvent event,
    Emitter<HomeState> emit,
  ) async {
    // (اختياري) يمكنك إصدار حالة تحميل هنا إذا أردت
    // emit(state.copyWith(myGaragesState: RequestState.loading));

    final result = await myGaragesUseCase.myGarages(); // استدعاء الـ UseCase

    result.fold(
          (error) {
            print('📡 Status Code: ${error.statusCode ?? 'غير متوفر'}');

        emit(state.copyWith(
          myGaragesState: RequestState.error,
          myGaragesErrorMessage: error.message,
          garagesStatusCode: error.statusCode,
        ));
      },
          (data) {
        emit(state.copyWith(
          myGaragesState: RequestState.loaded,
          data: data,
        ));
      },
    );

  }

  // احتفظ بهذا المعالج إذا كنت لا تزال تريد مفتاح تبديل عام
  void _toggleExtraSlotsVisibility(
    ToggleExtraSlotsVisibilityEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(showExtraSlots: event.show));
  }
}
