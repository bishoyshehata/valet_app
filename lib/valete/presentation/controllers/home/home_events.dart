import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {

}


class GetMyGaragesEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}
class GetGarageSpotEvent extends HomeEvent {
  late final int garageId ;
  GetGarageSpotEvent(this.garageId);
  @override
  List<Object?> get props => [garageId];
}
class UpdateOrderSpotEvent extends HomeEvent {
  late final int orderId ;
  late final int spotId ;
  late final int garageId ;
  UpdateOrderSpotEvent(this.orderId,this.spotId,this.garageId);
  @override
  List<Object?> get props => [orderId,spotId,garageId];
}
class ChangeTabEvent extends HomeEvent {
  final int index;
   ChangeTabEvent(this.index);
  @override
  List<Object> get props => [index];
}

class ToggleExtraSlotsVisibilityEvent extends HomeEvent {
  final bool show;

  ToggleExtraSlotsVisibilityEvent(this.show);

  @override
  List<Object?> get props => [];
}
class UpdateSpotNameEvent extends HomeEvent {
  final String spotName;
  UpdateSpotNameEvent(this.spotName);

  @override
  List<Object?> get props => [spotName];
}
class UpdateGarageNameEvent extends HomeEvent {
  final String garageName;
  UpdateGarageNameEvent(this.garageName);

  @override
  List<Object?> get props => [garageName];
}
class ResetSpotNameEvent extends HomeEvent {
  @override
  List<Object?> get props =>[]  ;
}


