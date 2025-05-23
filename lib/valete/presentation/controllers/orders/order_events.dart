import 'package:equatable/equatable.dart';
import 'package:valet_app/valete/data/models/store_order_model.dart';
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

class UpdateSpotNameEvent extends OrderEvent {
  final String spotName;
  UpdateSpotNameEvent(this.spotName);

  @override
  List<Object?> get props => [spotName];
}

class StoreOrderEvent extends OrderEvent {
  final StoreOrderModel storeData;

  StoreOrderEvent(this.storeData);

  @override
  List<Object?> get props => [storeData];

}


