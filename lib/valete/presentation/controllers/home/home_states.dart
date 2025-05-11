import 'dart:io';
import 'dart:typed_data';
import 'package:valet_app/valete/domain/entities/create_order.dart';

import '../../../../core/utils/enums.dart';

class HomeState {

  final RequestState phoneNumberState;
  final String phoneNumber;
  HomeState({
     this.phoneNumberState = RequestState.loading,
     this.phoneNumber ='',
  });

  HomeState copyWith({
     String? phoneNumber,
    RequestState? phoneNumberState,
  }) {
    return HomeState(

      phoneNumber: phoneNumber ?? this.phoneNumber,
      phoneNumberState: phoneNumberState ?? this.phoneNumberState,
    );
  }
}
