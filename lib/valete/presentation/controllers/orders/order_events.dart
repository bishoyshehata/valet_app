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
class StoreOrderNoWhatsAppEvent extends OrderEvent {
  final StoreOrderModel storeData;
  StoreOrderNoWhatsAppEvent(this.storeData);
  @override
  List<Object?> get props => [storeData];
}class StoreOrderWithWhatsAppEvent extends OrderEvent {
  final StoreOrderModel storeData;
  StoreOrderWithWhatsAppEvent(this.storeData);
  @override
  List<Object?> get props => [storeData];
}
class CompletePhoneChanged extends OrderEvent {
  final String phoneNumber;
  final String countryCode;
  CompletePhoneChanged({required this.phoneNumber, required this.countryCode});

  @override
  List<Object?> get props => [phoneNumber, countryCode];
}