import 'package:valet_app/valete/domain/entities/my_garages.dart';
import '../../../../core/utils/enums.dart';

class HomeState {

  final RequestState myGaragesState;
  final String myGaragesErrorMessage;
  final List<MyGarages>? data;

  HomeState({
     this.myGaragesState = RequestState.loading,
     this.myGaragesErrorMessage ='',
      this.data,
  });

  HomeState copyWith({
     String? myGaragesErrorMessage,
    RequestState? myGaragesState,
    List<MyGarages>? data,
  }) {
    return HomeState(
      data: data ?? this.data,
      myGaragesErrorMessage: myGaragesErrorMessage ?? this.myGaragesErrorMessage ,
      myGaragesState: myGaragesState ?? this.myGaragesState,
    );
  }
}
