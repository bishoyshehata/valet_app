import 'package:equatable/equatable.dart';
import '../../../../core/utils/enums.dart';

abstract class GarageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ToggleExtraSlotsEvent extends GarageEvent {}

class SelectVehicleTypeEvent extends GarageEvent {
  final VehicleType type;

  SelectVehicleTypeEvent(this.type);

  @override
  List<Object> get props => [type];
}
