import 'package:valet_app/valete/domain/entities/my_garages.dart';
import '../../../../core/utils/enums.dart';
import '../../../domain/entities/spot.dart';

class HomeState {
  final RequestState myGaragesState;
  final String myGaragesErrorMessage;
  final List<MyGarages>? data;
  final int currentIndex;
  final bool showExtraSlots;
  final List<Spot>? extraSlots;
  final List<Spot>? mainSlots;
  final Map<Spot, int>? mainSpotsIndices;
  final Map<Spot, int>? extraSpotsIndices;

  HomeState({
    this.myGaragesState = RequestState.loading,
    this.myGaragesErrorMessage = '',
    this.data,
    this.currentIndex = 0,
    this.showExtraSlots = false,
    this.extraSlots,
    this.mainSlots,
    this.extraSpotsIndices,
    this.mainSpotsIndices
  });


  HomeState copyWith({
    RequestState? myGaragesState,
    String? myGaragesErrorMessage,
    List<MyGarages>? data,
    List<Spot>? mainSlots,
    int? currentIndex,
    bool? showExtraSlots,
    List<Spot>? extraSlots,
     Map<Spot, int>? mainSpotsIndices,
     Map<Spot, int>? extraSpotsIndices,
  }) {
    return HomeState(
      myGaragesState: myGaragesState ?? this.myGaragesState,
      myGaragesErrorMessage: myGaragesErrorMessage ?? this.myGaragesErrorMessage,
      data: data ?? this.data,
      currentIndex: currentIndex ?? this.currentIndex,
      showExtraSlots: showExtraSlots ?? this.showExtraSlots,
      extraSlots: extraSlots ?? this.extraSlots,
      mainSlots: mainSlots ?? this.mainSlots,
      extraSpotsIndices: extraSpotsIndices ?? this.extraSpotsIndices,
      mainSpotsIndices: mainSpotsIndices ?? this.mainSpotsIndices,

    );
  }
}
