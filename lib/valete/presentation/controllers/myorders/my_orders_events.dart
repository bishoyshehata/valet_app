import 'package:equatable/equatable.dart';

abstract class MyOrdersEvent extends Equatable {}


class GetMyOrdersEvent extends MyOrdersEvent {
  final int newStatus;
  GetMyOrdersEvent(this.newStatus);
  @override
  List<Object?> get props => [newStatus];
}
class GetAllMyOrdersEvent extends MyOrdersEvent {
  @override
  List<Object?> get props => [];
}
class UpdateOrderStatusEvent extends MyOrdersEvent{
  final int orderId;
  final int newStatus;
  UpdateOrderStatusEvent(this.orderId, this.newStatus);

  @override
  List<Object?> get props => [orderId,newStatus];

}
class ResetOrderUpdateStatus extends MyOrdersEvent {
  @override
  List<Object?> get props => [];
}



