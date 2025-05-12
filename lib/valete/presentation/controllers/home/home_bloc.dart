import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:valet_app/valete/domain/usecases/create_order_use_case.dart';
import 'package:valet_app/valete/domain/usecases/my_garages_use_case.dart';
import '../../../../core/utils/enums.dart';
import 'home_events.dart';
import 'home_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  MyGaragesUseCase myGaragesUseCase;

  HomeBloc(this.myGaragesUseCase)
      : super(HomeState()) {

    on<GetMyGaragesEvent>((event, emit) async {
      final result = await myGaragesUseCase.myGarages();
      result.fold((error)=> emit(state.copyWith(myGaragesState:RequestState.error , myGaragesErrorMessage :error.message  )),
              (data)=> emit(state.copyWith(myGaragesState:RequestState.loaded , data: data )));
    });

  }
}


