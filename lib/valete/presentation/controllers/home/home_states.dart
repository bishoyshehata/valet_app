import 'package:valet_app/valete/domain/entities/my_garages.dart';
import '../../../../core/utils/enums.dart';
import '../../../domain/entities/my_orders.dart';

class HomeState {
  final RequestState myGaragesState;
  final String myGaragesErrorMessage;
  final List<MyGarages>? data;
  final int currentIndex;

  HomeState({
    this.myGaragesState = RequestState.loading,
    this.myGaragesErrorMessage = '',
    this.data,
    this.currentIndex = 0,

  });


  HomeState copyWith({
    RequestState? myGaragesState,
    String? myGaragesErrorMessage,
    List<MyGarages>? data,
    int? currentIndex,

  }) {
    return HomeState(
      myGaragesState: myGaragesState ?? this.myGaragesState,
      myGaragesErrorMessage: myGaragesErrorMessage ?? this.myGaragesErrorMessage,
      data: data ?? this.data,
      currentIndex: currentIndex ?? this.currentIndex,

    );
  }
}
