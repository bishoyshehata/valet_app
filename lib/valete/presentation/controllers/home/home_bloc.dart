import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valet_app/valete/domain/usecases/get_garage_spot_use_case.dart';
import 'package:valet_app/valete/domain/usecases/my_garages_use_case.dart';
import 'package:valet_app/valete/domain/usecases/update_order_spot_use_case.dart';
import '../../../../core/utils/enums.dart';
import '../../../domain/entities/spot.dart';
import 'home_events.dart';
import 'home_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MyGaragesUseCase myGaragesUseCase;
  final GetGarageSpotUseCase getGarageSpotUseCase;
  final UpdateOrderSpotUseCase updateOrderSpotUseCase;

  HomeBloc(
    this.myGaragesUseCase,
    this.getGarageSpotUseCase,
    this.updateOrderSpotUseCase,
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
          emit(
            state.copyWith(
              getGaragesSpotErrorMessage: error.message,
              getGaragesSpotState: RequestState.error,
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
        debugPrint('✖️ Error Message: ${error.message}');
        debugPrint('📡 Status Code: ${error.statusCode}');

        emit(state.copyWith(
          myGaragesState: RequestState.error,
          myGaragesErrorMessage: error.message,
          garagesStatusCode: error.statusCode,
        ));
      },
      (data) {
        // في حالة النجاح، قم بتحديث الحالة بقائمة الجراجات المستلمة فقط
        emit(
          state.copyWith(
            myGaragesState: RequestState.loaded,
            data: data, // تخزين قائمة الجراجات كما هي
            // لا تقم بتعبئة extraSlots أو mainSlots هنا
          ),
        );
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
