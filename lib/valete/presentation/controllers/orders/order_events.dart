import 'package:equatable/equatable.dart';
import '../../../../core/utils/enums.dart';

abstract class OrderEvent extends Equatable {}

class SelectVehicleType extends OrderEvent {
  final VehicleType vehicleType;
  SelectVehicleType(this.vehicleType);
  @override
  List<Object?> get props =>[vehicleType];
}

class PickImageEvent extends OrderEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
