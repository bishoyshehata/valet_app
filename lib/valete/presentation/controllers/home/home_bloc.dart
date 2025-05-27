import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valet_app/valete/domain/usecases/my_garages_use_case.dart';
import '../../../../core/utils/enums.dart';
import '../../../domain/entities/spot.dart';
import 'home_events.dart';
import 'home_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MyGaragesUseCase myGaragesUseCase;

  HomeBloc(
    this.myGaragesUseCase,
      {
    int initialSelectedStatus = 0,
  }) : super(
         HomeState(currentIndex: 0),
       ) {
    on<GetMyGaragesEvent>(_getMyGarages);
    on<ToggleExtraSlotsVisibilityEvent>(_toggleExtraSlotsVisibility);

    on<ChangeTabEvent>((event, emit) {
      emit(state.copyWith(currentIndex: event.index));
    });



  }

  Future<void> _getMyGarages(GetMyGaragesEvent event, Emitter<HomeState> emit) async {
    // (اختياري) يمكنك إصدار حالة تحميل هنا إذا أردت
    // emit(state.copyWith(myGaragesState: RequestState.loading));

    final result = await myGaragesUseCase.myGarages(); // استدعاء الـ UseCase

    result.fold(
          (error) {
        // في حالة الخطأ، قم بتحديث الحالة برسالة الخطأ
        emit(
          state.copyWith(
            myGaragesState: RequestState.error,
            myGaragesErrorMessage: error.message, // افترض أن Failure له خاصية message
          ),
        );
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
  void _toggleExtraSlotsVisibility(ToggleExtraSlotsVisibilityEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(showExtraSlots: event.show));
  }
}
