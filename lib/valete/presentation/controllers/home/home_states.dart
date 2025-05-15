import 'package:valet_app/valete/domain/entities/my_garages.dart';
import '../../../../core/utils/enums.dart';

class HomeState {

  final RequestState myGaragesState;
  final String myGaragesErrorMessage;
  final List<MyGarages>? data;
  final int currentIndex;

  HomeState({
     this.myGaragesState = RequestState.loading,
     this.myGaragesErrorMessage ='',
      this.data,
      required this.currentIndex,
  });

  HomeState copyWith({
     String? myGaragesErrorMessage,
    RequestState? myGaragesState,
    List<MyGarages>? data,
    required int currentIndex,
  }) {
    return HomeState(
      data: data ?? this.data,
      myGaragesErrorMessage: myGaragesErrorMessage ?? this.myGaragesErrorMessage ,
      myGaragesState: myGaragesState ?? this.myGaragesState,
      currentIndex: currentIndex,
    );
  }
}
