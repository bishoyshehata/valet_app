import 'package:valet_app/valete/domain/entities/get_garage_spot.dart';
import 'package:valet_app/valete/domain/entities/my_garages.dart';
import '../../../../core/utils/enums.dart';
import '../../../domain/entities/spot.dart';

class HomeState {
  final RequestState myGaragesState;
  final RequestState getGaragesSpotState;
  final String myGaragesErrorMessage;
  final String getGaragesSpotErrorMessage;
  final int getGaragesSpotStatusCode;
  final List<MyGarages>? data;
  final int? garagesStatusCode;
  final int currentIndex;
  final bool showExtraSlots;
  final GetGarageSpot? allSpots;
  final List<Spot>? extraSpots;
  final List<Spot>? mainSpots;
  final List<Spot>? emptySpots;
  final Map<Spot, int>? mainSpotsIndices;
  final Map<Spot, int>? extraSpotsIndices;
  final String spotName;
  final String garageId;
  final bool? updateResult;
  final String updateOrderSpotErrorMessage;
  final UpdateOrderSpotState updateOrderSpotState;

  HomeState({
    this.myGaragesState = RequestState.loading,
    this.getGaragesSpotState = RequestState.loading,
    this.myGaragesErrorMessage = '',
    this.getGaragesSpotErrorMessage = '',
    this.getGaragesSpotStatusCode = 0,
    this.updateOrderSpotErrorMessage = '',
    this.updateOrderSpotState = UpdateOrderSpotState.initial,
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
    this.garagesStatusCode ,
    this.spotName = 'رقم الباكية',
    this.garageId = 'رقم الباكية',

  });


  HomeState copyWith({
    RequestState? myGaragesState,
    RequestState? getGaragesSpotState,
    String? myGaragesErrorMessage,
    String? getGaragesSpotErrorMessage,
    int? getGaragesSpotStatusCode,
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
    String? garageId,
    bool? updateResult,
    String? updateOrderSpotErrorMessage,
    UpdateOrderSpotState? updateOrderSpotState,
    int? garagesStatusCode,

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
      garageId: garageId ?? this.garageId,
      getGaragesSpotErrorMessage: getGaragesSpotErrorMessage ?? this.getGaragesSpotErrorMessage,
      getGaragesSpotStatusCode: getGaragesSpotStatusCode ?? this.getGaragesSpotStatusCode,
      updateResult: updateResult ?? this.updateResult,
      updateOrderSpotErrorMessage: updateOrderSpotErrorMessage ?? this.updateOrderSpotErrorMessage,
      updateOrderSpotState: updateOrderSpotState ?? this.updateOrderSpotState,
      garagesStatusCode: garagesStatusCode ?? this.garagesStatusCode,

    );
  }
}
