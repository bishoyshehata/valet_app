import 'package:equatable/equatable.dart';
import '../../../../core/utils/enums.dart';

abstract class OrderEvent extends Equatable {}

class SelectVehicleType extends OrderEvent {
  final VehicleType vehicleType;
  SelectVehicleType(this.vehicleType);
  @override
  List<Object?> get props =>[vehicleType];
}
class CreateOrderEvent extends OrderEvent{
  @override
  List<Object?> get props => [];
}

class PickImageEvent extends OrderEvent {
  @override
  List<Object?> get props => [];
}
class UpdatePhoneNumberEvent extends OrderEvent {
  final String phoneNumber;
  UpdatePhoneNumberEvent(this.phoneNumber);

  @override
  List<Object?> get props =>[phoneNumber];
}
