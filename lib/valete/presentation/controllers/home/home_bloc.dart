import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:valet_app/valete/domain/usecases/create_order_use_case.dart';
import '../../../../core/utils/enums.dart';
import 'home_events.dart';
import 'home_states.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  HomeBloc()
      : super(HomeState(phoneNumber: '')) {

    on<PhoneNumberReceived>((event, emit) {
      emit(state.copyWith(
        phoneNumber: event.phoneNumber,
        phoneNumberState: event.phoneNumber.isNotEmpty
            ? RequestState.loaded
            : RequestState.loading,
      ));
    });

  }
}


