import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {}


class GetMyGaragesEvent extends HomeEvent {
  @override
  List<Object?> get props => [];

}
class GetMyOrdersEvent extends HomeEvent {
  final int status;
  GetMyOrdersEvent(this.status);

  @override
  List<Object?> get props => [status];

}


class ChangeTabEvent extends HomeEvent {
  final int index;

   ChangeTabEvent(this.index);

  @override
  List<Object> get props => [index];
}
class ChangeSelectedStatus extends HomeEvent {
  final int newStatus;

  ChangeSelectedStatus(this.newStatus);

  @override

  List<Object?> get props => [newStatus];
}