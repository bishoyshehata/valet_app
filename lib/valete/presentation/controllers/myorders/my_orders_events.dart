import 'package:equatable/equatable.dart';

abstract class MyOrdersEvent extends Equatable {}


class GetMyOrdersEvent extends MyOrdersEvent {
  final int newStatus;
  GetMyOrdersEvent(this.newStatus);
  @override
  List<Object?> get props => [newStatus];
}
class GetAllMyOrdersEvent extends MyOrdersEvent {
  final List<int>? statuses; // لو null يبقى كل الحالات

  GetAllMyOrdersEvent({this.statuses});

  @override

  List<Object?> get props => [statuses];
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
class CancelMyOrderEvent extends MyOrdersEvent {
  final int orderId;
  CancelMyOrderEvent(this.orderId);
  @override
  List<Object?> get props => [orderId];
}


