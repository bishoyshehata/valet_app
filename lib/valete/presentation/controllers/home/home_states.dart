import 'package:valet_app/valete/domain/entities/get_garage_spot.dart';
import 'package:valet_app/valete/domain/entities/my_garages.dart';
import '../../../../core/utils/enums.dart';
import '../../../domain/entities/spot.dart';

class HomeState {
  final RequestState myGaragesState;
  final RequestState getGaragesSpotState;
  final String myGaragesErrorMessage;
  final String getGaragesSpotErrorMessage;
  final List<MyGarages>? data;
  final int currentIndex;
  final bool showExtraSlots;
  final GetGarageSpot? allSpots;
  final List<Spot>? extraSpots;
  final List<Spot>? mainSpots;
  final List<Spot>? emptySpots;
  final Map<Spot, int>? mainSpotsIndices;
  final Map<Spot, int>? extraSpotsIndices;
  final String spotName;
  final bool? updateResult;
  final String updateOrderSpotErrorMessage;
  final RequestState updateOrderSpotState;

  HomeState({
    this.myGaragesState = RequestState.loading,
    this.getGaragesSpotState = RequestState.loading,
    this.myGaragesErrorMessage = '',
    this.getGaragesSpotErrorMessage = '',
    this.updateOrderSpotErrorMessage = '',
    this.updateOrderSpotState = RequestState.loading,
    this.updateResult,
    this.data,
    this.currentIndex = 0,
    this.showExtraSlots = true,
    this.extraSpots,
    this.mainSpots,
    this.emptySpots,
    this.allSpots,
    this.extraSpotsIndices,
    this.mainSpotsIndices ,
    this.spotName = 'رقم الباكية',

  });


  HomeState copyWith({
    RequestState? myGaragesState,
    RequestState? getGaragesSpotState,
    String? myGaragesErrorMessage,
    String? getGaragesSpotErrorMessage,
    List<MyGarages>? data,
    GetGarageSpot? allSpots,
    List<Spot>? extraSpots,
    List<Spot>? mainSpots,
    List<Spot>? emptySpots,
    int? currentIndex,
    bool? showExtraSlots,
     Map<Spot, int>? mainSpotsIndices,
     Map<Spot, int>? extraSpotsIndices,
    String? spotName,
    bool? updateResult,
    String? updateOrderSpotErrorMessage,
    RequestState? updateOrderSpotState,

  }) {
    return HomeState(
      myGaragesState: myGaragesState ?? this.myGaragesState,
      getGaragesSpotState: getGaragesSpotState ?? this.getGaragesSpotState,
      myGaragesErrorMessage: myGaragesErrorMessage ?? this.myGaragesErrorMessage,
      data: data ?? this.data,
      currentIndex: currentIndex ?? this.currentIndex,
      showExtraSlots: showExtraSlots ?? this.showExtraSlots,
      allSpots: allSpots ?? this.allSpots,
      extraSpots: extraSpots ?? this.extraSpots,
      mainSpots: mainSpots ?? this.mainSpots,
      emptySpots: emptySpots ?? this.emptySpots,
      extraSpotsIndices: extraSpotsIndices ?? this.extraSpotsIndices,
      mainSpotsIndices: mainSpotsIndices ?? this.mainSpotsIndices,
      spotName: spotName ?? this.spotName,
      getGaragesSpotErrorMessage: getGaragesSpotErrorMessage ?? this.getGaragesSpotErrorMessage,
      updateResult: updateResult ?? this.updateResult,
      updateOrderSpotErrorMessage: updateOrderSpotErrorMessage ?? this.updateOrderSpotErrorMessage,
      updateOrderSpotState: updateOrderSpotState ?? this.updateOrderSpotState,

    );
  }
}
